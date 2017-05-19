require 'rails_helper'

RSpec.describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = create(:user)
    visit login_path
    click_link "password"
    fill_in "Email", with: user.email
    click_button "Submit"
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Email sent with password reset instructions")
    expect(last_email).to deliver_to(user.email)
  end
end
