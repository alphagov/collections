module HighlightBoxesHelper
  def data_tracking?(items)
    items.each do |item|
      return true if item[:link][:data_attributes]
    end

    false
  end
end
