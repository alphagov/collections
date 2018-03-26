class GuidanceAndRegulations < Supergroup
  attr_reader :content

  def initialize
    super('guidance_and_regulation')
  end

  def tagged_content(taxon_id)
    @content = MostPopularContent.fetch(content_id: taxon_id, filter_content_purpose_supergroup: @name)
  end
end
