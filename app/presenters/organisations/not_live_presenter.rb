module Organisations
  class NotLivePresenter
    include ActionView::Helpers::UrlHelper

    def initialize(organisation)
      @org = organisation
    end

    def non_live_organisation_notice
      return separate_website_notice if @org.is_exempt?
      return changed_name_notice if @org.is_changed_name? || @org.is_closed?
      return joining_notice if @org.is_joining?
      return devolved_notice if @org.is_devolved?
      return left_gov_notice if @org.is_left_gov?
      return merged_notice if @org.is_merged?
      return split_notice if @org.is_split? || @org.is_replaced?
      return no_longer_exists_notice if @org.is_no_longer_exists?
      @org.title
    end

  private

    def separate_website_notice
      I18n.t('organisations.notices.separate_website', title: @org.title, url: @org.separate_website_url).html_safe
    end

    def changed_name_notice
      I18n.t('organisations.notices.changed_name', title: @org.title, link_href: notice_successor_link, link_text: notice_successor_title).html_safe
    end

    def joining_notice
      I18n.t('organisations.notices.joining', title: @org.title)
    end

    def devolved_notice
      I18n.t('organisations.notices.devolved', title: @org.title, link_href: notice_successor_link, link_text: notice_successor_title).html_safe
    end

    def left_gov_notice
      I18n.t('organisations.notices.left_gov', title: @org.title)
    end

    def merged_notice
      I18n.t('organisations.notices.merged', title: @org.title, link_href: notice_successor_link, link_text: notice_successor_title, updated: notice_successor_updated).html_safe
    end

    def split_notice
      successors = @org.ordered_successor_organisations.map do |successor|
        link_to(successor["title"], successor["base_path"])
      end

      I18n.t('organisations.notices.split', title: @org.title, links: successors.to_sentence).html_safe
    end

    def no_longer_exists_notice
      I18n.t('organisations.notices.no_longer_exists', title: @org.title)
    end

    def notice_successor_title
      @org.ordered_successor_organisations[0]["title"]
    end

    def notice_successor_link
      @org.ordered_successor_organisations[0]["base_path"]
    end

    def notice_successor_updated
      Date.parse(@org.status_updated_at).strftime("%B %Y")
    end
  end
end
