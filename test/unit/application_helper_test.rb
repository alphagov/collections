require "test_helper"

describe ApplicationHelper do
  describe "#current_path_without_query_string" do
    it "returns the path of the current request" do
      self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => "/foo/bar"))
      assert_equal "/foo/bar", current_path_without_query_string
    end

    it "returns the path of the current request stripping off any query string parameters" do
      self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => "/foo/bar", "QUERY_STRING" => "ham=jam&spam=gram"))
      assert_equal "/foo/bar", current_path_without_query_string
    end
  end

  describe "page_text_direction" do
    context "when a left to right language script" do
      it "sets the direction wrapper class to ltr" do
        @content_item = { locale: "test_data" }
        I18n.stubs(:t).returns("ltr")
        assert_equal "ltr", page_text_direction
      end
    end

    context "when a right to left language script" do
      it "sets the direction wrapper class to rtl" do
        @content_item = { locale: "test_data" }
        I18n.stubs(:t).returns("rtl")
        assert_equal "rtl", page_text_direction
      end
    end
  end

  describe "t_lang" do
    it "t_fallback returns false if string is translated successfully" do
      I18n.backend.store_translations :en, document: { one: "string" }
      I18n.with_locale(:en) do
        assert_equal false, t_fallback("document.one", {})
      end
    end

    it "t_fallback returns default locale if translated string is nil" do
      I18n.with_locale(:de) do
        assert_equal :en, t_fallback("testing.nil", {})
      end
    end

    it "t_fallback returns default locale if translated string uses fallback" do
      I18n.default_locale = :en
      I18n.backend.store_translations :en, document: { one: "string" }

      I18n.with_locale(:de) do
        assert_equal :en, t_fallback("document.one", {})
      end
    end

    it "t_fallback returns default locale if translated string hash is all nil" do
      I18n.default_locale = :en


      I18n.with_locale(:de) do
        I18n.backend.store_translations :de, testing: { test: { one: nil, others: nil } }
        assert_equal :en, t_fallback("testing.test", count: 2)
      end
    end

    it "t_lang returns nil if the translated string matches the current locale" do
      I18n.backend.store_translations :en, document: { one: "string" }
      I18n.with_locale(:en) do
        assert_nil t_lang("document.one")
      end
    end

    it "t_lang returns lang attribute if translated string does not match current locale" do
      I18n.backend.store_translations :en, document: { one: "string" }

      I18n.with_locale(:de) do
        assert_equal "lang=en", t_lang("document.one")
      end
    end
  end
end
