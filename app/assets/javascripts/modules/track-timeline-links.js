window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  "use strict";

  Modules.TrackTimelineLinks = function () {
    this.start = function (element) {
      var links = element[0].getElementsByTagName("a")
      
      for (var i = 0; i < links.length; i++) {
        var link = links[i];
        link.addEventListener("click", function(e) {
          var options = {
            transport: "beacon",
            label: e.target.getAttribute('href')
          }

          GOVUK.analytics.trackEvent("pageElementInteraction", "Timeline", options)
        })
      }
    }
  }
})(window.GOVUK.Modules)
