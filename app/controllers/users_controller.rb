class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :validate_profile_picture, only: [:create]

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
    }

    profile_picture = user_params[:profile_picture]

    supabase_service = SupabaseService.new

    supabase_response = supabase_service.sign_up(user_params[:email], user_params[:password])

    if supabase_response.success?
      @user = User.new(new_user_params)

      respond_to do |format|
        if @user.save
          session[:user_id] = @user.id

          if profile_picture
            profile_picture_public_url = supabase_service.upload_image(user_params[:profile_picture], user_params[:username])
            @user.update({profile_picture: profile_picture_public_url})
          end

          format.html { redirect_to user_url(@user), notice: "User successfully created." }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      @login_error = supabase_response.parsed_response["msg"] || "Something went wrong. Please try again."

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
      params.require(:user).permit(:username, :password, :email, :profile_picture)
    end

    def validate_profile_picture
      allowed_content_types = ['image/jpeg', 'image/png']
      profile_picture = user_params[:profile_picture]
      unless profile_picture.nil? || allowed_content_types.include?(profile_picture.content_type)
        @login_error = 'Invalid file format. Please upload a valid image.'

        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @login_error, status: :unprocessable_entity }
        end
      end
    end
end
