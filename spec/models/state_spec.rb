require 'rails_helper'

RSpec.describe State, type: :model do
  let(:state) { build(:state) }

  it "is valid with valid attributes" do
    expect(state).to be_valid
  end

  it "is not valid with no state name" do
    state.name = ""
    expect(state).to_not be_valid
  end

  it "is not valid with state name longer than 45 characters" do
    state.name = 'a' * 46
    expect(state).to_not be_valid
  end

end