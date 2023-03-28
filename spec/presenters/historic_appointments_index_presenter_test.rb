RSpec.describe HistoricAppointmentsIndexPresenter do
  describe "featured_profile_groups" do
    it "returns selection of profiles if there are any" do
      selection_of_profiles = [1, 2, 3]
      presenter = described_class.new(double(HistoricAppointmentsIndex, selection_of_profiles:))

      expect(presenter.featured_profile_groups).to eq({ selection_of_profiles: [1, 2, 3] })
    end

    it "returns an empty has if there are no selected profiles" do
      presenter = described_class.new(double(HistoricAppointmentsIndex, selection_of_profiles: nil))
      expect(presenter.featured_profile_groups).to eq({})
    end
  end

  describe "other_profile_groups" do
    it "returns the centuries data" do
      centuries_data = { "19th_century": { title: "a foreign secretary" } }
      presenter = described_class.new(double(HistoricAppointmentsIndex, centuries_data:))

      expect(presenter.other_profile_groups).to eq centuries_data
    end
  end
end
