# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

class CommentController < ApplicationController
  helper :site
  
  def add
    if params[:do] != '23' or (params[:not_a_robot] and params[:not_a_robot] != 'realhuman') or !params[:comment][:post_id]
      logger.warn("[Human check #{Time.sl_local.strftime('%m-%d-%Y %H%:%M:%S')}]: Comment did not pass human check so it was blocked.")
      redirect_to '/' and return false
    end
    @comment = Comment.new(params[:comment])
    @comment.ip = request.remote_ip
    if @comment.save # gets checked for spam as well?
      if Preference.get_setting('COMMENTS_APPROVED') != 'yes'
        flash[:notice] = 'Your comment will be reviewed and will appear once it is approved.'
        redirect_to params[:return_url] + "#comments"
      else
        redirect_to params[:return_url] + '#c' + @comment.id.to_s
      end
    else
      # TODO some kind of flash???
      redirect_to params[:return_url]
    end
  end
  
  # Feed for latest comments (for any post)
  def feed
    @comments = Comment.find_for_feed
    respond_to { |format| format.xml { render :layout => false } }
  end

  
  
end


