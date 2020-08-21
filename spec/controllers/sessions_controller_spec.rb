require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
      expect(response).to have_http_status(200)
    end
  end

  shared_examples "renders new session template with 401 and errors" do
    before(:each) do
      User.create(username: 'jason', password: 'good_password')
      post :create, params: path_options
    end

    after(:each) do
      User.last.destroy
    end

    it "redirects to new_session_url" do
      expect(response).to render_template("new")
    end

    it "sets flash errors" do
      should set_flash[:errors]
    end

    it "should have 401 status" do
      expect(response).to have_http_status(401)
    end
  end

  describe 'POST #create' do
    context "with invalid params" do
      context "with correct username, incorrect password" do
        let(:path_options) { { user: {username: 'jason', password: 'bad_password'}}}
        it_behaves_like "renders new session template with 401 and errors"
      end

      context "with incorrect username, incorrect password" do
        let(:path_options) { { user: {username: 'jarmo', password: 'good_password'}}}
        it_behaves_like "renders new session template with 401 and errors"
      end

      context "with username and password both incorrect" do
        let(:path_options) { { user: {username: 'jarmo', password: 'bad_password'}}}
        it_behaves_like "renders new session template with 401 and errors"
      end
    end

    context "with valid params" do
    before(:each) do
      @user = User.new(username: 'jason', password: 'good_password')
      @user.save!
      post :create, params: { user: { username: 'jason', password: 'good_password'}}
    end

    after(:each) do
      @user.destroy
    end
      it "renders show template" do
        expect(response).to redirect_to user_url(@user)
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = User.new(username: 'jason', password: 'good_password')
      @user.save!
      post :create, params: { user: { username: 'jason', password: 'good_password'}}
      delete :destroy
    end

    after(:each) do
      @user.destroy
    end
    it "renders new template" do
      expect(response).to render_template("new")
    end
  end
end
