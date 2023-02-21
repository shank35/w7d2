class UsersController < ApplicationController

  def index
    @users = User.all
    render :index
  end

  def new
    @users = User.all
    render :new
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to user_url(@user)
    else
      render :new
    end
  end


  private

  def user_params
    params.require(:users).permit(:new, :show, :create)
  end

end
