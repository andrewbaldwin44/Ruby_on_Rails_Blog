class UserSessionsController < ApplicationController
  def new
  end

  def create
    if login(params[:email], params[:password])
      redirect_back_or_to(articles_path, notice: "Logged in succesfully!")
    else
      flash.notice = "Login failed!"
      render action: :new
    end
  end

  def destroy
    logout
    redirect_back_or_to(articles_path, notice: "Logged out!")
  end
end
