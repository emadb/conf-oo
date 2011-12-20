class AttendeeMail < ActionMailer::Base
  default from: ConfOo::Application.config.email_sender

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Conferma iscrizione UGIALT.net conference").deliver
  end

  def send_generic_mail(users, subject, body)

  	m = mail(:to =>ConfOo::Application.config.email_sender, :bcc => users.map{|u| u.email}, :subject => subject ) do |format|
  		format.text { render :text => body }	
  		format.html { render :text => body }
		end
		m.deliver
  end
end
