require 'pry'

RSpec.shared_examples "successful get request" do | action, resource, custom_params = nil|
  it "works" do
    get action, params: custom_params
    expect(response).to have_http_status(:success)
    expect(response).to render_template(action)
    expect(assigns(resource)).to be_present
  end
end

RSpec.shared_examples "unsuccessful get request" do | action, resource, redirect_destination = :root, custom_params = nil|
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

RSpec.shared_examples "working post create controller" do |resource, new_resource_params = nil|
  describe "before admin login" do
    it "does not allow" do
      post :create, params: {resource => new_resource_params}
      expect(assigns(resource)).to_not be_present
      expect(response).to redirect_to(:root)
    end
  end

  describe "after admin login" do
    before(:example) do
      login_admin
    end

    it "redirects to albums_url upon successful album creation and shows flash" do
      #binding.pry
      post :create, params: {resource => new_resource_params}
      expect(assigns(resource)).to be_present
      #pg 57 of Rails testing book
      expect(response).to redirect_to(pluralize_sym(resource))
      #pg 143 of Rails testing book
      expect(flash[:success]).to eq("#{resource.to_s.capitalize} successfully added.")
    end

    it "renders new upon venue creation failure" do
      #pg 123 of rails testing book. see commented out version of this in venue class for example of how this works in one class
      class_obj = Object.const_get(resource.to_s.capitalize)
      resource_partial_stub = class_obj.new(new_resource_params)
      expect(resource_partial_stub).to receive(:save).and_return(false)
      expect(class_obj).to receive(:new_from_controller).and_return(resource_partial_stub)
      post :create, params: {resource => new_resource_params}
      expect(response).to render_template(:new)
    end
  end
end

RSpec.shared_examples "working get edit controller" do |resource, instance, new_resource_params = nil|
  describe "before admin login" do
    it "does not work" do
      get :edit, params: {id: instance.id }
      expect(assigns(resource)).to_not be_present
      expect(response).to redirect_to(:root)
    end
  end

  describe "after login" do
    before(:example) do
      login_admin
    end

    it "does work" do
      get :edit, params: {id: instance.id  }
      expect(assigns(resource)).to be_present
      expect(response).to render_template(:edit)
    end
  end
end


RSpec.shared_examples "working post update controller" do |resource, instance, attribute, value|
  describe "before admin login" do
    it "does not allow" do
      post :update, params: {id: instance.id, resource => {attribute => value}}
      expect(assigns(resource)).to_not be_present
      expect(response).to redirect_to(:root)
    end
  end

  describe"after admin login" do
    before(:example) do
      login_admin
    end

    it "redirects to concerts_url upon successful creation and shows flash" do
      post :update, params: {id: instance.id, resource => {attribute => value}}
      expect(assigns(resource)).to be_present
      #pg 57 of Rails testing book
      expect(response).to redirect_to(instance)
      #pg 143 of Rails testing book
      expect(flash[:success]).to eq("#{resource.to_s.capitalize} info successfully updated")
    end

    it "renders edit upon update failure" do
      #posting below without dateandtime, which will cause failure of update
      #binding.pry
      post :update, params: {id: instance.id, resource => {attribute => ""}}
      #pg 141 of Rails testing book
      expect(response).to render_template(:edit)
    end
  end
end