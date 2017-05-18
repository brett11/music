require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "is not valid with no first name" do
    user.name_first = ""
    expect(user).to_not be_valid
  end

  it "is not valid with first name longer than 45 characters" do
    user.name_first = 'a' * 46
    expect(user).to_not be_valid
  end

  it "is not valid with no last name" do
    user.name_last = ""
    expect(user).to_not be_valid
  end

  it "is not valid with last name longer than 45 characters" do
    user.name_last = 'a' * 46
    expect(user).to_not be_valid
  end

  it "is not valid with no password" do
    user = build(:user, password: "")
    expect(user).to_not be_valid
  end

  it "is not valid with password shorter than 6 characters" do
    user.password = 'a' * 5
    expect(user).to_not be_valid
  end

  it "is not valid with no password confirmation" do
    user = build(:user, password_confirmation: "")
    expect(user).to_not be_valid
  end

  it "is not valid when password and password_confirmation do not match" do
    user = build(:user, password: "foobaz", password_confirmation: "foobarrr")
    expect(user).to_not be_valid
  end

  it "is not valid with wrong email format" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid, "#{invalid_address.inspect} should be invalid"
      end
  end

  it "is not valid with email over 240 characters" do
    domain_name = '@example.com'
    local_part = 'a' * (241 - domain_name.size)
    user.email = local_part + domain_name
    expect(user).to_not be_valid
  end

  it "is not valid with non-unique email" do
    user1 = create(:user, email:"foo@example.com")
    expect(user1).to be_valid
    user2 = build(:user, email:"foo@example.com")
    expect(user2).to_not be_valid
  end

  specify "email addresses is saved as lowercase" do
      mixed_case_email = "foO@bAz.cOm"
      user.email = mixed_case_email
      user.save!
      expect(user.reload.email).to eq(mixed_case_email.downcase)
  end

  specify "first name is saved in title case" do
    mixed_case_first_name = "jOhnny"
    user.name_first = mixed_case_first_name
    user.save!
    expect(user.reload.name_first).to eq(mixed_case_first_name.downcase.capitalize)
  end

  specify "last name is saved in title case" do
    mixed_case_last_name = "sMiTH"
    user.name_first = mixed_case_last_name
    user.save!
    expect(user.reload.name_first).to eq(mixed_case_last_name.downcase.capitalize)
  end

end