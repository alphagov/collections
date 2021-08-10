module AbTests::SlimmerTemplateSelectable
  def set_gem_layout
    if explore_menu_variant_b?
      slimmer_template "gem_layout_explore_header"
    else
      slimmer_template "gem_layout"
    end
  end

  def set_gem_layout_full_width
    if explore_menu_variant_b?
      slimmer_template "gem_layout_full_width_explore_header"
    else
      slimmer_template "gem_layout_full_width"
    end
  end
end
