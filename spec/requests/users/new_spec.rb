# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User New request" do
  # * NOT ACCESSIBLE
  context "when made by logged out user" do
    before { get new_user_path }

    it { expect(response).to have_http_status(:found) }
    it { expect(response).to redirect_to login_path }
  end

  context "when made by -" do
    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get new_user_path
    end

    # * NOT ACCESSIBLE
    describe "Member or Viewer" do
      let(:user) { create(:user_member_or_viewer) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * ACCESSIBLE
    describe "Admin" do
      let(:user) { create(:admin_user) }

      it { expect(response).to render_template(:new) }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
