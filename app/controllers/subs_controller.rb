class SubsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
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
end
