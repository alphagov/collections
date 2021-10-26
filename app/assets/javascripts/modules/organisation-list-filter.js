/* eslint-disable no-var */

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function FilterOrganisations ($module) {
    this.$module = $module
    this.filterTimeout = null
    this.form = this.$module.querySelector('[data-filter="form"]')
    this.orgResults = this.$module.querySelector('#organisations_search_results')
  }

  FilterOrganisations.prototype.init = function () {
    this.$module.filterList = this.filterList.bind(this)
    // Form should only appear if the JS is working
    this.form.classList.add('filter-organisations-list__form--active')
    this.results = document.createElement('div')
    this.results.classList.add('filter-organisations-list__results', 'govuk-heading-m', 'js-search-results')
    this.results.setAttribute('aria-live', 'polite')
    this.results.innerHTML = this.countInitialDepartments() + ' results found'
    this.orgResults.insertBefore(this.results, this.orgResults.firstChild)

    // We don't want the form to submit/refresh the page on enter key
    this.form.onsubmit = function () { return false }

    this.form.addEventListener('keyup', function (e) {
      var searchTerm = e.target.value
      clearTimeout(this.filterTimeout)
      this.filterTimeout = setTimeout(function () {
        this.$module.filterList(searchTerm)
      }.bind(this), 200)
    }.bind(this))
  }

  FilterOrganisations.prototype.filterList = function (searchTerm) {
    var itemsToFilter = this.$module.querySelectorAll('[data-filter="item"]')
    var listsToFilter = this.$module.querySelectorAll('[data-filter="list"]')
    for (var i = 0; i <= itemsToFilter.length - 1; i++) {
      var currentOrganisation = itemsToFilter[i]
      if (!this.matchSearchTerm(currentOrganisation, searchTerm)) {
        currentOrganisation.classList.add('js-hidden')
      }
    }
    this.updateDepartmentCount(listsToFilter)
  }

  FilterOrganisations.prototype.matchSearchTerm = function (organisation, term) {
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
  }

  FilterOrganisations.prototype.countInitialDepartments = function () {
    return this.$module.querySelectorAll('[data-filter="item"]').length
  }

  FilterOrganisations.prototype.updateDepartmentCount = function (listsToFilter) {
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

      var departmentCount = departmentSection.querySelectorAll('[data-department-count="true"]')
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

  Modules.FilterOrganisations = FilterOrganisations
})(window.GOVUK.Modules)
