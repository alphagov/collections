class CoronavirusLocalRestrictionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:results]

  def show
    @content_item = content_item.to_hash

    render :show,
           locals: {
             error_message: nil,
             input_error: nil,
             error_description: nil,
           }
  end

  def results
    @content_item = content_item.to_hash

    if params["postcode-lookup"].blank?
      return render_no_postcode_error("postcodeLeftBlank")
    end

    @postcode = PostcodeService.new(params["postcode-lookup"]).sanitize

    if @postcode.blank?
      return render_no_postcode_error("postcodeLeftBlankSanitized")
    elsif !PostcodeService.new(@postcode).valid?
      return render_invalid_postcode_error("invalidPostcodeFormat")
    end

    @location_lookup = LocationLookupService.new(@postcode)

    if @location_lookup.no_information?
      return render :no_information
    elsif @location_lookup.invalid_postcode?
      return render_invalid_postcode_error("fullPostcodeNoMapitValidation")
    elsif @location_lookup.postcode_not_found?
      return render_no_postcode_error("fullPostcodeNoMapitMatch")
    end

    if @location_lookup.data.present?
      restrictions = @location_lookup.data.map do |area|
        restriction = LocalRestriction.find(area.gss)
        restriction if restriction&.area_name
      end

      @restriction = restrictions.compact.first

      render
    end
  end

private

  def render_no_postcode_error(error_code)
    render :show,
           locals: {
             error_message: I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_message"),
             input_error: I18n.t("coronavirus_local_restrictions.errors.no_postcode.input_error"),
             error_description: I18n.t("coronavirus_local_restrictions.errors.no_postcode.error_description"),
             error_code: error_code,
           }
  end

  def render_invalid_postcode_error(error_code)
    render :show,
           locals: {
             error_message: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.error_message"),
             input_error: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.input_error"),
             error_description: I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.error_description"),
             error_code: error_code,
           }
  end

  def content_item
    base_path = request.path
    @content_item ||= begin
      Rails.cache.fetch("collections_content_items#{base_path}", expires_in: 10.minutes) do
        ContentItem.find!(base_path)
      end
    end
  end
end
