RSpec.describe ApplicationHelper do
  describe "#current_path_without_query_string" do
    it "returns the path of the current request" do
      controller.request = ActionDispatch::TestRequest.create("PATH_INFO" => "/foo/bar")
      expect(helper.current_path_without_query_string).to eq("/foo/bar")
    end

    it "returns the path of the current request stripping off any query string parameters" do
      controller.request = ActionDispatch::TestRequest.create("PATH_INFO" => "/foo/bar", "QUERY_STRING" => "ham=jam&spam=gram")
      expect(helper.current_path_without_query_string).to eq("/foo/bar")
    end
  end

  describe "page_text_direction" do
    context "when a left to right language script" do
      it "sets the direction wrapper class to ltr" do
        @content_item = { locale: "test_data" }
        allow(I18n).to receive(:t).and_return "ltr"
        expect(page_text_direction).to eq("ltr")
      end
    end

    context "when a right to left language script" do
      it "sets the direction wrapper class to rtl" do
        @content_item = { locale: "test_data" }
        allow(I18n).to receive(:t).and_return "rtl"
        expect(page_text_direction).to eq("rtl")
      end
    end
  end

  describe "direction_rtl_class" do
    context "when a left to right language script" do
      it "returns nil" do
        allow(I18n).to receive(:t).and_return "ltr"
        expect(direction_rtl_class).to be_nil
      end
    end

    context "when a right to right language script" do
      it "returns the class name" do
        allow(I18n).to receive(:t).and_return "rtl"
        expect(direction_rtl_class).to eq("direction-rtl")
      end

      it "returns the class with prefix when requested" do
        allow(I18n).to receive(:t).and_return "rtl"
        expect(direction_rtl_class(prefix: true)).to eq("class=direction-rtl")
      end
    end
  end

  describe "lang_attribute" do
    it "returns nil for default language" do
      I18n.with_locale(:en) do
        expect(lang_attribute).to be_nil
      end
    end
    it "returns a lang attribute string for non-default language" do
      I18n.with_locale(:ar) do
        expect(lang_attribute).to eq("lang=ar")
      end
    end
  end

  describe "dir_attribute" do
    context "when a left to right language script" do
      it "returns nil" do
        allow(I18n).to receive(:t).and_return "ltr"
        expect(dir_attribute).to be_nil
      end
    end

    context "when a right to right language script" do
      it "returns the rtl dir attribute name" do
        allow(I18n).to receive(:t).and_return "rtl"
        expect(dir_attribute).to eq("dir=rtl")
      end
    end
  end

  describe "t_lang" do
    it "t_fallback returns false if string is translated successfully" do
      I18n.backend.store_translations :en, document: { one: "string" }
      I18n.with_locale(:en) do
        expect(t_fallback("document.one", {})).to eq(false)
      end
    end

    it "t_fallback returns default locale if translated string is nil" do
      I18n.with_locale(:de) do
        expect(t_fallback("testing.nil", {})).to eq(:en)
      end
    end

    it "t_fallback returns default locale if translated string uses fallback" do
      I18n.default_locale = :en
      I18n.backend.store_translations :en, document: { one: "string" }

      I18n.with_locale(:de) do
        expect(t_fallback("document.one", {})).to eq(:en)
      end
    end

    it "t_fallback returns default locale if translated string hash is all nil" do
      I18n.default_locale = :en

      I18n.with_locale(:de) do
        I18n.backend.store_translations :de, testing: { test: { one: nil, others: nil } }
        expect(t_fallback("testing.test", { count: 2 })).to eq(:en)
      end
    end

    it "t_lang returns nil if the translated string matches the current locale" do
      I18n.backend.store_translations :en, document: { one: "string" }
      I18n.with_locale(:en) do
        expect(t_lang("document.one")).to be_nil
      end
    end

    it "t_lang returns lang attribute if translated string does not match current locale" do
      I18n.backend.store_translations :en, document: { one: "string" }

      I18n.with_locale(:de) do
        expect(t_lang("document.one")).to eq("lang=en")
      end
    end
  end
end
