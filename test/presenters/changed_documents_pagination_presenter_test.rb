require 'test_helper'

describe ChangedDocumentsPaginationPresenter do

  def build_presenter_for_subcategory(start: nil, total: nil, per_page: nil, slug: nil)
    subcategory = stub('Subcategory',
      slug: slug,
      documents_start: start,
      documents_total: total,
    )
    ChangedDocumentsPaginationPresenter.new(subcategory, per_page: per_page)
  end

  describe '#initialize' do
    it 'raises an exception if per_page is negative' do
      assert_raise ChangedDocumentsPaginationPresenter::NegativeCountValue do
        build_presenter_for_subcategory(per_page: -50)
      end
    end
  end

  describe '#next_page_start' do
    it 'returns the starting value for the next page' do
      presenter = build_presenter_for_subcategory(start: 0, total: 100)

      assert_equal 50, presenter.next_page_start
    end

    it 'returns nil if there are no further pages' do
      presenter = build_presenter_for_subcategory(start: 60, total: 100)

      assert_nil presenter.next_page_start
    end

    it 'works with custom per_page values' do
      presenter = build_presenter_for_subcategory(start: 0, total: 100, per_page: 20)

      assert_equal 20, presenter.next_page_start
    end
  end

  describe '#next_page?' do
    it 'is true if there is a subsequent page' do
      presenter = build_presenter_for_subcategory(start: 0, total: 100)

      assert presenter.next_page?
    end

    it 'is false if there are no further page' do
      presenter = build_presenter_for_subcategory(start: 60, total: 100)

      refute presenter.next_page?
    end
  end

  describe '#previous_page_start' do
    it 'returns the starting value for the previous page' do
      presenter = build_presenter_for_subcategory(start: 50)

      assert_equal 0, presenter.previous_page_start
    end

    it 'returns zero if the start value for the previous page would be less than zero' do
      presenter = build_presenter_for_subcategory(start: 20)

      assert_equal 0, presenter.previous_page_start
    end

    it 'returns nil if the current start value is zero' do
      presenter = build_presenter_for_subcategory(start: 0)

      assert_nil presenter.previous_page_start
    end

    it 'works with custom per_page values' do
      presenter = build_presenter_for_subcategory(start: 50, per_page: 20)

      assert_equal 30, presenter.previous_page_start
    end
  end

  describe '#previous_page?' do
    it 'is true if there is a previous page' do
      presenter = build_presenter_for_subcategory(start: 50)

      assert presenter.previous_page?
    end

    it 'is true if the start value for the previous page would be less than zero' do
      presenter = build_presenter_for_subcategory(start: 20)

      assert presenter.previous_page?
    end

    it 'is false if the current start value is zero' do
      presenter = build_presenter_for_subcategory(start: 0)

      refute presenter.previous_page?
    end
  end

  describe '#total_pages' do
    it 'returns the document count divided by the per_page value' do
      presenter = build_presenter_for_subcategory(total: 200, per_page: 20)

      assert_equal 10, presenter.total_pages
    end

    it 'rounds up to the next page' do
      presenter = build_presenter_for_subcategory(total: 201, per_page: 20)

      assert_equal 11, presenter.total_pages
    end

    it 'returns zero pages when there are zero results' do
      presenter = build_presenter_for_subcategory(total: 0)

      assert_equal 0, presenter.total_pages
    end
  end

  describe '#current_page_number' do
    it 'returns the current page number' do
      presenter = build_presenter_for_subcategory(start: 0, per_page: 20)
      assert_equal 1, presenter.current_page_number

      presenter = build_presenter_for_subcategory(start: 20, per_page: 20)
      assert_equal 2, presenter.current_page_number

      presenter = build_presenter_for_subcategory(start: 41, per_page: 20)
      assert_equal 3, presenter.current_page_number
    end
  end

  describe '#next_page_number' do
    it 'returns the next page number' do
      presenter = build_presenter_for_subcategory(start: 0, total: 50, per_page: 20)

      assert_equal 2, presenter.next_page_number
    end

    it 'returns nil when there are no further pages' do
      presenter = build_presenter_for_subcategory(start: 40, total: 50, per_page: 20)

      assert_nil presenter.next_page_number
    end
  end

  describe '#previous_page_number' do
    it 'returns the previous page number' do
      presenter = build_presenter_for_subcategory(start: 50, per_page: 20)

      assert_equal 2, presenter.previous_page_number
    end

    it 'returns nil when there are no previous pages' do
      presenter = build_presenter_for_subcategory(start: 0, per_page: 20)

      assert_nil presenter.previous_page_number
    end
  end

  describe '#next_page_path' do
    it 'returns a path to the next page' do
      presenter = build_presenter_for_subcategory(start: 0,
                                                  total: 100,
                                                  slug: 'foo/bar')

      assert_equal '/foo/bar/latest?start=50', presenter.next_page_path
    end

    it 'includes the "count" parameter given a custom per_page value' do
      presenter = build_presenter_for_subcategory(start: 0,
                                                  total: 100,
                                                  slug: 'foo/bar',
                                                  per_page: 20)

      assert_equal '/foo/bar/latest?count=20&start=20', presenter.next_page_path
    end

    it 'returns nil when there are no further pages' do
      presenter = build_presenter_for_subcategory(start: 50,
                                                  total: 100,
                                                  slug: 'foo/bar')

      assert_nil presenter.next_page_path
    end
  end

  describe '#previous_page_path' do
    it 'returns a path to the previous page' do
      presenter = build_presenter_for_subcategory(start: 100,
                                                  slug: 'foo/bar')

      assert_equal '/foo/bar/latest?start=50', presenter.previous_page_path
    end

    it 'includes the "count" parameter given a custom per_page value' do
      presenter = build_presenter_for_subcategory(start: 100,
                                                  slug: 'foo/bar',
                                                  per_page: 20)

      assert_equal '/foo/bar/latest?count=20&start=80', presenter.previous_page_path
    end

    it 'excludes the "start" parameter when it would be zero' do
      presenter = build_presenter_for_subcategory(start: 20,
                                                  slug: 'foo/bar',
                                                  per_page: 20)

      assert_equal '/foo/bar/latest?count=20', presenter.previous_page_path
    end

    it 'returns nil when there are no previous pages' do
      presenter = build_presenter_for_subcategory(start: 0,
                                                  slug: 'foo/bar')

      assert_nil presenter.previous_page_path
    end
  end

end
