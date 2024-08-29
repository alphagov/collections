module BrowseHelper
  def display_popular_links_for_slug?(_slug)
    true
  end

  def control_key_is_present?(slug)
    I18n.exists?("#{slug}.control", scope: "browse.popular_links")
  end

  def control_data(slug)
    if control_key_is_present?(slug)
      I18n.t("browse.popular_links.#{slug}.control")
    else
      []
    end
  end

  def popular_links_data(slug)
    if popular_tasks_variant_a_page?
      I18n.t("browse.popular_links.#{slug}.variant_a")
    elsif popular_tasks_variant_b_page?
      I18n.t("browse.popular_links.#{slug}.variant_b")
    else
      control_data(slug)
    end
  end

  def popular_links_for_slug(slug)
    PopularTasks.new.popular_links_for_slug(slug)
  end
end
