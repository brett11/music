#https://stackoverflow.com/questions/10121835/how-do-i-simulate-a-login-with-rspec. Bruno Peres
module ControllerTestHelpers
  def login_user
    user = FactoryGirl.create(:user)
    login(user)
  end


  def login_admin
    admin = FactoryGirl.create(:user_admin)
    login(admin)
  end

  def login(user)
    request.session[:user_id] = user.id
  end

  def current_user
    User.find(request.session[:user])
  end

  def pluralize_sym(symbol)
    symbol.to_s.pluralize.to_sym
  end
end
