class CoronavirusLocalRestrictionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:results]

  def show
    @content_item = content_item.to_hash

    render :show,
           locals: {
             breadcrumbs: breadcrumbs,
             error_message: nil,
             input_error: nil,
             error_description: nil,
           }
  end

  def results
    if params["postcode-lookup"].blank?
      GovukError.notify(
        "Postcode left blank",
        extra: { error_message: "Postcode field left blank" },
      )

      return render_no_postcode_error
    end

    @postcode = PostcodeService.new(params["postcode-lookup"]).sanitize

    if @postcode.blank?
      GovukError.notify(
        "Sanitized postcode is blank",
        extra: { error_message: "Postcode is blank after being sanitized" },
      )

      return render_no_postcode_error
    elsif !PostcodeService.new(@postcode).valid?
      GovukError.notify(
        "Postcode failed validation",
        extra: { error_message: "Postcode #{@postcode} failed validation after being sanitized" },
      )

      return render_invalid_postcode_error
    end

    @content_item = content_item.to_hash

    @location_lookup = LocationLookupService.new(@postcode)

    if @location_lookup.no_information?
      return render :no_information,
                    locals: {
                      breadcrumbs: breadcrumbs,
                    }
    elsif @location_lookup.invalid_postcode?
      GovukError.notify(
        "Postcode failed Mapit validation",
        extra: { error_message: "Postcode #{@postcode} failed validation with Mapit" },
      )

      return render_invalid_postcode_error
    elsif @location_lookup.postcode_not_found?
      GovukError.notify(
        "Mapit couldn't find postcode",
        extra: { error_message: "Postcode #{@postcode} couldn't be found in Mapit" },
      )

      return render_no_postcode_error
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

private

  def render_no_postcode_error
    render :show,
           locals: {
             breadcrumbs: breadcrumbs,
             error_message: I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_message"),
             input_error: I18n.t("coronavirus_local_restrictions.errors.no_postcode.input_error"),
             error_description: I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_description"),
           }
  end

  def render_invalid_postcode_error
    render :show,
           locals: {
             breadcrumbs: breadcrumbs,
             error_message: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.error_message"),
             input_error: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.input_error"),
             error_description: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.error_description"),
           }
  end

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

  def content_item
    @content_item ||= ContentItem.find!(request.path)
  end
end
