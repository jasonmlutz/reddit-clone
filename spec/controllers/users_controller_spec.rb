require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it "renders the new template" do
      get :new, {}
      expect(response).to render_template("new")
      expect(response).to have_http_status(200)
    end
  end

  shared_examples "redirects to new_user_url and sets flash errors" do
    before(:each) do
      post :create, params: path_options
    end
    it "redirects to new_user_url" do
      expect(response).to redirect_to new_user_url
    end
    it "sets flash errors" do
      should set_flash[:errors]
    end
  end

  describe 'POST #create' do
    context "with invalid params" do
      context "missing username" do
        let(:path_options) { {user: {password: 'good_password'}} }
        it_behaves_like "redirects to new_user_url and sets flash errors"
        # it_behaves_like "sets flash errors"
      end

      context "missing password" do
        let(:path_options) { {user: {username: 'jason'}} }
        it_behaves_like "redirects to new_user_url and sets flash errors"
        end

      context "password too short" do
        let(:path_options) { { user: { username: 'jason', password: 'smol'}}}
        it_behaves_like "redirects to new_user_url and sets flash errors"
      end

      context "username exists in db" do
        before(:all) do
          User.create!(username: 'jason', password: 'good_password')
        end
        before(:each) do
          post :create, params: { user: { username: 'jason', password: 'better_password' }}
        end
        after(:all) do
          User.last.destroy
        end
        it "redirects to new_user_url" do
          expect(response).to redirect_to new_user_url
        end
        it "sets flash errors" do
          should set_flash[:errors]
        end
      end
    end

    context "with valid params" do
      before(:each) do
        post :create, params: { user: { username: 'jason', password: 'good_password'}}
      end
      it "redirects to show" do
        expect(response).to render_template("show")
      end
      it "does not set flash errors" do
        should_not set_flash[:errors]
      end
    end
  end
end
