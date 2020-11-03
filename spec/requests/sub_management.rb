require "rails_helper"

RSpec.describe "Subs management", type: :request do

  describe 'GET #index' do
    it 'displays the index template' do
      get subs_url
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'displays the new template' do
      create(:user)
      post session_url, params: { user: attributes_for(:user) }
      get new_sub_url
      expect(response).to render_template(:new)
    end
  end

  shared_examples "shared-example: title or description missing" do
    before(:each) do
      User.destroy_all
      create(:user)
      post session_url, params: { user: attributes_for(:user) }
    end

    it "redirects to new_sub_url" do
      post subs_url, params: path_options
      expect(response).to render_template("new")
    end

    it "sets flash.now :alert" do
      expect_any_instance_of(SubsController).
        to receive_message_chain(:flash, :now, :[]=).
        with(:alert, "One or more paramaters missing.")

      flash = instance_double("flash").as_null_object
      allow_any_instance_of(SubsController).to receive(:flash).and_return(flash)

      post subs_url, params: path_options
    end

    it "should have 422 status" do
      post subs_url, params: path_options
      expect(response).to have_http_status(422)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before(:all) do
        create(:user)
        build(:sub)
        post session_url, params: { user: attributes_for(:user) }
        post subs_url, params: { sub: attributes_for(:sub) }
      end

      it "creates a new sub" do
        expect(Sub.last).to be_present
      end

      it "redirects to show" do
        @sub = Sub.last
        expect(response).to redirect_to sub_url(@sub)
      end
    end

    context 'with invalid params' do
      context 'with title missing' do
        let(:path_options) { { sub: {description: 'a sub without a title'}}}
        it_behaves_like "shared-example: title or description missing"
      end

      context 'with description missing' do
        let(:path_options) { { sub: {title: 'No Description!'}}}
        it_behaves_like "shared-example: title or description missing"
      end
    end
  end

  describe 'GET #show' do
    context "with valid sub id" do
      before(:each) do
        User.destroy_all
        Sub.destroy_all
      end
      it 'displays the show template' do
        @user = create(:user)
        @sub = create(:sub, user_id: @user.id)
        get sub_url(@sub)
        expect(response).to render_template("show")
      end
    end

    context "with invalid sub id" do
      it "renders sub index" do
        get sub_url(-1)
        expect(response).to render_template("index")
      end

      it "sets flash.now alert" do
        expect_any_instance_of(SubsController).
          to receive_message_chain(:flash, :now, :[]=).
          with(:alert, "No such sub!")

        flash = instance_double("flash").as_null_object
        allow_any_instance_of(SubsController).to receive(:flash).and_return(flash)

        get sub_url(-1)
      end

      it "has 404 status" do
        get sub_url(-1)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET #edit' do
    context "with valid sub id" do
      context "logged in as moderator" do
        before(:each) do
          User.destroy_all
          Sub.destroy_all
          @moderator = create(:user)
          @sub = create(:sub, user_id: @moderator.id)
        end
        it "renders edit template" do
          post session_url, params: { user: { username: @moderator.username, password: @moderator.password} }
          get edit_sub_url(@sub)

          expect(response).to render_template(:edit)
        end
      end

      shared_examples "shared-example: logged in as not moderator OR not logged in" do
        before(:all) do
          User.destroy_all
          Sub.destroy_all
          @moderator = create(:user, username: 'moderator')
          @sub = create(:sub, user_id: @moderator.id)
          @user = create(:user)
        end

        it "has 401 status" do
          get edit_sub_url(@sub)
          expect(response).to have_http_status(401)
        end
        it "sets flash.now :alert" do
          expect_any_instance_of(SubsController).
            to receive_message_chain(:flash, :now, :[]=).
            with(:alert, "Edit access requires moderator status.")

          flash = instance_double("flash").as_null_object
          allow_any_instance_of(SubsController).to receive(:flash).and_return(flash)

          get edit_sub_url(@sub)
        end
        it "renders subs index" do
          get edit_sub_url(@sub)
          expect(response).to render_template :index
        end
      end

      context "logged in not as moderator" do
        before(:all) do
          post session_url, params: { user: attributes_for(:user)}
        end
        it_behaves_like "shared-example: logged in as not moderator OR not logged in"
      end

      context "not logged in" do
        it_behaves_like "shared-example: logged in as not moderator OR not logged in"
      end
    end

    context "with invalid sub id" do
      context "not logged in" do
        before(:all) do
          User.destroy_all
          Sub.destroy_all
        end
        it "sets flash alert: no sub, retry and log in" do
          expect_any_instance_of(SubsController).
            to receive_message_chain(:flash, :now, :[]=).
            with(:alert, "Sub not found. Try again with valid sub id and moderator status.")

          flash = instance_double("flash").as_null_object
          allow_any_instance_of(SubsController).to receive(:flash).and_return(flash)

          get edit_sub_url(-1)
        end

        it "renders subs index" do
          get edit_sub_url(-1)
          expect(response).to render_template :index
        end

        it "has 404 response" do
          get edit_sub_url(-1)
          expect(response).to have_http_status(404)
        end
      end

      context "logged in" do
        before(:all) do
          User.destroy_all
          Sub.destroy_all
          @user = create(:user)
          post session_url, params: { user: { username: @user.username, password: @user.password} }
        end

        it "sets flash alert: no sub" do
          expect_any_instance_of(SubsController).
            to receive_message_chain(:flash, :now, :[]=).
            with(:alert, "Sub not found. Try again with valid sub id.")

          flash = instance_double("flash").as_null_object
          allow_any_instance_of(SubsController).to receive(:flash).and_return(flash)

          get edit_sub_url(-1)
        end

        it "renders subs index" do
          get edit_sub_url(-1)
          expect(response).to render_template :index
        end

        it "has 404 response" do
          get edit_sub_url(-1)
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe 'POST #update' do
    it 'updates the sub'
  end

  describe 'DELETE #destroy' do
    it 'deletes the sub'
  end
end
