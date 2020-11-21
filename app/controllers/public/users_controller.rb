class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :setup_user, except: [:index, :search]
  before_action :setup_q, only: [:index, :search]
  def index
    @user = current_user # 検索フォームの表示非表示を
    @users = User.active.page(params[:page]).per(10)
  end

  def show
    @words = Word.where(user_id: @user.id).or(Word.where(user_id: @user.followings.active.ids)).page(params[:page]).per(12)
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
    render "follow.js.erb"
  end
  
  def unfollow
    current_user.unfollow(@user)
    render "unfollow.js.erb"
  end
  
  def followers
    @q = @user.followers.active.ransack(params[:q])
    @users = @user.followers.active.page(params[:page]).per(10)
    render "index"
  end
  
  def followings
    @q = @user.followings.active.ransack(params[:q])
    @users = @user.followings.active.page(params[:page]).per(10)
    render "index"
  end
  
  def search
    @user = current_user # 検索フォームの表示非表示を切り替える為
    @users = @q.result(distinct: true).page(params[:page]).per(10)
    render "index"
  end

  def leave
  end
  
  def quit
    @user.is_active = false
    @user.save
    session.clear
    redirect_to root_path, notice: "退会しました。またのご利用お待ちしております。"
  end
  
  private
    def setup_user
      @user = User.find(params[:id])
      unless @user.is_active
        redirect_to request.referer || user_path(current_user), notice: "そのユーザーはご覧いただけません。"
      end
    end
    
    def setup_q
      @q = User.active.ransack(params[:q])
    end

    def user_params
      params.require(:user).permit(:image, :name, :introduction)
    end
end
