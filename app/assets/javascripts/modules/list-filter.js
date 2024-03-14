/* eslint-disable no-var */
//= require govuk_publishing_components/vendor/polyfills/closest

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function ListFilter ($module) {
    this.$module = $module
    this.filterTimeout = null
    this.form = this.$module.querySelector('[data-filter="form"]')
    this.searchResults = this.$module.querySelector('#search_results')
    this.init()
  }

  ListFilter.prototype.init = function () {
    this.$module.filterList = this.filterList.bind(this)
    // Form should only appear if the JS is working
    this.form.classList.add('filter-list__form--active')
    this.results = document.createElement('div')
    this.results.classList.add('filter-list__results', 'govuk-heading-m', 'js-search-results')
    this.results.setAttribute('aria-live', 'polite')
    this.results.innerHTML = this.countInitialItems() + ' results found'
    this.searchResults.insertBefore(this.results, this.searchResults.firstChild)

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

  ListFilter.prototype.filterList = function (searchTerm) {
    var itemsToFilter = this.$module.querySelectorAll('[data-filter="item"]')
    var blocksToFilter = this.$module.querySelectorAll('[data-filter="block"]')
    for (var i = 0; i <= itemsToFilter.length - 1; i++) {
      var currentItem = itemsToFilter[i]
      if (!this.matchSearchTerm(currentItem, searchTerm)) {
        currentItem.classList.add('js-hidden')
      }
    }
    this.updateItemCount(blocksToFilter)
  }

  ListFilter.prototype.matchSearchTerm = function (item, term) {
    var normaliseWhitespace = function (string) {
      return string
        .trim() // Removes spaces at beginning and end of string.
        .replace(/\r?\n|\r/g, ' ') // Replaces line breaks with one space.
        .replace(/\s+/g, ' ') // Squashes multiple spaces to one space.
    }

    var searchTerms = item.getAttribute('data-filter-terms') || ''
    var normalisedTerms = normaliseWhitespace(searchTerms)

    item.classList.remove('js-hidden')

    var searchTermRegexp = new RegExp(term.trim().replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i')
    return searchTermRegexp.exec(normalisedTerms) !== null
  }

  ListFilter.prototype.countInitialItems = function () {
    return this.$module.querySelectorAll('[data-filter="item"]').length
  }

  ListFilter.prototype.updateItemCount = function (blocksToFilter) {
    var totalMatchingItems = 0

    for (var i = 0; i < blocksToFilter.length; i++) {
      var block = blocksToFilter[i].closest('[data-filter="block"]')
      block.classList.remove('js-hidden')

      var matchingItems = block.querySelectorAll('[data-filter="item"]')
      var matchingItemCount = 0

      var innerBlocks = block.querySelectorAll('[data-filter="inner-block"]')
      for (var r = 0; r < innerBlocks.length; r++) {
        innerBlocks[r].classList.add('js-hidden')
      }

      for (var j = 0; j < matchingItems.length; j++) {
        if (!matchingItems[j].classList.contains('js-hidden')) {
          matchingItemCount++

          if (matchingItems[j].closest('[data-filter="inner-block"]') !== null) { matchingItems[j].closest('[data-filter="inner-block"]').classList.remove('js-hidden') }
        }
      }

      var itemCount = block.querySelectorAll('[data-item-count="true"]')
      var accessibleItemCount = block.querySelectorAll('.js-accessible-item-count')

      if (matchingItemCount === 0) {
        block.classList.toggle('js-hidden')
      }

      if (matchingItemCount > 0) {
        for (var l = 0; l < itemCount.length; l++) {
          itemCount[l].textContent = matchingItemCount
        }

        for (var k = 0; k < accessibleItemCount.length; k++) {
          accessibleItemCount[k].textContent = matchingItemCount
        }
      }

      totalMatchingItems += matchingItemCount
    }

    var text = ' results found'
    if (totalMatchingItems === 1) {
      text = ' result found'
    }
    this.results.innerHTML = totalMatchingItems + text
  }

  Modules.ListFilter = ListFilter
})(window.GOVUK.Modules)
