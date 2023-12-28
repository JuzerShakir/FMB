# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages home request" do
  # * ACCESSIBLE
  context "when made by logged out user" do
    before { get home_path }

    it { expect(response).to render_template(:home) }
    it { expect(response).to have_http_status(:ok) }
  end

  # * NOT ACCESSIBLE
  context "when made by logged in users" do
    let(:user) { create(:user) }

    before do
      post signup_path, params: {sessions: user.attributes.merge({password: user.password})}
      get home_path
    end

    it { expect(response).to redirect_to root_path }
    it { expect(response).to have_http_status(:found) }
  end
end
