require 'test_helper'
require 'ostruct'

describe SpecialistSectorPresenter do
  describe "a sector called Oil and gas" do
    setup do
      @sector = OpenStruct.new(title: "Oil and gas")
    end

    it "strip the sector title from the artefact title" do
      artefact = OpenStruct.new(title: "Oil and gas: Wells and fields")
      sector = SpecialistSectorPresenter.new(artefact, @sector)
      assert_equal "Wells and fields", sector.title
    end

    it "upcase the first character of the remaining part of the artefact title" do
      artefact = OpenStruct.new(title: "Oil and gas: taxes")
      sector = SpecialistSectorPresenter.new(artefact, @sector)
      assert_equal "Taxes", sector.title
    end

    it "leave a non-matching artefact title intact" do
      artefact = OpenStruct.new(title: "a page about something else")
      sector = SpecialistSectorPresenter.new(artefact, @sector)
      assert_equal "a page about something else", sector.title
    end

    it "only match the sector title at the beginning of the artefact title" do
      artefact = OpenStruct.new(title: "Also about Oil and Gas: Wells")
      sector = SpecialistSectorPresenter.new(artefact, @sector)
      assert_equal "Also about Oil and Gas: Wells", sector.title
    end
  end
end
