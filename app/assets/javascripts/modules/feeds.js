// Copied from whitehall to allow the feed panel to display when clicking on the
// "feed" link generated for whitehall based email and feed subscriptions

(function () {
  'use strict'
  window.GOVUK = window.GOVUK || {}

  window.GOVUK.feeds = {
    init: function () {
      if (window.GOVUK.analytics && window.GOVUK.analytics.trackEvent) {
        window.GOVUK.analytics.trackEvent('feed', 'initialize', {})
      }
      $('.js-feed').on('click', window.GOVUK.feeds.toggle)
    },
    toggle: function (e) {
      if (window.GOVUK.analytics && window.GOVUK.analytics.trackEvent) {
        window.GOVUK.analytics.trackEvent('feed', 'toggle', {})
      }
      e.preventDefault()
      var panel = $(e.target).siblings('.js-feed-panel')
      panel.toggle()
      panel.find('input').select()
    }
  }

  $(function () { GOVUK.feeds.init() })
}())
