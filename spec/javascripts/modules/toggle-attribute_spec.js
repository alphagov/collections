describe('A toggle attribute module', function () {
  'use strict'

  var $element
  var toggle
  var clickon
  var html =
    '<div id="element" data-module="toggle-attribute">' +
      '<div id="clickon" data-toggle-attribute="data-state" data-when-closed-text="closed" data-when-open-text="open" data-state="closed">' +
      '</div>' +
    '</div>'

  beforeEach(function () {
    toggle = new GOVUK.Modules.ToggleAttribute()
    $element = $(html)
    toggle.start($element)
    clickon = $element.find('#clickon')
  })

  afterEach(function () {
    $(document).off()
  })

  it('sets the state to open when clicked and back again', function () {
    expect(clickon).toHaveAttr('data-state', 'closed')
    clickon.click()
    expect(clickon).toHaveAttr('data-state', 'open')
    clickon.click()
    expect(clickon).toHaveAttr('data-state', 'closed')
  })
})
