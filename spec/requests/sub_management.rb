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

  shared_examples "redirects to new sub template with 422 and alert" do
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
        it_behaves_like "redirects to new sub template with 422 and alert"
      end

      context 'with description missing' do
        let(:path_options) { { sub: {title: 'No Description!'}}}
        it_behaves_like "redirects to new sub template with 422 and alert"
      end
    end
  end

  describe 'GET #show' do
    context "with valid sub id" do
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
    it 'displays the edit template'
  end

  describe 'DELETE #destroy' do
    it 'deletes the sub'
  end
end
