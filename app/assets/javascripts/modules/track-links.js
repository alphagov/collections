window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  Modules.TrackLinks = function () {
    this.start = function (element) {
      var category = element[0].getAttribute('data-track-category')
      var action = element[0].getAttribute('data-track-action')
      var links = element[0].getElementsByTagName('a')

      if (!category) return

      for (var i = 0; i < links.length; i++) {
        var link = links[i]
        link.addEventListener('click', function (e) {
          var options = {
            transport: 'beacon',
            label: e.target.getAttribute('href')
          }

          if (!action) action = e.target.innerText

          GOVUK.analytics.trackEvent(category, action, options)
        })
      }
    }
  }
})(window.GOVUK.Modules)
