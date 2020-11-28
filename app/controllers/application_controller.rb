class ApplicationController < ActionController::Base
  protected
    def clear_session_q
    	if session[:q]
    		session[:q].clear
    	end
    end
end
