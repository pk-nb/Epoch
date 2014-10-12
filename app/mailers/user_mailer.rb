class UserMailer < ActionMailer::Base
  default from: 'epoch.timeline@gmail.com'

  def password_reset(user)
    @user = user
    mail(to: @user.email,
         subject: 'Reset Password - Epoch',
         template_path: 'mail')
  end
end