class ApplicationController < ActionController::Base
  private
  def admin_access
    unless current_user && current_user.username == "admin"
      redirect_to root_path
      return false
    end
  end

  def authorized_article_user
    unless logged_in? && (current_user.username == "admin" || Article.find(params[:id]).author == current_user.username)
      redirect_to root_path
      return false
    end
  end

  def authorized_comment_user
    unless logged_in? && (current_user.username == "admin" || Comment.find(params[:id]).user_name == current_user.username)
      redirect_to root_path
      return false
    end
  end


  def logged_in
    unless logged_in?
      redirect_to root_path
      return false
    end
  end

  def logged_out
    if logged_in?
      redirect_to root_path
      return false
    end
  end
end
