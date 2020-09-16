class SubsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show, :edit]
  before_action :require_moderator, only: [:edit]

  def index
    render :index
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.user_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:alert] = 'One or more paramaters missing.'
      render :new, status: :unprocessable_entity
    end
  end

  def new
    render :new
  end

  def edit
    @sub = Sub.find_by(id: params[:id])
    if @sub
      render :edit
    else
      if current_user
        flash.now[:alert] = "Sub not found. Try again with valid sub id."
        render :index, status: :not_found
      else
        flash.now[:alert] = "Sub not found. Try again with valid sub id and moderator status."
        render :index, status: :not_found
      end
    end
  end

  def show
    @sub = Sub.find_by(id: params[:id])
    if @sub
      render :show
    else
      flash.now[:alert] = 'No such sub!'
      render :index, status: :not_found
    end
  end

  def update

  end

  def destroy

  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def require_moderator
    @sub = Sub.find_by(id: params[:id])
    if @sub && @sub.moderator && @sub.moderator != current_user
      flash.now[:alert] = 'Edit access requires moderator status.'
      render :index, status: :unauthorized
    end
  end
end
