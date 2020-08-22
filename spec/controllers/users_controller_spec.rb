require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it "renders the new template" do
      get :new, {}
      expect(response).to render_template("new")
      expect(response).to have_http_status(200)
    end
  end

  shared_examples "renders new with errors and 422 status" do
    before(:each) do
      post :create, params: path_options
    end
    it "renders new template" do
      expect(response).to render_template("new")
    end
    it "sets flash.now errors" do
      should set_flash.now[:errors]
    end
    it "has 422 status" do
      expect(response).to have_http_status(422)
    end
  end

  describe 'POST #create' do
    context "with invalid params" do
      context "missing username" do
        let(:path_options) { {user: {password: 'good_password'}} }
        it_behaves_like "renders new with errors and 422 status"
        # it_behaves_like "sets flash errors"
      end

      context "missing password" do
        let(:path_options) { {user: {username: 'jason'}} }
        it_behaves_like "renders new with errors and 422 status"
        end

      context "password too short" do
        let(:path_options) { { user: { username: 'jason', password: 'smol'}}}
        it_behaves_like "renders new with errors and 422 status"
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
        it "renders new template" do
          expect(response).to render_template("new")
        end
        it "sets flash errors" do
          should set_flash.now[:errors]
        end
        it "has 422 status" do
          expect(response).to have_http_status(422)
        end
      end
    end

    context "with valid params" do
      before(:each) do
        post :create, params: { user: { username: 'jason', password: 'good_password'}}
        @user = User.last
      end
      it "redirects to show" do
        expect(response).to redirect_to user_url(@user)
      end
      it "does not set flash errors" do
        should_not set_flash[:errors]
      end
    end
  end
end
