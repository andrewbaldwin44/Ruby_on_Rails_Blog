class SessionsController < ApplicationController
  def new
  end

  def create
    supabase_service = SupabaseService.new
    supabase_response = supabase_service.sign_in(params[:email], params[:password])
    puts supabase_response

    if supabase_response.success?
      user_data = supabase_response.parsed_response['user']

      @user = User.find_by(email: user_data["email"])
      session[:user_id] = @user.id

      redirect_to root_path, notice: 'Successfully signed in!'
    else
      @login_error = supabase_response.parsed_response['error_description'] || 'Invalid email or password'

      respond_to do |format|
        format.html { render :new, status: :unauthorized }
        format.json { render json: @login_error, status: :unauthorized }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Successfully signed out!'
  end
end
