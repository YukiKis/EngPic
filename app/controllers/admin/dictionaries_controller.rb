class Admin::DictionariesController < ApplicationController
  before_action :authenticate_admin!
  before_action :clear_session_q
  
  def show
    @user = User.find(params[:id])
    @words = @user.dictionary.words.page(params[:page]).per(15)
  end
end
