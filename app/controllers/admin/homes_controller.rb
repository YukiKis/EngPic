class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  
  def top
    @users_today = User.today.count
    @words_today = Word.today.count
  end
end
