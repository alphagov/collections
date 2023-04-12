RSpec.describe EmbassiesIndexPresenter::Embassy do
  let(:embassy_data) { { "assistance_available" => assistance_available } }

  subject(:embassy) { described_class.new(embassy_data) }

  context "when assistance_available is local" do
    let(:assistance_available) { "local" }

    it "can assist british citizens" do
      expect(embassy.can_assist_british_nationals?).to be_truthy
    end

    it "can assist in location" do
      expect(embassy.can_assist_in_location?).to be_truthy
    end
  end

  context "when assistance_available is remote" do
    let(:assistance_available) { "remote" }

    it "can assist british citizens" do
      expect(embassy.can_assist_british_nationals?).to be_truthy
    end

    it "cannot assist in location" do
      expect(embassy.can_assist_in_location?).to be_falsey
    end
  end

  context "when assistance_available is none" do
    let(:assistance_available) { "none" }

    it "cannot assist british citizens" do
      expect(embassy.can_assist_british_nationals?).to be_falsey
    end

    it "cannot assist in location" do
      expect(embassy.can_assist_in_location?).to be_falsey
    end
  end
end
