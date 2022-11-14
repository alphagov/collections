describe ChangedDocumentsPaginationPresenter do
  let(:mock_view_context) { double("View context", latest_changes_path: "/somewhere") }

  def build_presenter_for_subtopic(total: 100, start: 0, page_size: 50, view_context: mock_view_context)
    changed_documents = double(
      "Topic::ChangedDocuments",
      total:,
      page_size:,
      start:,
    )
    ChangedDocumentsPaginationPresenter.new(changed_documents, view_context)
  end

  describe "#total_pages" do
    it "returns the document count divided by the per_page value" do
      presenter = build_presenter_for_subtopic(total: 200, page_size: 20)

      expect(presenter.total_pages).to eq(10)
    end

    it "rounds up to the next page" do
      presenter = build_presenter_for_subtopic(total: 201, page_size: 20)

      expect(presenter.total_pages).to eq(11)
    end

    it "returns zero pages when there are zero results" do
      presenter = build_presenter_for_subtopic(total: 0)

      expect(presenter.total_pages).to eq(0)
    end
  end

  describe "#next_page?" do
    it "is true if there is a subsequent page" do
      presenter = build_presenter_for_subtopic(start: 0, total: 100)

      expect(presenter.next_page?).to be true
    end

    it "is false if there are no further page" do
      presenter = build_presenter_for_subtopic(start: 60, total: 100)

      expect(presenter.next_page?).to be false
    end
  end

  describe "#previous_page?" do
    it "is true if there is a previous page" do
      presenter = build_presenter_for_subtopic(start: 50, total: 100)

      expect(presenter.previous_page?).to be true
    end

    it "is true if the start value for the previous page would be less than zero" do
      presenter = build_presenter_for_subtopic(start: 20, total: 100)

      expect(presenter.previous_page?).to be true
    end

    it "is false if the current start value is zero" do
      presenter = build_presenter_for_subtopic(start: 0, total: 100)

      expect(presenter.previous_page?).to be false
    end
  end

  describe "#current_page_number" do
    it "returns the current page number" do
      presenter = build_presenter_for_subtopic(start: 0, page_size: 20)
      expect(presenter.current_page_number).to eq(1)

      presenter = build_presenter_for_subtopic(start: 20, page_size: 20)
      expect(presenter.current_page_number).to eq(2)

      presenter = build_presenter_for_subtopic(start: 40, page_size: 20)
      expect(presenter.current_page_number).to eq(3)
    end

    it "treats start values not on a page boundary as being in the next page" do
      presenter = build_presenter_for_subtopic(start: 5, page_size: 20)
      expect(presenter.current_page_number).to eq(2)
    end
  end

  describe "#next_page_path" do
    let(:view_context) { double("View context") }

    it "returns a path to the next page" do
      allow(view_context).to receive(:latest_changes_path).with(start: 50).and_return("/a/path")

      presenter = build_presenter_for_subtopic(view_context:)

      expect(presenter.next_page_path).to eq("/a/path")
    end

    it 'includes the "count" parameter given a custom per_page value' do
      view_context = double("View context")
      allow(view_context).to receive(:latest_changes_path).with(count: 20, start: 20).and_return("/a/path")

      presenter = build_presenter_for_subtopic(
        view_context:,
        page_size: 20,
      )

      expect(presenter.next_page_path).to eq("/a/path")
    end
  end

  describe "#previous_page_path" do
    let(:view_context) { double("View context") }

    it "returns a path to the previous page" do
      allow(view_context).to receive(:latest_changes_path).with(start: 50).and_return("/a/path")

      presenter = build_presenter_for_subtopic(
        view_context:,
        start: 100,
        total: 150,
      )

      expect(presenter.previous_page_path).to eq("/a/path")
    end

    it 'includes the "count" parameter given a custom per_page value' do
      allow(view_context).to receive(:latest_changes_path).with(count: 20, start: 20).and_return("/a/path")

      presenter = build_presenter_for_subtopic(
        view_context:,
        page_size: 20,
        start: 40,
      )

      expect(presenter.previous_page_path).to eq("/a/path")
    end

    it 'excludes the "start" parameter when it would be zero' do
      allow(view_context).to receive(:latest_changes_path).with({}).and_return("/a/path")

      presenter = build_presenter_for_subtopic(
        view_context:,
        start: 50,
      )

      expect(presenter.previous_page_path).to eq("/a/path")
    end
  end
end
