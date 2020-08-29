class SubsController < ApplicationController
  skip_before_action :require_login, only: [:index]
  def index
    render :index
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.user_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:alert] = 'Invalid submission. Title and description are required.'
      redirect_to new_sub_url
    end
  end

  def new
    render :new
  end

  def edit

  end

  def show

  end

  def update

  end

  def destroy

  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
