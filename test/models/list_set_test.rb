require "test_helper"

describe ListSet do
  it "uses ListSet::Section by default for lists" do
    ListSet::Section.expects(:new)
      .with(anything(), anything(), anything())
      .returns([])

    assert_equal [], ListSet.new("", "", []).to_a
  end

  it "uses ListSet::Specialist for specialist_sector content" do
    ListSet::Specialist.expects(:new)
      .with(anything(), anything())
      .returns([])

    assert_equal [], ListSet.new("specialist_sector", "", []).to_a
  end
end
