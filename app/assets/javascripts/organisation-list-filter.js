/* global $ GOVUK */
/* eslint-disable no-var */

(function () {
  window.GOVUK = window.GOVUK || {}

  var filterTimeout = null

  window.GOVUK.filter = {
    init: function () {
      // Form should only appear if the JS is working
      var element = document.querySelector('[data-filter="form"]')

      if (element) {
        element.classList.add('filter-organisations-list__form--active')

        this.results = document.createElement('div')
        this.results.classList.add('filter-organisations-list__results', 'govuk-heading-m', 'js-search-results')
        this.results.setAttribute('aria-live', 'polite')
        this.results.innerHTML = window.GOVUK.filter.countInitialDepartments() + ' results found'

        var orgResults = document.querySelector('#organisations_search_results')
        orgResults.insertBefore(this.results, orgResults.firstChild)

        // We don't want the form to submit/refresh the page on enter key

        // FIXME
        element.onsubmit = function () { return false }
        element.onkeyup = window.GOVUK.filter.filterViaTimeout
      }
    },

    filterViaTimeout: function (e) {
      clearTimeout(filterTimeout)

      filterTimeout = setTimeout(function () {
        window.GOVUK.filter.filterList(e)
      }, 200)
    },

    filterList: function (e) {
      var itemsToFilter = document.querySelectorAll('[data-filter="item"]')
      var listsToFilter = document.querySelectorAll('[data-filter="list"]')
      var searchTerm = e.target.value

      for (var i = 0; i <= itemsToFilter.length - 1; i++) {
        var currentOrganisation = itemsToFilter[i]
        if (!window.GOVUK.filter.matchSearchTerm(currentOrganisation, searchTerm)) {
          currentOrganisation.classList.add('js-hidden')
        }
      }

      window.GOVUK.filter.updateDepartmentCount(listsToFilter)
    },

    matchSearchTerm: function (organisation, term) {
      var normaliseWhitespace = function (string) {
        return string
          .trim() // Removes spaces at beginning and end of string.
          .replace(/\r?\n|\r/g, ' ') // Replaces line breaks with one space.
          .replace(/\s+/g, ' ') // Squashes multiple spaces to one space.
      }

      var organisationText = ''
      var organisationAcronym = organisation.getAttribute('data-filter-acronym') || ''

      organisation.classList.remove('js-hidden')

      if (organisation.querySelectorAll('.gem-c-organisation-logo__name').length > 0) {
        organisationText = normaliseWhitespace(
          organisation.querySelector('.gem-c-organisation-logo__name').textContent
        )
      } else {
        organisationText = normaliseWhitespace(
          organisation.querySelector('.organisation-list__item-title').textContent
        )
      }

      var searchTermRegexp = new RegExp(term.trim().replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i')
      if (
        searchTermRegexp.exec(organisationText) !== null ||
        searchTermRegexp.exec(organisationAcronym) !== null
      ) {
        return true
      }
    },

    countInitialDepartments: function () {
      return document.querySelectorAll('[data-filter="item"]').length
    },

    updateDepartmentCount: function (listsToFilter) {
      var totalMatchingOrgs = 0

      for (var i = 0; i < listsToFilter.length; i++) {
        var departmentSection = listsToFilter[i].closest('[data-filter="block"]')
        departmentSection.classList.remove('js-hidden')

        var matchingOrgs = listsToFilter[i].querySelectorAll('[data-filter="item"]')
        var matchingOrgCount = 0
        for (var j = 0; j < matchingOrgs.length; j++) {
          if (!matchingOrgs[j].classList.contains('js-hidden')) {
            matchingOrgCount++
          }
        }
        var departmentCount = departmentSection.querySelectorAll('.js-department-count')
        var accessibleDepartmentCount = departmentSection.querySelectorAll('.js-accessible-department-count')

        if (matchingOrgCount === 0) {
          departmentSection.classList.toggle('js-hidden')
        }

        if (matchingOrgCount > 0) {
          for (var l = 0; l < departmentCount.length; l++) {
            departmentCount[l].textContent = matchingOrgCount
          }

          for (var k = 0; k < accessibleDepartmentCount.length; k++) {
            accessibleDepartmentCount[k].textContent = matchingOrgCount
          }
        }

        totalMatchingOrgs += matchingOrgCount
      }

      var text = ' results found'
      if (totalMatchingOrgs === 1) {
        text = ' result found'
      }
      this.results.innerHTML = totalMatchingOrgs + text
    }
  }

  $(function () { GOVUK.filter.init() })
}())
