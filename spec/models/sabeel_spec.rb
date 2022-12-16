require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe Sabeel, :type => :model do
    subject { build(:sabeel) }
    let(:persisted_sabeel) { create(:sabeel) }

    context "validations of" do
        before do
            Sabeel.skip_callback(:save, :before, :capitalize_hof_name)
        end

        context "ITS attribute" do
            it { should validate_numericality_of(:its).only_integer }

            it { should validate_numericality_of(:its).is_in(10000000..99999999) }

            it { should validate_uniqueness_of(:its) }

            it { should validate_presence_of(:its) }
        end

        context "Email attribute" do
            it { should validate_email_format_of(:email) }
        end

        context "HOF name" do
            it { should validate_presence_of(:hof_name) }

            it { should validate_uniqueness_of(:hof_name).scoped_to(:its) }
        end

        context "BuildingName attribute" do
            let(:phase_1) { [:mohammedi, :saifee, :jamali, :taiyebi, :imadi, :burhani, :zaini, :fakhri, :badri] }
            let(:phase_2) { [:maimoon, :qutbi, :najmi] }
            let(:phase_3) { [:husami, :noorani] }

            let(:buildings) { Array.new.push(*phase_1, *phase_2, *phase_3) }

            it { should validate_presence_of(:building_name) }

            it { should define_enum_for(:building_name).with_values(buildings) }
        end

        context "Address attribute" do
            it { should validate_presence_of(:address) }

            it "must be in a specific format" do
                expect(subject.address).to match(/\A[a-z]+ [a-z]+ \d+\z/i)
            end
        end

        context "Mobile attribute" do
            it { should validate_numericality_of(:mobile).only_integer }

            it { should validate_numericality_of(:mobile).is_in(1000000000..9999999999) }

            it { should validate_presence_of(:mobile) }

        end

        context "takes_thaali attribute" do
            # NOT RECOMMENDED BY SHOULDA-MATCHERS GEM
            # it { should validate_inclusion_of(:takes_thaali).in_array([true, false]) }

            it "should default to false after creating a sabeel instance" do
                expect(persisted_sabeel.takes_thaali).not_to be
            end
        end

        after do
            Sabeel.set_callback(:save, :before, :capitalize_hof_name)
        end
    end

    context "instance method" do
        context "capitalize_hof_name" do

            it { is_expected.to callback(:capitalize_hof_name).before(:save) }

            it "must return capitalized name" do
                expect(subject).to receive(:capitalize_hof_name).and_return("Juzer Shabbir Shakir")
                subject.save
            end
        end
    end

end