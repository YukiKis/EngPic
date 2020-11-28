class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :clear_session_q, except: [:index, :followers, :followings, :search]
  before_action :setup_user, except: [:index, :search]
  def index
    session[:q] = "all"
    @q = User.active.ransack(params[:q])
    @user = current_user # 検索フォームの表示非表示を切り替えるため
    @users = User.active.page(params[:page]).per(10)
  end

  def show
    @words = Word.where(user_id: @user.id).or(Word.where(user_id: @user.followings.active.ids)).page(params[:page]).per(12)
  end

  def edit
    if @user != current_user
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
    render "follow.js.erb"
  end
  
  def unfollow
    current_user.unfollow(@user)
    render "unfollow.js.erb"
  end
  
  def followers
    session[:q] = "followers"
    @q = @user.followers.active.ransack(params[:q])
    @users = @user.followers.active.page(params[:page]).per(10)
    render "index"
  end
  
  def followings
    session[:q] = "followings"
    @q = @user.followings.active.ransack(params[:q])
    @users = @user.followings.active.page(params[:page]).per(10)
    render "index"
  end
  
  def search
    @user = current_user # 検索フォームの表示非表示を切り替える為
    case session[:q]
    when "followers"
      @q = @user.followers.active.ransack(params[:q])
    when "followings"
      @q = @user.followings.active.ransack(params[:q])
    else
      @q = User.all.active.ransack(params[:q])
    end
    @users = @q.result(distinct: true).page(params[:page]).per(10)
    render "index"
  end

  def leave
  end
  
  def quit
    if current_user = @user
      @user.is_active = false
      @user.save
      session.clear
      redirect_to root_path, notice: "退会しました。またのご利用お待ちしております。"
    end
  end
  
  private
    def setup_user
      @user = User.find(params[:id])
      unless @user.is_active
        redirect_to request.referer || user_path(current_user), notice: "そのユーザーはご覧いただけません。"
      end
    end

    def user_params
      params.require(:user).permit(:image, :name, :introduction, :email)
    end
end
