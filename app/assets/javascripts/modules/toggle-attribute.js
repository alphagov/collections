window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  Modules.ToggleAttribute = function () {
    this.start = function ($element) {
      if ($element[0]){

        console.log($element.find('[data-toggle-attribute]')[0])
        console.log($element[0].querySelectorAll('[data-toggle-attribute]'))

        for (let i = 0; i < $element[0].querySelectorAll('[data-toggle-attribute]').length; i++) {
          $element[0].querySelectorAll('[data-toggle-attribute]')[i].click(function (event) {
            var clicked = event.target
            var toggleAttribute = clicked.getAttribute('data-toggle-attribute')
            var current = clicked.getAttribute(toggleAttribute)
            var closedText = clicked.getAttribute('data-when-closed-text')
            var openText = clicked.getAttribute('data-when-open-text')

            clicked.setAttribute(toggleAttribute, current === closedText ? openText : closedText)
          })
        }
      }
    }
  }
})(window.GOVUK.Modules)
