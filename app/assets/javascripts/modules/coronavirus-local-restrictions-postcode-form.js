window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function CoronavirusLocalRestrictionsPostcodeForm () {}

  CoronavirusLocalRestrictionsPostcodeForm.prototype.start = function ($element) {
    var element = $element[0] // access dom element from jQuery
    var that = this

    element.addEventListener('submit', function (e) {
      var input = element.querySelector('input[name=postcode]')
      if (!input) { return }

      input.value = that.normalisePostcode(input.value)
    })
  }

  CoronavirusLocalRestrictionsPostcodeForm.prototype.normalisePostcode = function (postcode) {
    var regex = /^\s*([A-Z]{1,2}[0-9][A-Z0-9]?)\s*([0-9][A-Z]{2})\s*$/i
    var match = postcode.match(regex)

    if (match) {
      return match[1].toUpperCase() + ' ' + match[2].toUpperCase()
    } else {
      return postcode
    }
  }

  Modules.CoronavirusLocalRestrictionsPostcodeForm = CoronavirusLocalRestrictionsPostcodeForm
})(window.GOVUK.Modules)
