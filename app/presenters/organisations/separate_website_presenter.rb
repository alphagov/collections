module Organisations
  class SeparateWebsitePresenter
    include ActionView::Helpers::UrlHelper

    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def organisation_display_name_and_parental_relationship
      name = org.title
      type_name = organisation_type_name
      relationship = ERB::Util.h(add_indefinite_article(type_name))
      parents = org.ordered_parent_organisations.map { |parent| organisation_relationship_html(parent) }

      description = if parents.any?
                      case type_name
                      when 'other'
                        "#{name} works with #{parents.to_sentence}."
                      when 'non-ministerial department'
                        "#{name} is #{relationship}."
                      when 'sub-organisation'
                        "#{name} is part of #{parents.to_sentence}."
                      when 'executive non-departmental public body', 'advisory non-departmental public body', 'tribunal non-departmental public body', 'executive agency'
                        "#{name} is #{relationship}, sponsored by #{parents.to_sentence}."
                      else
                        "#{name} is #{relationship} of #{parents.to_sentence}."
                      end
                    else
                      type_name != 'other' ? "#{name} is #{relationship}." : name.to_s
                    end

      description.html_safe
    end

    def organisation_relationship_html(organisation)
      prefix = needs_definite_article?(organisation["title"]) ? "the " : ""
      (prefix + link_to(organisation["title"], organisation["base_path"]))
    end

    def needs_definite_article?(phrase)
      exceptions = [/civil service resourcing/, /^hm/, /ordnance survey/]
      !has_definite_article?(phrase) && !(exceptions.any? { |e| e =~ phrase.downcase })
    end

    def has_definite_article?(phrase)
      phrase.downcase.strip[0..2] == 'the'
    end

    def add_indefinite_article(noun)
      indefinite_article = starts_with_vowel?(noun) ? 'an' : 'a'
      "#{indefinite_article} #{noun}"
    end

    def starts_with_vowel?(word_or_phrase)
      'aeiou'.include?(word_or_phrase.downcase[0])
    end

    def organisation_type_name
      ActiveSupport::Inflector.singularize(org.organisation_type.downcase)
    end

    def organisation_display_name_including_parental_and_child_relationships
      organisation_name = organisation_display_name_and_parental_relationship
      # child_organisations = organisation.supporting_bodies

      # if child_organisations.any?
      #   organisation_name.chomp!('.')
      #   organisation_name += organisation_type_name(organisation) != 'other' ? ", supported by " : " is supported by "

      #   child_relationships_link_text = child_organisations.size.to_s
      #   child_relationships_link_text += child_organisations.size == 1 ? " public body" : " agencies and public bodies"

      #   organisation_name += link_to(child_relationships_link_text, organisations_path(anchor: organisation.slug))
      #   organisation_name += "."
      # end

      organisation_name.html_safe
    end
  end
end
