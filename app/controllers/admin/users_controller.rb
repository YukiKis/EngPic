class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :setup, except: [:index, :search, :today]
  before_action :clear_session_q, except: [:index, :today, :search]
  
  def index
    session[:q] = "all"
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
    case session[:q]
    when "today"
      @q = User.today.ransack(params[:q])
    else
      @q = User.ransack(params[:q])
    end
    @users = @q.result(distinct: true).page(params[:page]).per(15)
    render "index"
  end
  
  def today
    session[:q] = "today"
    @q = User.today.ransack(params[:q])
    @users = User.today.page(params[:page]).per(15)
    render "index"
  end

  private
    def setup
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:name, :introduction, :email, :image, :is_active)
    end
end
