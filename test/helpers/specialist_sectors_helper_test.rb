require 'test_helper'
require 'ostruct'

describe SpecialistSectorsHelper do

  describe "specialist_sector_item_title" do
    before do
      @sector = OpenStruct.new(title: "Oil and gas")
    end

    it "strips the sector title from the provided string" do
      assert_equal "Wells and fields", specialist_sector_item_title("Oil and gas: Wells and fields", @sector)
    end

    it "upcases the first character of the remaining part of the string" do
      assert_equal "Taxes", specialist_sector_item_title("Oil and gas: taxes", @sector)
    end

    it "leaves a non-matching string intact" do
      assert_equal "a page about something else", specialist_sector_item_title("a page about something else", @sector)
    end

    it "only matches the sector title at the beginning of the string" do
      assert_equal "Also about Oil and Gas: Wells", specialist_sector_item_title("Also about Oil and Gas: Wells", @sector)
    end
  end
end
