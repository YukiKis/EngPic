class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :setup, except: :index
  
  def index
    @users = User.all
  end

  def show
  end

  def edit
    if @user !=current_user
      redirect_to user_path(@user)
    else
      @user = User.find(params[:id])
    end
  end
  
  def update
    if @user != current_user
      redirect_to user_path(@user)
    else
      if @user.update(user_params)
        redirect_to user_path(@user)
      else
        render "edit"
      end
    end
  end
  
  private
    def setup
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:image, :name, :introduction)
    end
end