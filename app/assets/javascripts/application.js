//= require govuk-frontend/govuk/vendor/polyfills/Function/prototype/bind

//= require govuk_publishing_components/lib
//= require govuk_publishing_components/components/accordion
//= require govuk_publishing_components/components/button
//= require govuk_publishing_components/components/details
//= require govuk_publishing_components/components/feedback
//= require govuk_publishing_components/components/govspeak
//= require govuk_publishing_components/components/step-by-step-nav
//= require govuk_publishing_components/components/error-summary
//= require govuk_publishing_components/analytics/explicit-cross-domain-links
//= require govuk_publishing_components/analytics/scroll-tracker

//= require support
//= require browse-columns
//= require organisation-list-filter
//= require modules/feeds.js
//= require modules/toggle-attribute
//= require modules/coronavirus-landing-page
//= require modules/track-links

$(document).on('ready', function () {
  var toggleAttribute = new GOVUK.Modules.ToggleAttribute()
  toggleAttribute.start($('[data-module=toggle-attribute]'))
})
