window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function ToggleAttribute ($module) {
    this.$module = $module
    this.toggleAttribute = $module.querySelector('[data-toggle-attribute]')
  }
  ToggleAttribute.prototype.init = function ($element) {
    this.toggleAttribute.addEventListener('click', function (event) {
      var clicked = event.target
      var toggleAttribute = clicked.getAttribute('data-toggle-attribute')
      var current = clicked.getAttribute(toggleAttribute)
      var closedText = clicked.getAttribute('data-when-closed-text')
      var openText = clicked.getAttribute('data-when-open-text')
      clicked.setAttribute(toggleAttribute, current === closedText ? openText : closedText)
    })
  }
  Modules.ToggleAttribute = ToggleAttribute
})(window.GOVUK.Modules)
