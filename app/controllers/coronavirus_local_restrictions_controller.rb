class CoronavirusLocalRestrictionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:results]

  def show
    render :show,
           locals: {
             breadcrumbs: breadcrumbs,
             error_message: nil,
             input_error: nil,
             error_description: nil,
           }
  end

  def results
    @postcode = params["postcode-lookup"].gsub(/\s+/, "").upcase

    if @postcode.blank?
      @error = true
      return render :show,
                    locals: {
                      breadcrumbs: breadcrumbs,
                      error_message: I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_message"),
                      input_error: I18n.t("coronavirus_local_restrictions.errors.no_postcode.input_error"),
                      error_description: I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_description"),
                    }
    elsif !postcode_validation
      @error = true
      return render :show,
                    locals: {
                      breadcrumbs: breadcrumbs,
                      error_message: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.error_message"),
                      input_error: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.input_error"),
                      error_description: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.error_description"),
                    }
    end

    @content_item = content_item.to_hash

    @location_lookup = LocationLookupService.new(@postcode)

    elsif @location_lookup.invalid_postcode?
      return render :show,
                    locals: {
                      breadcrumbs: breadcrumbs,
                      error_message: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.error_message"),
                      input_error: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.input_error"),
                      error_description: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.error_description"),
                    }
    elsif @location_lookup.postcode_not_found?
      return render :show,
                    locals: {
                      breadcrumbs: breadcrumbs,
                      error_message: I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_message"),
                      input_error: I18n.t("coronavirus_local_restrictions.errors.no_postcode.input_error"),
                      error_description: I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_description"),
                    }
    end

    if @location_lookup.data.present?
      restrictions = @location_lookup.data.map do |area|
        restriction = LocalRestriction.new(area.gss)
        restriction if restriction.area_name
      end

      @restriction = restrictions.compact.first

      render
    end
  end

  def error_404
    super
  end

private

  # Breadcrumbs for this page are hardcoded because it doesn't yet have a
  # content item with parents.
  def breadcrumbs
    [
      {
        title: "Home",
        url: "/",
      },
      {
        title: "Coronavirus (COVID-19)",
        url: "/coronavirus",
      },
    ]
  end

  def postcode_validation
    @postcode =~ /^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})$/
  end

  def content_item
    @content_item ||= ContentItem.find!(request.path)
  end
end
