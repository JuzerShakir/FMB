# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction index template" do
  let(:user) { create(:user) }
  let!(:transactions) { create_list(:transaction, 2) }

  before do
    page.set_rack_session(user_id: user.id)
    visit transactions_all_path
  end

  # * ALL user types
  describe "visited by any user type can", :js do
    describe "see all transactions details" do
      it "recipe_no" do
        transactions.each do |transaction|
          recipe_no = transaction.recipe_no.to_s
          expect(page).to have_content(recipe_no)
        end
      end

      it "amount" do
        transactions.each do |transaction|
          amount = number_with_delimiter(transaction.amount)
          expect(page).to have_content(amount)
        end
      end

      it "date" do
        transactions.each do |transaction|
          date = time_ago_in_words(transaction.date)
          expect(page).to have_content(date)
        end
      end
    end

    describe "search" do
      context "with recipe number" do
        let!(:recipe) { transactions.first.recipe_no }

        before { fill_in "q_recipe_no_eq", with: recipe }

        it { within("div#transactions") { expect(page).to have_content(recipe) } }
        it { within("div#transactions") { expect(page).not_to have_content(transactions.last.recipe_no) } }
      end
    end
  end
end
