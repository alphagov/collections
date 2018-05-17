module DataTrackingHelper
  def track_click?(items)
    items.each do |item|
      return true if item[:link][:data_attributes]
    end

    false
  end
end
