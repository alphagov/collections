/* global $ GOVUK */
/* eslint-disable no-var */

(function () {
  'use strict'
  window.GOVUK = window.GOVUK || {}

  var filterTimeout = null

  window.GOVUK.filter = {
    init: function () {
      // Form should only appear if the JS is working
      $('[data-filter="form"]').addClass('filter-organisations-list__form--active')

      this.results = document.createElement('div')
      this.results.classList.add('filter-organisations-list__results', 'govuk-heading-m', 'js-search-results')
      this.results.setAttribute('aria-live', 'polite')
      this.results.innerHTML = window.GOVUK.filter.countInitialDepartments() + ' results found'

      $('#organisations_search_results').prepend(this.results)

      // We don't want the form to submit/refresh the page on enter key
      $('[data-filter="form"]').on('submit', function () { return false })

      $('[data-filter="form"] input').on('keyup', window.GOVUK.filter.filterViaTimeout)
    },

    filterViaTimeout: function (e) {
      clearTimeout(filterTimeout)

      filterTimeout = setTimeout(function () {
        window.GOVUK.filter.filterList(e)
      }, 200)
    },

    filterList: function (e) {
      var itemsToFilter = $('[data-filter="item"]')
      var listsToFilter = $('[data-filter="list"]')
      var searchTerm = $(e.target).val()

      itemsToFilter.not(function () {
        var currentOrganisation = $(this)
        return window.GOVUK.filter.matchSearchTerm(currentOrganisation, searchTerm)
      }).addClass('js-hidden')

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
      var organisationAcronym = organisation.attr('data-filter-acronym') || ''

      organisation.removeClass('js-hidden')

      if (organisation.find('.gem-c-organisation-logo__name').length > 0) {
        organisationText = normaliseWhitespace(
          organisation.find('.gem-c-organisation-logo__name').text()
        )
      } else {
        organisationText = normaliseWhitespace(
          organisation.find('.organisation-list__item-title').text()
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

      listsToFilter.each(function () {
        var matchingOrgCount = $(this).find('[data-filter="item"]:visible').length
        var departmentSection = $(this).closest('[data-filter="block"]')
        var departmentCountWrapper = departmentSection.find('[data-filter="count"]')
        var departmentCount = departmentSection.find('.js-department-count')
        var accessibleDepartmentCount = departmentSection.find('.js-accessible-department-count')

        departmentCountWrapper.toggleClass('js-hidden', matchingOrgCount === 0)

        if (matchingOrgCount > 0) {
          departmentCount.text(matchingOrgCount)
          accessibleDepartmentCount.text(matchingOrgCount)
        }

        totalMatchingOrgs += matchingOrgCount
      })

      var text = ' results found'
      if (totalMatchingOrgs === 1) {
        text = ' result found'
      }
      this.results.innerHTML = totalMatchingOrgs + text
    }
  }

  $(function () { GOVUK.filter.init() })
}())
