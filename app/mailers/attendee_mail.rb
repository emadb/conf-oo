class AttendeeMail < ActionMailer::Base
  default from: "info@ugialt.net"

  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => user.email, :subject => "Conferma iscrizione UGIALT.net conference")
  end
end
