class LinkHeaderPresenter
  attr_reader :links

  def initialize(links)
    @links = links
  end

  def present
    link_header = []
    links.each do |link|
      link_header << "<#{link[:href]}>; rel=\"#{link[:rel]}\""
    end
    link_header.join(", ")
  end
end
