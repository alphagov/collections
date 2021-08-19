describe('A toggle attribute module', function () {
  'use strict'

  var element

  beforeEach(function () {
    element = document.createElement('div')
    element.innerHTML =
      '<div id="unnested-click" data-toggle-attribute="data-state" data-when-closed-text="closed" data-when-open-text="open" data-state="closed"></div>' +
      '<div id="nested-click" data-toggle-attribute="data-state" data-when-closed-text="closed" data-when-open-text="open" data-state="closed">' +
        '<button type="button"><span>Toggler</span></button>' +
      '</div>'
    var toggle = new GOVUK.Modules.ToggleAttribute(element)
    toggle.init()
  })

  it('sets the state to open when clicked and back again', function () {
    var unnested = element.querySelector('#unnested-click')

    expect(unnested).toHaveAttr('data-state', 'closed')
    unnested.click()
    expect(unnested).toHaveAttr('data-state', 'open')
    unnested.click()
    expect(unnested).toHaveAttr('data-state', 'closed')
  })

  it('can handle a click on a nested element', function () {
    var nested = element.querySelector('#nested-click')
    var span = nested.querySelector('span')

    expect(nested).toHaveAttr('data-state', 'closed')
    span.click()
    expect(nested).toHaveAttr('data-state', 'open')
  })
})
