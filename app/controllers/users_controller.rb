class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users/1 or /users/1.json
  def show
    redirect_to new_user_path unless signed_in?
  end

  # GET /users/new
  def new
    if signed_in?
      redirect_to root_path, notice: "You are already signed in."
    else
      @user = User.new
    end
  end

  # GET /users/1/edit
  def edit
    redirect_to new_user_path unless signed_in?
  end

  # POST /users or /users.json
  def create
    new_user_params = {
      email: user_params[:email],
      username: user_params[:username],
      profilePicture: user_params[:profilePicture],
    }

    supabase_service = SupabaseService.new
    supabase_response = supabase_service.sign_up(user_params[:email], user_params[:password])

    if supabase_response.success?
      @user = User.new(new_user_params)

      respond_to do |format|
        if @user.save
          session[:user_id] = @user.id

          format.html { redirect_to user_url(@user), notice: "User successfully created." }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      supabase_error_message = supabase_response.parsed_response["msg"] || "Something went wrong. Please try again."

      @user = User.new(new_user_params)
      @user.errors.add(:base, supabase_error_message)

      respond_to do |format|
        format.html { render :new, status: :unauthorized }
        format.json { render json: @user.errors, status: :unauthorized }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :email, :profilePicture)
    end
end
