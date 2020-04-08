class TagsController < ApplicationController
  before_action :admin_access, only: [:edit, :update, :destroy]

  include TagsHelper
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update(tag_params)
    flash.notice = "Tag '#{@tag.name}' was updated!"
    redirect_to tags_path
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    flash.notice = "Tag '#{@tag.name}' was deleted!"
    redirect_to articles_path
  end
end
