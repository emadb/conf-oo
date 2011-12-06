class SessionsController < ApplicationController

  def new
    redirect_to '/auth/twitter'
  end

	def create
    auth = request.env["omniauth.auth"]
	  user = User.where(:provider => auth['provider'], 
	                    :uid => auth['uid']).first || User.create_with_omniauth(auth)
	  session[:user_id] = user.id

    if current_user.is_admin?
      redirect_to admin_area_url
    else
      if (Time.now < Time.new(2011, 12, 12, 11, 12))
        redirect_to polls_url
      else
        redirect_to new_attendee_url
      end
    end
	end

	def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to authenticate_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end
