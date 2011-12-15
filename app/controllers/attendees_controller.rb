class AttendeesController < ApplicationController
	before_filter :set_body_class
	before_filter :authenticate_user!, :except => [:available]
	before_filter :user_is_admin?, :except => [:new, :create, :available]

	def set_body_class
    @page_class = 'proposal'
  end

  def index
  	@attendees = Attendee.all.asc(:name)
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
		donation = Attendee.all.collect{ |a| a.donation }.select{ |a| !a.nil? }.inject {|s,v| s+v.to_i}

    dashboard = {
    	available: APP_CONFIG['max_attendees'] - Attendee.count,
    	lunches: Attendee.count(conditions: { lunch: true }),
    	paid: Attendee.count(conditions: { lunch_paid: true }),
    	donations: donation,
    	donation_per_person: donation.to_i / Attendee.count
    }

    respond_to do |format|
       format.json { render :json=> dashboard.to_json }
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

  def edit
    @attendee = Attendee.find(params[:id])
  end


  def update
    @attendee = Attendee.find(params[:id])

    respond_to do |format|
      if @attendee.update_attributes(params[:attendee])
        format.html { redirect_to attendees_path, notice: 'Attendee was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @attendee = Attendee.find(params[:id])
    @attendee.destroy

    respond_to do |format|
      format.html { redirect_to attendees_url }
      format.json { head :ok }
    end
  end

end