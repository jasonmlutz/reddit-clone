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
      @user = create(:user)
      post session_url, params: { user: attributes_for(:user) }
      get new_sub_url
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    describe 'with valid params' do
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

    describe 'with invalid params' do
      it 'renders the new template with errors'
    end
  end

  describe 'GET #show' do
    it 'displays the show template' do
    end
  end

  describe 'GET #edit' do
    it 'displays the edit template'
  end

  describe 'DELETE #destroy' do
    it 'deletes the sub'
  end
end
