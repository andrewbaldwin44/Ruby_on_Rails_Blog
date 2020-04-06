module CommentsHelper
  private
  def comment_params
    params.require(:comment).permit(:user_name, :body)
  end
end
