class MinistersIndexPresenter
  def initialize(ministers_index)
    @ministers_index = ministers_index
  end

  def lead_paragraph
    @ministers_index.content_item.details.fetch("body", nil)
  end

  def is_during_reshuffle?
    @ministers_index.content_item.details.fetch("reshuffle", nil)
  end
end
