class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :setup, except: [:index, :search, :today]
  
  def index
    @users = User.order(:id).page(params[:page]).per(15)
    @q = User.ransack(params[:q])
  end

  def show
    @words = @user.words.page(params[:page]).per(15)
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
  
  def search
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(15)
    render "index"
  end
  
  def today
    @q = User.ransack(params[:q])
    @users = User.today.page(params[:page]).per(15)
    render "index"
  end

  private
    def setup
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:name, :introduction, :email, :image)
    end
end
