class AttendeeMail < ActionMailer::Base
  default from: ConfOo::Application.config.email_sender

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Conferma iscrizione UGIALT.net conference")
  end
end
