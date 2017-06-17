require 'pry'
require 'rails_helper'

RSpec.describe "SignUp" do
  it "creates user and sends activation email when user signs up" do
    user_params = attributes_for(:user)
    user_count_before = User.count
    visit root_path
    click_link "Sign up"
    fill_in "First name", with: user_params[:name_first]
    fill_in "Last name", with: user_params[:name_last]
    fill_in "Email", with: user_params[:email]
    fill_in "Password", with: user_params[:password]
    fill_in "Confirm password", with: user_params[:password_confirmation]
    click_button "Create new account"
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    expect(page).to have_current_path(root_path)
    user_count_after = User.count
    expect(user_count_after - user_count_before).to eq(1)
    expect(page).to have_content("Please check your email to activate your account.")
    expect(last_email).to deliver_to(user_params[:email])
    expect(last_email).to have_subject(/Account activation/)
    expect(last_email).to have_body_text(/Hi #{user_params[:name_first]}/)
    #binding.pry
  end
end