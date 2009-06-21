xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title get_pref('SITE_NAME') + ': Comments'
    xml.link Site.full_url
    xml.language get_pref('LANGUAGE')
    xml.webMaster get_pref('AUTHOR_EMAIL') + ' (' + get_pref('SITE_PRIMARY_AUTHOR') + ')'
    xml.copyright 'Copyright ' + get_pref('COPYRIGHT_YEAR') + (Time.sl_local.year.to_s != get_pref('COPYRIGHT_YEAR') ? '-' + Time.sl_local.year.to_s : '')
    xml.ttl '60'
    xml.pubDate( @comments.first.modified_at.to_s(:rfc822) ) if @comments.any?
    xml.description get_pref('SLOGAN')
    @comments.each do |comment|
      use_post = comment.post
      xml.item do
        xml.title Post.to_synd_title(comment.body)
        xml.link Post.permalink(use_post) + '#c' + comment.id.to_s
        xml.pubDate comment.created_at.to_s(:rfc822)
        xml.link Post.permalink(use_post) + '#c' + comment.id.to_s
        xml.author comment.name
        xml.description comment.body + '<p>Posted to: ' + link_to((get_pref('SIMPLE_TITLES') == 'yes' ? use_post.synd_title : use_post.title), Post.permalink(use_post)) + '</p>'
      end
    end
    
  end
end
