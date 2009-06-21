xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title get_pref('SITE_NAME')
    xml.link Site.full_url
    xml.language get_pref('LANGUAGE')
    xml.webMaster "#{get_pref('AUTHOR_EMAIL')} (#{get_pref('SITE_PRIMARY_AUTHOR')})"
    xml.copyright 'Copyright ' + get_pref('COPYRIGHT_YEAR') + (Time.sl_local.year.to_s != get_pref('COPYRIGHT_YEAR') ? '-' + Time.sl_local.year.to_s : '')
    xml.ttl '60'
    xml.pubDate( @posts.first.modified_at.to_s(:rfc822) ) if @posts.any?
    xml.description get_pref('SLOGAN')
    @posts.each do |post|
      xml.item do
        xml.title( get_pref('SIMPLE_TITLES') == 'yes' ? post.synd_title : post.title )
        xml.link Post.permalink(post)
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.guid Post.permalink(post)
        if get_pref('SHOW_AUTHOR_OF_POST') == 'yes' and post.author
          xml.author "#{post.author.email} (#{post.author.name})"
        end
        xml.description post.body + ((post.extended and post.extended != '') ? post.extended : '')
        post.tags.each do |tag|
          xml.category tag, "domain" => "#{Site.full_url}/#{get_pref('ARCHIVE_TOKEN')}/tags/#{tag}"
        end
      end
    end
  end
end
