# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions New template" do
  let(:user) { create(:user) }

  before { visit login_path }

  it do
    expect(page).to have_title "Login"
    # Logo
    expect(page).to have_css("img[src*='logos/fmb']")
    expect(page).to have_css("#footer")
  end

  describe "logging in" do
    before { fill_in "sessions_its", with: user.its }

    context "with valid credentials" do
      before do
        fill_in "sessions_password", with: user.password
        click_on "Login"
      end

      it "redirects to default and greets user" do
        expect(page).to (have_current_path thaalis_all_path(CURR_YR, format: :html)).and have_content("Afzalus Salaam")
      end
    end

    context "with invalid credentials" do
      before do
        fill_in "sessions_password", with: ""
        click_on "Login"
      end

      it "displays validation error" do
        expect(page).to have_content("Invalid credentials")
      end
    end
  end
end
