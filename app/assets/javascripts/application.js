//= require govuk-frontend/govuk/vendor/polyfills/Function/prototype/bind
//
//= require support
//= require browse-columns
//= require organisation-list-filter
//= require modules/current-location
//= require modules/feeds.js
//= require modules/toggle-attribute
//= require components/accordion
//= require modules/coronavirus-landing-page
//= require govuk_publishing_components/all_components

$(document).on('ready', function(){
  var toggleAttribute = new GOVUK.Modules.ToggleAttribute();
  toggleAttribute.start($('[data-module=toggle-attribute]'));
});
