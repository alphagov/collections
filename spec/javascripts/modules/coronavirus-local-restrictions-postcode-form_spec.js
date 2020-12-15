describe('CoronavirusLocalRestrictionsPostcodeForm', function () {
  'use strict'

  var input, button, container

  beforeEach(function () {
    container = document.createElement('div')
    container.innerHTML =
      '<form data-module="coronavirus-local-restrictions-postcode-form">' +
        '<input name="postcode">' +
        '<button type="submit">Submit</button>' +
      '</form>'
    document.body.appendChild(container)

    var form = container.querySelector('form')
    form.addEventListener('submit', function (e) {
      e.preventDefault()
    })

    input = form.querySelector('input')
    button = form.querySelector('button')

    var postcodeForm = new GOVUK.Modules.CoronavirusLocalRestrictionsPostcodeForm()
    postcodeForm.start($(form))
  })

  afterEach(function () {
    document.body.removeChild(container)
  })

  it('uppercases and spaces a valid looking postcode', function () {
    input.value = ' sw1a2aa '
    button.click()
    expect(input.value).toBe('SW1A 2AA')
  })

  it('doesn\'t change an invalid looking postcode', function () {
    var postcode = '677adsf12312'
    input.value = postcode
    button.click()
    expect(input.value).toBe(postcode)
  })

  it('doesn\'t change an uncommon postcode format', function () {
    var postcode = 'gir 0aa'
    input.value = postcode
    button.click()
    expect(input.value).toBe(postcode)
  })
})
