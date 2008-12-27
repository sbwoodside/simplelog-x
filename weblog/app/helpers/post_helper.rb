# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

module PostHelper
  
  # build html list of tags with links
  def build_tag_list(tags, archive_token = get_pref('ARCHIVE_TOKEN'), separator = ', ')
    list = ''
    for tag in tags
      list += (list != '' ? separator : '') + "<a href=\"/#{archive_token}/tags/#{tag.name}\" title=\"View posts tagged with &quot;#{tag.name}&quot;\">#{tag.name}</a>"
    end
    return list
  end
  
  # use this in views to get any posts you want (say, for instance, all posts with comments)
  # uses SQL so people can do virtually anything they want with it
  #### DEPRECATED: Site site_helper -> get_posts
  def get_posts(sql = "select * from posts where is_active = true order by created_at desc")
    logger.warn('DEPRECATED: The PostHelper method get_posts() has been deprecated. Please use Site.get_posts() instead.')
    return Post.find_flexible(sql)
  end
  
  # date/time of post linked, using formats from preferences
  def date_time_linked(post)
    return "<a href=\"#{Post.permalink(post)}\" title=\"Permalink for this post\">#{post.created_at.strftime(Preference.get_setting('date_format'))} at #{post.created_at.strftime(Preference.get_setting('time_format'))}</a>"
  end
  
  # date/time of post
  def date_time(post, hide_time = false)
    return post.created_at.strftime(Preference.get_setting('date_format')) + (hide_time ? '' : " at #{post.created_at.strftime(Preference.get_setting('time_format'))}")
  end
  
  # create post excerpt for search results
  def post_excerpt(post)
    return truncate_words(Post.strip_html(post.body), 20)
  end
  
  # same as above, but for comments
  def date_time_comment_linked(comment, post)
    return "<a href=\"#{Post.permalink(post)}\#c#{comment.id.to_s}\" title=\"Permalink for this comment\">#{comment.created_at.strftime(Preference.get_setting('date_format'))} at #{comment.created_at.strftime(Preference.get_setting('time_format'))}</a>"
  end
  
  # if there's extended content, this shows a link
  def extended_content_link(post, wrap_in_p = true)
    if post.extended != ''
      ext_link = Preference.get_setting('extended_link_text')
      ext_link = "<a href=\"#{Post.permalink(post)}\" title=\"#{ext_link}\">#{ext_link}</a>"
      return (wrap_in_p ? '<p>' : '') + ext_link + (wrap_in_p ? '</p>' : '')
    else
      return ''
    end
  end
  
  # if there's extended content, this shows it
  def extended_content_block(post)
    return (post.extended != '' ? post.extended : '')
  end
  
  # if the comment system is turned on, return comment info for a post
  def comment_info(post)
    if post.comment_status != 0
      return "<a href=\"#{Post.permalink(post)}\#comments\" title=\"Comments for this post\">#{post.comments.length.to_s}#{(post.comment_status == 2 ? ' (comments closed)' : ' (view/add your own)')}</a>"
    else
      return '(disabled)'
    end
  end
  
  # describes the current comment amount for a post in language
  def comment_count_description(post)
    if post
      return "There #{(post.comments.length == 1 ? 'is' : 'are')} #{pluralize(post.comments.length, 'comment')} on this post."
    else
      return ''
    end
  end
  
  # a link to posting, if posting comments is allowed for this post
  def add_comment_link(post)
    if post.comment_status == 1
      return '&nbsp;<a href="#post" title="Post yours &rarr;">Post yours &rarr;</a>'
    else
      return ''
    end
  end
  
  # return the commenter's name, linked if necessary
  def comment_author(comment)
    if comment.url and comment.url != ''
      return "<a href=\"#{comment.url}\" title=\"View #{comment.name}'s website\">#{comment.name}</a>"
    else
      return comment.name
    end
  end
  
  # boolean... does this post accept comments?
  def accepting_comments(post)
    return (post.comment_status == 1 ? true : false)
  end
  
  # if there are tags, return them for this post
  def tag_info(post)
    if post.tags.length > 0
      return build_tag_list(post.tags) #.sort!)
    else
      return '(none)'
    end
  end
  
  # if we are showing authors, return them for this post
  def author_info(post, prefix = 'by ', archive_token = get_pref('ARCHIVE_TOKEN'))
    url = Preference.get_setting('domain')
    url = (url != '' ? 'http://' + url : '')
    if Preference.get_setting('SHOW_AUTHOR_OF_POST') == 'yes'
      author = post.author
      return "#{prefix}<a href=\"#{url}/#{archive_token}/authors/#{author.id.to_s}\" title=\"View all posts by #{author.name}\">#{author.name}</a>"
    end
  end

end