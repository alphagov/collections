/* eslint-env jasmine */
/* eslint-disable no-var */

describe('list-filter.js', function () {
  'use strict'

  function searchAndFilter (searchTerm) {
    wrapper.querySelector('[data-filter="form"] input').value = searchTerm
    window.GOVUK.triggerEvent(wrapper.querySelector('[data-filter="form"] input'), 'keyup')
  }

  var wrapper
  var timeout = 210

  var stubStyling = `
    <style>
      .js-hidden {
        display: none;
        visibility: none
      }
    </style>
  `

  var form = `
    <form data-filter="form"></div>
      <input type="search" id="filter-organisations-list" />
    </form>
  `

  // Double space and line break added on purpose:
  // https://github.com/alphagov/collections/pull/2251
  var items = `
    <div id="search_results">
      <div data-filter="block">
        <div data-filter="count" class="count-for-logos">
          <h2>Ministerial Departments</h2>
          <p>There are <span class="js-accessible-item-count">2</span> Ministerial Departments</p>
          <div class="gem-c-big-number">
            <span class="gem-c-big-number__value" data-item-count="true">2</span>
          </div>
        </div>
        <ol>
          <li data-filter="item" class="org-logo-1" data-filter-terms="Cabinet Office">
            <div class="gem-c-organisation-logo__name">Cabinet Office</div>
          </li>
          <li data-filter="item" class="org-logo-2" data-filter-terms="Cabinet Office CO">
            <div class="gem-c-organisation-logo__name">Cabinet Office</div>
          </li>
          <li data-filter="item" class="org-logo-3" data-filter-terms="Ministry of  Funny\nWalks MFW">
            <div class="gem-c-organisation-logo__name">Ministry of  Funny\nWalks</div>
          </li>
          <div data-filter="inner-block">
            <ol>
              <li data-filter="item" class="org-logo-4" data-filter-terms="Ministry of Inner Blocks MIB">
                <div class="gem-c-organisation-logo__name">Ministry of Inner Blocks</div>
              </li>
            </ol>
          </div>
        </ol>
      </div>
      <div data-filter="block">
        <div data-filter="count" class="count-for-no-logos">
          <h2>Non Ministerial Departments</h2>
          <p>There are <span class="js-accessible-item-count">2</span> Non Ministerial Departments</p>
          <div class="gem-c-big-number">
            <span class="gem-c-big-number__value" data-item-count="true">2</span>
          </div>
        </div>
        <ol>
          <li data-filter="item" class="org-no-logo-1" data-filter-terms="Advisory Committee on Releases to the Environment">
            <a class="list__item-title">Advisory Committee on Releases to the Environment</a>
          </li>
          <li data-filter="item" class="org-no-logo-2" data-filter-terms="Advisory Council on the Misuse of Drugs">
            <a class="list__item-title">Advisory Council on the Misuse of Drugs</a>
          </li>
        </ol>
      </div>
    </div>
  `

  beforeAll(function () {
    wrapper = document.createElement('div')
    wrapper.classList.add('wrapper')
    wrapper.innerHTML = `
      ${stubStyling}
      ${form}
      ${items}
    `

    document.body.appendChild(wrapper)

    new GOVUK.Modules.ListFilter(wrapper).init()
  })

  afterAll(function () {
    document.body.removeChild(wrapper)
  })

  afterEach(function (done) {
    setTimeout(function () {
      searchAndFilter('')
      done()
    }, 1)
  })

  it('hide items that do not match the search term', function (done) {
    searchAndFilter('Advisory cou')

    setTimeout(function () {
      expect(wrapper.querySelector('.org-logo-1')).toHaveClass('js-hidden')
      expect(wrapper.querySelector('.org-logo-2')).toHaveClass('js-hidden')
      expect(wrapper.querySelector('.org-no-logo-1')).toHaveClass('js-hidden')
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('1 result found')
      done()
    }, timeout)
  })

  it('show items that do match the search term', function (done) {
    searchAndFilter('Advisory cou')

    setTimeout(function () {
      expect(wrapper.querySelector('.org-no-logo-2')).not.toHaveClass('js-hidden')
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('1 result found')
      done()
    }, timeout)
  })

  it('show items that do have additional terms that match the search term', function (done) {
    searchAndFilter('mfw')

    setTimeout(function () {
      expect(wrapper.querySelector('.org-logo-3')).not.toHaveClass('js-hidden')
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('1 result found')
      done()
    }, timeout)
  })

  it('show items that do have names or additional terms that match the search term', function (done) {
    searchAndFilter('co')

    setTimeout(function () {
      expect(wrapper.querySelector('.org-logo-2')).not.toHaveClass('js-hidden')
      expect(wrapper.querySelector('.org-no-logo-1')).not.toHaveClass('js-hidden')
      expect(wrapper.querySelector('.org-no-logo-2')).not.toHaveClass('js-hidden')
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('3 results found')
      done()
    }, timeout)
  })

  it('hides items that do not have names or additional terms that match the search term', function (done) {
    searchAndFilter('co')

    setTimeout(function () {
      expect(wrapper.querySelector('.org-logo-1')).toHaveClass('js-hidden')
      expect(wrapper.querySelector('.org-logo-3')).toHaveClass('js-hidden')
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('3 results found')
      done()
    }, timeout)
  })

  it('hide department counts and names if they have no matching items', function (done) {
    searchAndFilter('Advisory cou')

    setTimeout(function () {
      expect(wrapper.querySelector('.count-for-logos').parentElement).toHaveClass('js-hidden')
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('1 result found')
      done()
    }, timeout)
  })

  it('update the item count', function (done) {
    searchAndFilter('Advisory cou')

    setTimeout(function () {
      expect(wrapper.querySelector('.count-for-no-logos')).not.toHaveClass('js-hidden')
      expect(wrapper.querySelector('.count-for-no-logos .js-accessible-item-count').textContent).toBe('1')
      expect(wrapper.querySelector('.count-for-no-logos [data-item-count="true"]').textContent).toBe('1')
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('1 result found')
      done()
    }, timeout)
  })

  it('shows a message if there are no matching items', function (done) {
    searchAndFilter('Nothing will match this')

    setTimeout(function () {
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('0 results found')
      done()
    }, timeout)
  })

  it('copes when item name contains line breaks and multiple spaces', function (done) {
    searchAndFilter('ministry of funny walks')

    setTimeout(function () {
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('1 result found')
      done()
    }, timeout)
  })

  it('hide inner blocks if they have no matching items', function (done) {
    searchAndFilter('Advisory cou')

    setTimeout(function () {
      expect(wrapper.querySelector('[data-filter="inner-block"]')).toHaveClass('js-hidden')
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('1 result found')
      done()
    }, timeout)
  })

  it('reveals inner blocks if they have matching items', function (done) {
    searchAndFilter('Ministry of Inner Blocks')

    setTimeout(function () {
      expect(wrapper.querySelector('[data-filter="inner-block"]')).not.toHaveClass('js-hidden')
      expect(wrapper.querySelector('.js-search-results').textContent).toBe('1 result found')
      done()
    }, timeout)
  })
})
