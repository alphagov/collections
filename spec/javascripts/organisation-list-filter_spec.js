describe('organisation-list-filter.js', function () {
  'use strict'

  var timeout = 210

  var stubStyling =
    '<style>' +
      '.js-hidden {' +
        'display: none;' +
        'visibility: none' +
      '}' +
    '</style>'

  var form =
    '<form data-filter="form"></div>' +
      '<input type="search" id="filter-organisations-list" />' +
    '</form>'

  var organisations =
    '<div id="organisations_search_results">' +
      '<div data-filter="block">' +
        '<div data-filter="count" class="count-for-logos">' +
          '<h2>Ministerial Departments</h2>' +
          '<p>There are <span class="js-accessible-department-count">2</span> Ministerial Departments</p>' +
          '<span class="js-department-count">2</span>' +
        '</div>' +
        '<ol data-filter="list">' +
          '<li data-filter="item" class="org-logo-1">' +
            '<div class="gem-c-organisation-logo__name">Cabinet Office</div>' +
          '</li>' +
          '<li data-filter="item" class="org-logo-2">' +
            '<div class="gem-c-organisation-logo__name">Cabinet Office</div>' +
          '</li>' +
        '</ol>' +
      '</div>' +
      '<div data-filter="block">' +
        '<div data-filter="count" class="count-for-no-logos">' +
          '<h2>Non Ministerial Departments</h2>' +
          '<p>There are <span class="js-accessible-department-count">2</span> Non Ministerial Departments</p>' +
          '<span class="js-department-count">2</span>' +
        '</div>' +
        '<ol data-filter="list">' +
          '<li data-filter="item" class="org-no-logo-1">' +
            '<a class="organisation-list__item-title">Advisory Committee on Releases to the Environment</a>' +
          '</li>' +
          '<li data-filter="item" class="org-no-logo-2">' +
            '<a class="organisation-list__item-title">Advisory Council on the Misuse of Drugs</a>' +
          '</li>' +
        '</ol>' +
      '</div>' +
    '</div>'

  beforeAll(function () {
    $(document.body).append(stubStyling)
    $(document.body).append(form)
    $(document.body).append(organisations)
    GOVUK.filter.init()
  })

  afterEach(function (done) {
    setTimeout(function () {
      $('[data-filter="form"] input').val('')
      $('[data-filter="form"] input').trigger('keyup')
      done()
    }, 1)
  })

  it('hide items that do not match the search term', function (done) {
    $('[data-filter="form"] input').val('Advisory cou')
    $('[data-filter="form"] input').trigger('keyup')

    setTimeout(function () {
      expect($('.org-logo-1')).toHaveClass('js-hidden')
      expect($('.org-logo-2')).toHaveClass('js-hidden')
      expect($('.org-no-logo-1')).toHaveClass('js-hidden')
      expect($('.js-search-results')).toHaveText('1 result found')
      done()
    }, timeout)
  })

  it('show items that do match the search term', function (done) {
    $('[data-filter="form"] input').val('Advisory cou')
    $('[data-filter="form"] input').trigger('keyup')

    setTimeout(function () {
      expect($('.org-no-logo-2')).not.toHaveClass('js-hidden')
      expect($('.js-search-results')).toHaveText('1 result found')
      done()
    }, timeout)
  })

  it('hide department counts and names if they have no matching organisations', function (done) {
    $('[data-filter="form"] input').val('Advisory cou')
    $('[data-filter="form"] input').trigger('keyup')

    setTimeout(function () {
      expect($('.count-for-logos')).toHaveClass('js-hidden')
      expect($('.js-search-results')).toHaveText('1 result found')
      done()
    }, timeout)
  })

  it('update the department count', function (done) {
    $('[data-filter="form"] input').val('Advisory cou')
    $('[data-filter="form"] input').trigger('keyup')

    setTimeout(function () {
      expect($('.count-for-no-logos')).not.toHaveClass('js-hidden')
      expect($('.count-for-no-logos .js-accessible-department-count')).toHaveText(1)
      expect($('.count-for-no-logos .js-department-count')).toHaveText(1)
      expect($('.js-search-results')).toHaveText('1 result found')
      done()
    }, timeout)
  })

  it('shows a message if there are no matching organisations', function (done) {
    $('[data-filter="form"] input').val('Nothing will match this')
    $('[data-filter="form"] input').trigger('keyup')

    setTimeout(function () {
      expect($('.js-search-results')).toHaveText('0 results found')
      done()
    }, timeout)
  })
})
