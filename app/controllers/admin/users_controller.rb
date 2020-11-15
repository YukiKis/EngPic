class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :setup, except: :index
  
  def index
    @users = User.page(params[:page]).per(20)
  end

  def show
    @words = @user.words.page(params[:page]).per(20)
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
    else
      render "edit"
    end
  end

  private
    def setup
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:name, :introduction, :email, :image)
    end
end
