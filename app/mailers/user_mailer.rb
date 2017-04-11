class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    #need to set @user instance variable for mailer views
    @user = user
    @greeting = "Hi #{user.name_first}"
    mail to: user.email, subject: 'Account activation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    #need to set @user instance variable for mailer views
    @user = user
    @greeting = "Hi #{user.name_first}"
    mail to: user.email, subject: 'Password reset'
  end
end
