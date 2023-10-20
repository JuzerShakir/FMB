# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User request" do
  # * Log Out users
  describe "Logged out users cannot access" do
    let(:user) { create(:user) }

    # * NEW
    describe "GET /new" do
      before { get new_user_path }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * SHOW
    describe "GET /show" do
      before { get user_path(user) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * EDIT
    describe "GET /edit" do
      before { get edit_user_path(user) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end

    # * INDEX
    describe "GET /index" do
      before { get users_path }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to login_path }
    end
  end

  # * Accessible by Admin & Member
  describe "'Admin' & 'Member' can access 👉" do
    let(:user) { create(:user_other_than_viewer) }

    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end

    # * SHOW
    describe "GET /show" do
      before { get user_path(user) }

      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * EDIT
    describe "GET /edit" do
      before { get edit_user_path(user) }

      it { expect(response).to render_template(:edit) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * UPDATE
    describe "PATCH /update" do
      context "with valid attributes" do
        let(:password) { attributes_for(:user)[:password] }

        before do
          hash_params = {password:, password_confirmation: password}
          patch user_path(user), params: {user: user.attributes.merge(hash_params)}
        end

        it "redirects to updated user" do
          expect(response).to redirect_to user
        end
      end

      context "with invalid attributes" do
        let(:password) { nil }

        before do
          hash_params = {password:, password_confirmation: password}
          patch user_path(user), params: {user: user.attributes.merge(hash_params)}
        end

        it { expect(response).to render_template(:edit) }
      end
    end

    # * DESTROY themselves
    describe "DELETE /destroy" do
      before { delete user_path(user) }

      it "destroys the user" do
        expect(User.find_by(id: user.id)).to be_nil
      end

      it "redirects to the login path" do
        expect(response).to redirect_to login_path
      end
    end
  end

  # * NOT ACCESSIBLE by viewer
  describe "'Viewer' CANNOT access 👉" do
    let(:viewer) { create(:viewer_user) }

    before do
      post signup_path, params: {sessions: viewer.attributes.merge({password: viewer.password})}
    end

    #  * NEW
    describe "GET /new" do
      before { get new_user_path }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * SHOW
    describe "GET /show" do
      before { get user_path(viewer) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * EDIT
    describe "GET /edit" do
      before { get edit_user_path(viewer) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * DESTROY
    describe "DELETE /destroy" do
      before { delete user_path(viewer) }

      it "destroys the user" do
        expect(User.find_by(id: viewer.id)).not_to be_nil
      end

      it { expect(response).to redirect_to root_path }
    end
  end

  # * Accessible by ADMIN
  describe "'Admin' can access 👉" do
    let(:admin) { create(:admin_user) }
    let(:other_user) { create(:user) }

    before do
      post signup_path, params: {sessions: admin.attributes.merge({password: admin.password})}
    end

    # * NEW
    describe "GET /new" do
      before { get new_user_path }

      it { expect(response).to render_template(:new) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * CREATE
    describe "POST /create" do
      let(:user) { attributes_for(:user) }

      before { get new_user_path }

      context "with valid attributes" do
        before { post users_path, params: {user:} }

        it { expect(response).to have_http_status(:found) }

        it "redirects to index path of User" do
          expect(response).to redirect_to users_path
        end
      end

      describe "with invalid attributes" do
        before { post users_path, params: {user: user.merge(its: nil)} }

        it { expect(response).to render_template(:new) }
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end

    # * SHOW page of other users
    describe "GET show of other user" do
      before { get user_path(other_user) }

      it { expect(response).to render_template(:show) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * INDEX
    describe "GET index" do
      before { get users_path }

      it { expect(response).to render_template(:index) }
      it { expect(response).to have_http_status(:ok) }
    end

    # * DESTROY other users
    describe "DELETE destroy" do
      before { delete user_path(other_user) }

      it "destroys the other user" do
        expect(User.find_by(id: other_user.id)).to be_nil
      end

      it "redirects to the login path" do
        expect(response).to redirect_to users_path
      end
    end
  end

  # * Member & Viewer CANNOT
  describe "'Member' & 'Viewer', CANNOT access 👉" do
    let(:user) { create(:user_other_than_admin) }
    let(:other_user) { create(:user_other_than_admin) }

    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
    end

    # * NEW
    describe "GET new" do
      before { get new_user_path }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * SHOW page of other users
    describe "GET show of other user" do
      before { get user_path(other_user) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * INDEX
    describe "GET index" do
      before { get users_path }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end
  end
end
