# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# Unfortunately we can't use RESTful routes until the controllers are refactored to have
#   proper pluralization of the names. (And we would have one controller for both site & admin instead of two)
# TODO: restore search routes if needed
ActionController::Routing::Routes.draw do |map|
  # Order matters!
  map.root :controller => 'post'
  
  # Aliases for backwards compatibility with older versions of simplelog
  map.connect 'comments/rss', :controller => 'comment', :action => 'feed'
  map.connect 'posts/rss', :controller => 'post', :action => 'feed'
  map.connect 'posts/:action/:id', :controller => 'post'
  map.connect 'weblog/tags/:tag', :controller => 'tag', :action => 'show'
  map.connect 'weblog/rss.xml', :controller => 'post', :action => 'feed'
  map.connect 'weblog/:action/:id', :controller => 'post'
  
  # Archives
  post_aliases = /archives|older|past|weblog|post/ # allow different root paths to access archives
  map.connect ':archive_token/:year/:month/:day/:link', :controller => 'post', :action => 'index', :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/, :archive_token => post_aliases
  map.connect ':archive_token/:year/:month/:day', :controller => 'post', :action => 'by_day', :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/, :archive_token => post_aliases
  map.connect ':archive_token/:year/:month', :controller => 'post', :action => 'by_month', :year => /\d{4}/, :month => /\d{1,2}/, :archive_token => post_aliases
  map.connect ':archive_token/:year', :controller => 'post', :action => 'by_year', :year => /\d{4}/, :archive_token => post_aliases  
  
  # Tags
  map.connect 'tag/:tag', :controller => 'tag', :action => 'show'
  
  # CMS
  map.connect 'pages/:link', :controller => 'page', :action => 'show'
  

  # search
#  map.connect 'search', :controller => 'post', :action => 'search'
#  map.connect 'search/full', :controller => 'post', :action => 'search_full'

  # Admin
  # TODO fix this horrific legacy model of routing! (namespaced routing?)
  # login/out
  map.connect 'login/do', :controller => 'author', :action => 'do_login'
  map.connect 'login', :controller => 'author', :action => 'login'
  map.connect 'logout', :controller => 'author', :action => 'logout'
  # index
  map.connect 'admin', :controller => 'admin/base', :action => 'index'
  # posts
  map.connect 'admin/posts', :controller => 'admin/posts', :action => 'post_list'
  map.connect 'admin/posts/edit/:id', :controller => 'admin/posts', :action => 'post_edit'
  map.connect 'admin/posts/new', :controller => 'admin/posts', :action => 'post_new'
  map.connect 'admin/posts/create', :controller => 'admin/posts', :action => 'post_create'
  map.connect 'admin/posts/update/:id', :controller => 'admin/posts', :action => 'post_update'
  map.connect 'admin/posts/destroy/:id', :controller => 'admin/posts', :action => 'post_destroy'
  map.connect 'admin/posts/preview', :controller => 'admin/posts', :action => 'post_preview'
  map.connect 'admin/posts/search', :controller => 'admin/posts', :action => 'post_search'
  map.connect 'admin/posts/batch/comments', :controller => 'admin/posts', :action => 'post_batch_comments'
  # pages
  map.connect 'admin/pages', :controller => 'admin/pages', :action => 'page_list'
  map.connect 'admin/pages/edit/:id', :controller => 'admin/pages', :action => 'page_edit'
  map.connect 'admin/pages/new', :controller => 'admin/pages', :action => 'page_new'
  map.connect 'admin/pages/create', :controller => 'admin/pages', :action => 'page_create'
  map.connect 'admin/pages/update/:id', :controller => 'admin/pages', :action => 'page_update'
  map.connect 'admin/pages/destroy/:id', :controller => 'admin/pages', :action => 'page_destroy'
  map.connect 'admin/pages/preview', :controller => 'admin/pages', :action => 'page_preview'
  map.connect 'admin/pages/permalink', :controller => 'admin/pages', :action => 'page_permalink'
  map.connect 'admin/pages/search', :controller => 'admin/pages', :action => 'page_search'
  # comments
  map.connect 'admin/comments', :controller => 'admin/comments', :action => 'comment_list'
  map.connect 'admin/comments/edit/:id', :controller => 'admin/comments', :action => 'comment_edit'
  map.connect 'admin/comments/update/:id', :controller => 'admin/comments', :action => 'comment_update'
  map.connect 'admin/comments/destroy/:id', :controller => 'admin/comments', :action => 'comment_destroy'
  map.connect 'admin/comments/preview', :controller => 'admin/comments', :action => 'comment_preview'
  map.connect 'admin/comments/search', :controller => 'admin/comments', :action => 'comment_search'
  map.connect 'admin/comments/approve/:id/toggle', :controller => 'admin/comments', :action => 'comment_approval'
  map.connect 'admin/comments/bypost/:id', :controller => 'admin/comments', :action => 'comments_by_post'
  map.connect 'admin/comments/toggle', :controller => 'admin/comments', :action => 'comments_toggle'
  map.connect 'admin/comments/approve/all', :controller => 'admin/comments', :action => 'comments_approve_all'
  map.connect 'admin/comments/delete/unapproved', :controller => 'admin/comments', :action => 'comments_delete_unapproved'
  # blacklist (for comments)
  map.connect 'admin/blacklist', :controller => 'admin/blacklist', :action => 'blacklist_list'
  map.connect 'admin/blacklist/update', :controller => 'admin/blacklist', :action => 'blacklist_update'
  map.connect 'admin/blacklist/remote/add/:item', :controller => 'admin/blacklist', :action => 'blacklist_add_remote'
  map.connect 'admin/blacklist/remote/destroy/:item', :controller => 'admin/blacklist', :action => 'blacklist_destroy_remote'
  map.connect 'admin/blacklist/get/rules', :controller => 'admin/blacklist', :action => 'blacklist_get_remote'
  # tags
  map.connect 'admin/tags', :controller => 'admin/tags', :action => 'tag_list'
  map.connect 'admin/tags/show/:id', :controller => 'admin/tags', :action => 'tag_show'
  map.connect 'admin/tags/edit/:id', :controller => 'admin/tags', :action => 'tag_edit'
  map.connect 'admin/tags/new', :controller => 'admin/tags', :action => 'tag_new'
  map.connect 'admin/tags/create', :controller => 'admin/tags', :action => 'tag_create'
  map.connect 'admin/tags/update/:id', :controller => 'admin/tags', :action => 'tag_update'
  map.connect 'admin/tags/destroy/:id', :controller => 'admin/tags', :action => 'tag_destroy'
  map.connect 'admin/tags/search', :controller => 'admin/tags', :action => 'tag_search'
  # authors
  map.connect 'admin/authors', :controller => 'admin/authors', :action => 'author_list'
  map.connect 'admin/authors/show/:id', :controller => 'admin/authors', :action => 'author_show'
  map.connect 'admin/authors/edit/:id', :controller => 'admin/authors', :action => 'author_edit'
  map.connect 'admin/authors/new', :controller => 'admin/authors', :action => 'author_new'
  map.connect 'admin/authors/create', :controller => 'admin/authors', :action => 'author_create'
  map.connect 'admin/authors/update/:id', :controller => 'admin/authors', :action => 'author_update'
  map.connect 'admin/authors/destroy/:id', :controller => 'admin/authors', :action => 'author_destroy'
  # prefs
  map.connect 'admin/prefs', :controller => 'admin/prefs', :action => 'prefs_list'
  map.connect 'admin/prefs/save', :controller => 'admin/prefs', :action => 'prefs_save'
  map.connect 'admin/prefs/cache/clear', :controller => 'admin/prefs', :action => 'prefs_clear_cache'
  # ping
  map.connect 'admin/ping/do', :controller => 'admin/misc', :action => 'do_ping'
  # help
  map.connect 'admin/help', :controller => 'admin/misc', :action => 'help'
  # check for updates
  map.connect 'admin/updates', :controller => 'admin/misc', :action => 'updates'
  map.connect 'admin/updates/do', :controller => 'admin/misc', :action => 'do_update_check'
  map.connect 'admin/updates/auto/toggle', :controller => 'admin/misc', :action => 'toggle_updates_check'
  # xmlrpc
  #map.connect 'xmlrpc/api', :controller => 'xmlrpc', :action => 'api' # TODO maybe make this work again? (remote control posting?)
  
  # Automatic
  map.connect ':controller/:action/:id'
  
  # Anything not already handled get a nice 404 page
  map.connect '*anything', :controller => 'application', :action => 'handle_unknown_request'
  
end

