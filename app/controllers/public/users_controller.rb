class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :setup, except: [:index, :search]
  
  def index
    @q = User.ransack(params[:q])
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
  
  def follow
    current_user.follow(@user)
  end
  
  def unfollow
    current_user.unfollow(@user)
  end
  
  def followers
    @users = @user.followers.all
    @q = User.ransack(params[:q])
    render "index"
  end
  
  def followings
    @users = @user.followings.all
    @q = User.ransack(params[:q])
    render "index"
  end
  
  def search
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
    render "index"
  end
  
  private
    def setup
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:image, :name, :introduction)
    end
end
