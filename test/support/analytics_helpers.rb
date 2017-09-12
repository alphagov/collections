module AnalyticsHelpers
  def page_has_meta_tag?(name, content)
    page.has_selector?(:xpath, "/html/head/meta[@name='#{name}'][@content='#{content}']", visible: false)
  end
end
