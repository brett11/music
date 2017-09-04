require 'pry'

RSpec.shared_examples "successful get request" do | action, resource, custom_params = nil|
  it "works" do
    get action, params: custom_params
    expect(response).to have_http_status(:success)
    expect(response).to render_template(action)
    expect(assigns(resource)).to be_present
  end
end

RSpec.shared_examples "unsuccessful get request" do | action, resource, redirect_destination, custom_params = nil|
  it "does not work" do
    get action
    expect(assigns(resource)).to_not be_present
    expect(response).to redirect_to(redirect_destination)
  end
end

RSpec.shared_examples "working get index controller" do |resource, custom_params = nil|
  describe "before user login" do
    it_behaves_like "successful get request", :index, resource
  end

  describe "after user login" do
    before(:example) do
      login_user
    end

    describe "with params" do
      it_behaves_like "successful get request", :index, resource, custom_params
    end
  end
end

RSpec.shared_examples "working get new controller" do |resource, redirect_destination, custom_params = nil|
  describe "before admin login" do
    it_behaves_like "unsuccessful get request", :new, resource, redirect_destination
  end

  describe "after admin login" do
    before(:example) do
      login_admin
    end

    it_behaves_like "successful get request", :new, resource
  end
end