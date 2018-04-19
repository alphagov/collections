module Supergroups
  class Transparency < Supergroup
    attr_reader :content

    def initialize(scope = {})
      super('transparency', scope)
    end

    def tagged_content
      @content = MostRecentContent.fetch(scope.merge(filter_content_purpose_supergroup: @name))
    end
  end
end
