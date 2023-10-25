# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Index request" do
  # * NOT ACCESSIBLE
  context "when made by logged out user" do
    let(:user) { create(:user) }

    before { get users_path }

    it { expect(response).to have_http_status(:found) }
    it { expect(response).to redirect_to login_path }
  end

  context "when made by -" do
    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get users_path
    end

    # * NOT ACCESSIBLE
    describe "Member or Viewer" do
      let(:user) { create(:user_other_than_admin) }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to root_path }
    end

    # * ACCESSIBLE
    describe "Admin" do
      let(:user) { create(:admin_user) }

      it { expect(response).to render_template(:index) }
      it { expect(response).to have_http_status(:ok) }
    end
  end
end
