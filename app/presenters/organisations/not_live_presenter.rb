module Organisations
  class NotLivePresenter
    include ActionView::Helpers::UrlHelper

    def initialize(organisation)
      @org = organisation
    end

    def non_live_organisation_notice
      return has_no_website if @org.is_exempt? && @org.no_website?
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

    def has_no_website
      I18n.t("organisations.notices.no_website", title: @org.title).html_safe
    end

    def separate_website_notice
      I18n.t("organisations.notices.separate_website_html", title: @org.title, url: @org.separate_website_url).html_safe
    end

    def changed_name_notice
      I18n.t("organisations.notices.changed_name_html", title: @org.title, link_href: notice_successor_link, link_text: notice_successor_title).html_safe
    end

    def joining_notice
      I18n.t("organisations.notices.joining", title: @org.title)
    end

    def devolved_notice
      I18n.t("organisations.notices.devolved_html", title: @org.title, link_href: notice_successor_link, link_text: notice_successor_title).html_safe
    end

    def left_gov_notice
      I18n.t("organisations.notices.left_gov", title: @org.title)
    end

    def merged_notice
      if status_updated_at
        I18n.t("organisations.notices.merged_html", title: @org.title, link_href: notice_successor_link, link_text: notice_successor_title, updated: notice_successor_updated).html_safe
      else
        I18n.t("organisations.notices.merged_no_date_html", title: @org.title, link_href: notice_successor_link, link_text: notice_successor_title).html_safe
      end
    end

    def split_notice
      successors = @org.ordered_successor_organisations.map do |successor|
        link_to(successor["title"], successor["base_path"])
      end

      I18n.t("organisations.notices.split_html", title: @org.title, links: successors.to_sentence).html_safe
    end

    def no_longer_exists_notice
      I18n.t("organisations.notices.no_longer_exists", title: @org.title)
    end

    def notice_successor_title
      @org.ordered_successor_organisations[0]["title"]
    end

    def notice_successor_link
      @org.ordered_successor_organisations[0]["base_path"]
    end

    def notice_successor_updated
      Date.parse(status_updated_at).strftime("%B %Y")
    end

    def status_updated_at
      @org.status_updated_at
    end
  end
end
