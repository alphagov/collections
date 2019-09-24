require "test_helper"

class DocumentTypeInspectorTest < ActiveSupport::TestCase
  def subject
    @subject ||= DocumentTypeInspector.new(:slug)
  end

  context "content-store lookup throws an error" do
    setup do
      @error = GdsApi::HTTPNotFound.new("asd")
      stub_content_store_raises(@error)
    end

    context "#document_type" do
      should "return nil" do
        assert_nil subject.document_type
      end
    end

    context "#error" do
      should "return the error" do
        subject.document_type
        assert subject.error == @error
      end
    end
  end

  def stub_content_store_raises(error)
    Services.expects(:content_store).raises(error)
  end

  def set_content_item_document_type(document_type)
    @content_item = { "schema_name" => document_type }
    stub_content_store
  end

  def stub_content_store
    content_store = stub
    content_store.expects(:content_item).returns(@content_item || {})
    Services.expects(:content_store).returns(content_store)
  end
end
