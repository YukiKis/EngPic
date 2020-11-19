class Admin::DictionariesController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @user = User.find(params[:id])
    @words = @user.dictionary.words.page(params[:page]).per(15)
  end
end
