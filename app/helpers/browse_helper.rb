module BrowseHelper
  ACTION_LINK_SLUGS = %w[benefits business].freeze

  def display_action_links_for_slug?(slug)
    ACTION_LINK_SLUGS.include?(slug)
  end
end
