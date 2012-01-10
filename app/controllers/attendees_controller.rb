require 'csv'

class AttendeesController < ApplicationController
	before_filter :set_body_class
	before_filter :authenticate_user!, :except => [:available]
	before_filter :user_is_admin?, :except => [:available]

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
		donation = Attendee.all.collect{ |a| a.donation }.select{ |a| !a.nil? }.inject(0) {|s,v| s+v.to_i}

    dashboard = {
    	available: APP_CONFIG['max_attendees'] - (Attendee.count - Attendee.count(conditions: { exclude: true })),
    	lunches: Attendee.count(conditions: { lunch: true, is_in_wait_list: false }),
    	paid: Attendee.count(conditions: { lunch_paid: true, is_in_wait_list: false }),
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

  def query
    @query = params[:query]
  	@attendees = eval(params[:query])	
    if params[:send_mail] != nil
      AttendeeMail.send_generic_mail(@attendees, params[:subject], params[:body])
    end
    if params[:export_csv] != nil
      dump_csv @attendees 
    else
      render :template => "attendees/index"
    end
    
  end


  def dump_csv (attendees)
    logger.info '************************'
    logger.info attendees
    logger.info '************************'
    @outfile = "attendees_" + Time.now.strftime("%m-%d-%Y") + ".csv"
    
    csv_data = CSV.generate(:col_sep => ';') do |csv|
      csv << [
      "name",
      "email",
      "t_shirt",
      "lunch",
      "lunch_paid",
      "waitlist",
      "donation",
      "notes",
      "exclude"
      ]
      attendees.each do |user|
        csv << [
        user.name,
        user.email,
        user.t_shirt,
        user.lunch,
        user.lunch_paid,
        user.is_in_wait_list,
        user.donation,
        user.note,
        user.exclude
        ]
      end
    end

    send_data csv_data,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=#{@outfile}"
  end
end