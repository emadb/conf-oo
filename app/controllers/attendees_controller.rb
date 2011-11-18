class AttendeesController < ApplicationController
	before_filter :set_body_class
			
	def set_body_class
    @page_class = 'proposal'
  end
	
	def new
		@attendee = Attendee.new
		@attendee.name = current_user.name
		@attendee.email = current_user.email
		@attendee.twitter = current_user.nickname
		@attendee.uid = current_user.uid
		@attendee.provider = current_user.provider
	end

	def create
		@attendee = Attendee.new(params[:attendee])
		if @attendee.save
			render :action => 'confirm' 
		else
			render :action => 'new'
		end
	end

end