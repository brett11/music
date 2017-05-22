require 'rails_helper'

RSpec.describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = create(:user)
    visit login_path
    click_link "password"
    fill_in "Email", with: user.email
    click_button "Submit"
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Email sent with password reset instructions")
    expect(last_email).to deliver_to(user.email)
    expect(last_email).to have_subject(/Password reset/)
    expect(last_email).to have_body_text(/To reset your password click on the link below:/)
  end
end
