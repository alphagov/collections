require "test_helper"

describe ListSet do
  it "uses ListSet::FromContentAPI by default for lists" do
    ListSet::FromContentAPI.expects(:new)
      .with(anything(), anything(), anything())
      .returns([])

    assert_equal [], ListSet.new("", "", []).to_a
  end

  it "uses ListSet::FromRummager for specialist_sector content" do
    ListSet::FromRummager.expects(:new)
      .with(anything(), anything())
      .returns([])

    assert_equal [], ListSet.new("specialist_sector", "", []).to_a
  end
end
