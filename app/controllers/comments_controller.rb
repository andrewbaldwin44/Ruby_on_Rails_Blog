class CommentsController < ApplicationController
  include CommentsHelper
  def index
  end
  def create
    @comment = Comment.new(comment_params)
    @comment.user_name = current_user.username
    @comment.article_id = params[:article_id]
    @comment.save
    redirect_to article_path(@comment.article)
  end

  def edit
    @comment = Comment.find(params[:id])
    @comment.article_id = params[:article_id]
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    flash.notice = "Your comment was updated!"
    redirect_to article_path(@comment.article_id)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash.notice = "Your comment was deleted!"
    redirect_to article_path(@comment.article_id)
  end
end
