require "test_helper"

describe ChangedDocumentsPaginationPresenter do
  def mock_view_context
    stub("View context", latest_changes_path: "/somewhere")
  end

  def build_presenter_for_subtopic(total: 100, start: 0, page_size: 50, view_context: mock_view_context)
    changed_documents = stub(
      "Topic::ChangedDocuments",
      total: total,
      page_size: page_size,
      start: start,
    )
    ChangedDocumentsPaginationPresenter.new(changed_documents, view_context)
  end

  describe "#total_pages" do
    it "returns the document count divided by the per_page value" do
      presenter = build_presenter_for_subtopic(total: 200, page_size: 20)

      assert_equal 10, presenter.total_pages
    end

    it "rounds up to the next page" do
      presenter = build_presenter_for_subtopic(total: 201, page_size: 20)

      assert_equal 11, presenter.total_pages
    end

    it "returns zero pages when there are zero results" do
      presenter = build_presenter_for_subtopic(total: 0)

      assert_equal 0, presenter.total_pages
    end
  end

  describe "#next_page?" do
    it "is true if there is a subsequent page" do
      presenter = build_presenter_for_subtopic(start: 0, total: 100)

      assert presenter.next_page?
    end

    it "is false if there are no further page" do
      presenter = build_presenter_for_subtopic(start: 60, total: 100)

      assert_not presenter.next_page?
    end
  end

  describe "#previous_page?" do
    it "is true if there is a previous page" do
      presenter = build_presenter_for_subtopic(start: 50, total: 100)

      assert presenter.previous_page?
    end

    it "is true if the start value for the previous page would be less than zero" do
      presenter = build_presenter_for_subtopic(start: 20, total: 100)

      assert presenter.previous_page?
    end

    it "is false if the current start value is zero" do
      presenter = build_presenter_for_subtopic(start: 0, total: 100)

      assert_not presenter.previous_page?
    end
  end

  describe "#current_page_number" do
    it "returns the current page number" do
      presenter = build_presenter_for_subtopic(start: 0, page_size: 20)
      assert_equal 1, presenter.current_page_number

      presenter = build_presenter_for_subtopic(start: 20, page_size: 20)
      assert_equal 2, presenter.current_page_number

      presenter = build_presenter_for_subtopic(start: 40, page_size: 20)
      assert_equal 3, presenter.current_page_number
    end

    it "treats start values not on a page boundary as being in the next page" do
      presenter = build_presenter_for_subtopic(start: 5, page_size: 20)
      assert_equal 2, presenter.current_page_number
    end
  end

  describe "#next_page_path" do
    setup do
      @view_context = mock_view_context
    end

    it "returns a path to the next page" do
      presenter = build_presenter_for_subtopic(view_context: @view_context)

      @view_context.expects(:latest_changes_path).with(start: 50)
        .returns("/a/path")
      assert_equal "/a/path", presenter.next_page_path
    end

    it 'includes the "count" parameter given a custom per_page value' do
      presenter = build_presenter_for_subtopic(
        view_context: @view_context,
        page_size: 20,
      )

      @view_context.expects(:latest_changes_path).with(count: 20, start: 20)
        .returns("/a/path")
      assert_equal "/a/path", presenter.next_page_path
    end
  end

  describe "#previous_page_path" do
    setup do
      @view_context = mock_view_context
    end

    it "returns a path to the previous page" do
      presenter = build_presenter_for_subtopic(
        view_context: @view_context,
        start: 100,
        total: 150,
      )

      @view_context.expects(:latest_changes_path).with(start: 50)
        .returns("/a/path")
      assert_equal "/a/path", presenter.previous_page_path
    end

    it 'includes the "count" parameter given a custom per_page value' do
      presenter = build_presenter_for_subtopic(
        view_context: @view_context,
        page_size: 20,
        start: 40,
      )

      @view_context.expects(:latest_changes_path).with(count: 20, start: 20)
        .returns("/a/path")
      assert_equal "/a/path", presenter.previous_page_path
    end

    it 'excludes the "start" parameter when it would be zero' do
      presenter = build_presenter_for_subtopic(
        view_context: @view_context,
        start: 50,
      )

      @view_context.expects(:latest_changes_path).with({})
        .returns("/a/path")
      assert_equal "/a/path", presenter.previous_page_path
    end
  end
end
