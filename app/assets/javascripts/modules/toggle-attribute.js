window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function ToggleAttribute ($module) {
    this.$module = $module
    this.init()
  }

  ToggleAttribute.prototype.init = function () {
    this.$module.addEventListener('click', function (event) {
      var target = event.target
      var toggleAttribute

      // traverse up node tree to check parent elements for data-toggle-attribute
      do {
        toggleAttribute = target.getAttribute('data-toggle-attribute')
        if (toggleAttribute) break
        target = target.parentNode
      } while (target && target !== this.$module)

      if (!toggleAttribute) return

      var current = target.getAttribute(toggleAttribute)
      var closedText = target.getAttribute('data-when-closed-text')
      var openText = target.getAttribute('data-when-open-text')
      target.setAttribute(toggleAttribute, current === closedText ? openText : closedText)
    }.bind(this))
  }
  Modules.ToggleAttribute = ToggleAttribute
})(window.GOVUK.Modules)
