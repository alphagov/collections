module Supergroups
  class Transparency < Supergroup
    attr_reader :content

    def initialize
      super('transparency')
    end

    def promoted_content_count
      0
    end
  end
end
