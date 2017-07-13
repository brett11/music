#https://stackoverflow.com/questions/10121835/how-do-i-simulate-a-login-with-rspec. Bruno Peres
module FeatureTestHelpers
  def login_admin
    admin = FactoryGirl.create(:user_admin)
    login(admin)
  end

  def login(user)
    visit root_path
    click_link "Log in"
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    click_button 'Log in'
  end

end
