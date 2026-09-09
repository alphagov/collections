describe('A toggle attribute module', function () {
  'use strict'

  let element

  beforeEach(function () {
    element = document.createElement('div')
    element.innerHTML = `
      <div id="unnested-click" data-toggle-attribute="data-state" data-when-closed-text="closed" data-when-open-text="open" data-state="closed"></div>
      <div id="nested-click" data-toggle-attribute="data-state" data-when-closed-text="closed" data-when-open-text="open" data-state="closed">
        <button type="button"><span>Toggler</span></button>
      </div>
    `
    const toggle = new GOVUK.Modules.ToggleAttribute(element)
    toggle.init()
  })

  it('sets the state to open when clicked and back again', function () {
    const unnested = element.querySelector('#unnested-click')

    expect(unnested.getAttribute('data-state')).toBe('closed')
    unnested.click()
    expect(unnested.getAttribute('data-state')).toBe('open')
    unnested.click()
    expect(unnested.getAttribute('data-state')).toBe('closed')
  })

  it('can handle a click on a nested element', function () {
    const nested = element.querySelector('#nested-click')
    const span = nested.querySelector('span')

    expect(nested.getAttribute('data-state')).toBe('closed')
    span.click()
    expect(nested.getAttribute('data-state')).toBe('open')
  })
})
