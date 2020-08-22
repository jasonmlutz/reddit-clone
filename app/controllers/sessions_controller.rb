class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )
    if @user
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:alert] = 'Invalid credentials.'
      render :new, status: :unauthorized
    end
  end

  def destroy
    logout!
    render :new
  end
end
