class ChangedDocumentsPaginationPresenter
  include Rails.application.routes.url_helpers

  DEFAULT_PER_PAGE = 50

  class NegativeCountValue < StandardError; end

  def initialize(subtopic, per_page: nil)
    @subtopic = subtopic
    @per_page = per_page

    validate_per_page
  end

  def next_page_start
    start = current_start + per_page
    start < total ? start : nil
  end

  def next_page?
    next_page_start.present?
  end

  def previous_page_start
    return nil if current_start == 0
    start = current_start - per_page
    start > 0 ? start : 0
  end

  def previous_page?
    previous_page_start.present?
  end

  def total_pages
    (total.to_f / per_page.to_f).ceil
  end

  def current_page_number
    # Offsetting the current start value by 1 means that dividing by the per_page
    # value and rounding up will return the correct page number.
    #
    #   eg. (20+1)/20 = 1.05 -> 2
    #       (0+1)/20  = 0.05 -> 1
    #
    ( (current_start + 1).to_f / per_page.to_f ).ceil
  end

  def next_page_number
    if next_page?
      current_page_number + 1
    end
  end

  def previous_page_number
    if previous_page?
      current_page_number - 1
    end
  end

  def next_page_path
    if next_page?
      params = { start: next_page_start }
      params[:count] = per_page if custom_per_page?

      latest_changes_path(parent_slug, child_slug, params)
    end
  end

  def previous_page_path
    if previous_page?
      params = { }

      params[:start] = previous_page_start if previous_page_start > 0
      params[:count] = per_page if custom_per_page?

      latest_changes_path(parent_slug, child_slug, params)
    end
  end

private
  attr_reader :subtopic

  def per_page
    if @per_page.present? && @per_page > 0
      @per_page
    else
      DEFAULT_PER_PAGE
    end
  end

  def custom_per_page?
    per_page != DEFAULT_PER_PAGE
  end

  def validate_per_page
    if @per_page.to_i < 0
      raise NegativeCountValue
    end
  end

  def current_start
    subtopic.documents_start
  end

  def total
    subtopic.documents_total
  end

  def parent_slug
    split_subtopic_slug.first
  end

  def child_slug
    split_subtopic_slug.last
  end

  def split_subtopic_slug
    subtopic.slug.split('/')
  end
end
