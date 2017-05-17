require 'rails_helper'

RSpec.describe "PasswordResets" do
  it "emails user when requesting password reset" do
    get password_resets_path
    expect(response).to have_http_status(200)
  end
end
