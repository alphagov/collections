require 'test_helper'

class DocumentTypeRoutingConstraintTest < ActiveSupport::TestCase
  context "#matches?" do
    context "when the content_store returns a document" do
      setup do
        @document_type = "foo"
        @inspector = stub(new: stub(document_type: @document_type, error: nil))
      end

      should "return true if document_type matches" do
        assert subject(@document_type, @inspector).matches?(request)
      end

      should "return false if document_type doesn't match" do
        assert_not subject("not_the_document_type", @inspector).matches?(request)
      end
    end

    context "when the content_store API call throws an error" do
      setup do
        @error = GdsApi::HTTPNotFound.new(404)
        @inspector = stub(new: stub(document_type: nil, error: @error))
        @request = request
      end

      should "return false" do
        assert_not subject("foo", @inspector).matches?(@request)
      end

      should "set an error on the request object" do
        subject("foo", @inspector).matches?(@request)
        assert @request.env[:__api_error] == @error
      end
    end
  end

  context "instances are memoized and used across multiple requests" do
    setup do
      @api_proxy = stub
      @document_type = "static across requests"
      @document_type_inspector_instance = stub(document_type: @document_type, error: nil)
      @subject = subject("foo", @api_proxy)
    end

    should "make new API calls each time" do
      @api_proxy.expects(:new).twice.returns(@document_type_inspector_instance)
      @subject.matches?(request)
      @subject.matches?(request)
    end
  end

  context "a request will be passed to multiple instances" do
    setup do
      @api_proxy = stub
      @inspector_instance = stub(document_type: "baz", error: nil)
      @request = request
    end

    should "not make additional API calls" do
      @api_proxy.expects(:new).once.returns(@inspector_instance)
      subject("foo", @api_proxy).matches?(@request)
      subject("bar", @api_proxy).matches?(@request)
    end
  end

  def request
    env = {}
    stub(params: { slug: 'test_slug' }, env: env)
  end

  def subject(document_type, document_type_inspector)
    DocumentTypeRoutingConstraint.new(document_type, document_type_inspector: document_type_inspector)
  end
end
