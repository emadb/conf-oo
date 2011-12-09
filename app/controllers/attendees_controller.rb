class AttendeesController < ApplicationController
	before_filter :set_body_class
	before_filter :authenticate_user!, :except => [:available]
	before_filter :user_is_admin?, :except => [:new, :create, :available]

	def set_body_class
    @page_class = 'proposal'
  end
	
	def new
		if (Time.now < APP_CONFIG['open_registration_date'])
			redirect_to root_url
		end
		@attendee = Attendee.new
		@attendee.name = current_user.name
		@attendee.email = current_user.email
		@attendee.twitter = current_user.nickname
		@attendee.uid = current_user.uid
		@attendee.provider = current_user.provider
	end
	def available
		available = APP_CONFIG['max_attendees'] - Attendee.count
		respond_to do |format|
       format.json { render :json=> available.to_json }
    end
	end

	def create
		@attendee = Attendee.new(params[:attendee])

		if Attendee.count > APP_CONFIG['max_attendees']
			@attendee.is_in_wait_list = true
		end	

		if @attendee.is_new
			if @attendee.save
				if @attendee.is_in_wait_list 
					render :action => 'sold_out'
				else
					#send mail
					AttendeeMail.welcome_email(@attendee)
					render :action => 'confirm' 
				end
			else
				render :action => 'new'
			end
		else
			render :action => 'already_registered'
		end

	end
end