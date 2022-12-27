require "rails_helper"

RSpec.describe "ThaaliTakhmeen features" do
    context "creates ThaaliTakhmeen" do
        before do
            sabeel = FactoryBot.create(:sabeel)
            visit sabeel_path(sabeel.slug)

            click_on "New Takhmeen"
            expect(current_path).to eql("/sabeels/#{sabeel.slug}/takhmeens/new")
            expect(page).to have_css('h1', text: "New Takhmeen")

            attributes = FactoryBot.attributes_for(:thaali_takhmeen).extract!(:year,:number, :total, :size)
            @size = attributes.extract!(:size)

            attributes.each do |k, v|
                fill_in "thaali_takhmeen_#{k}",	with: "#{v}"
            end
        end

        scenario "with valid values" do
            select @size.fetch(:size).to_s.titleize, from: :thaali_takhmeen_size

            click_button "Create Thaali takhmeen"

            thaali_takhmeen = ThaaliTakhmeen.last
            expect(current_path).to eql("/takhmeens/#{thaali_takhmeen.slug}")
            expect(page).to have_content("Thaali Takhmeen created successfully")
        end


        scenario "with invalid values" do
            click_button "Create Thaali takhmeen"

            # we haven't selected any apartment, which is required, hence sabeel will not be saved
            expect(page).to have_content("Please review the problems below:")
            expect(page).to have_content("Size cannot be blank")
        end
    end
end