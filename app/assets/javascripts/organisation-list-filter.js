(function() {
  "use strict";
  window.GOVUK = window.GOVUK || {};

  var filterTimeout = null;

  window.GOVUK.filter = {
    init: function() {
      // We don't want the form to submit/refresh the page on enter key
      $('[data-filter="form"]').on('submit', function() { return false; })

      $('[data-filter="form"] input').on('keyup', window.GOVUK.filter.filterViaTimeout);
    },

    filterViaTimeout: function(e) {
      clearTimeout(filterTimeout);

      filterTimeout = setTimeout(function() {
        window.GOVUK.filter.filterList(e);
      }, 200);
    },

    filterList: function(e) {
      var itemsToFilter = $('[data-filter="item"]');
      var listsToFilter = $('[data-filter="list"]');
      var searchTerm = $(e.target).val();

      itemsToFilter.not(function() {
        var currentOrganisation = $(this);
        return window.GOVUK.filter.matchSearchTerm(currentOrganisation, searchTerm);
      }).addClass('js-hidden');

      window.GOVUK.filter.updateDepartmentCount(listsToFilter);
    },

    matchSearchTerm: function(organisation, term) {
      var organisationText = "";

      organisation.removeClass('js-hidden');

      if (organisation.find('.logo-container').length > 0) {
        organisationText = organisation.find('.logo-container').text();
      }
      else {
        organisationText = organisation.find('.organisation-list__item-title').text();
      }

      var searchTermRegexp = new RegExp(term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i');
      if (searchTermRegexp.exec(organisationText) !== null) {
        return true;
      }
    },

    updateDepartmentCount: function(listsToFilter) {
      var totalMatchingOrgs = 0;

      listsToFilter.each(function() {
        var matchingOrgCount = $(this).find('[data-filter="item"]:visible').length;
        var departmentSection = $(this).closest('[data-filter="block"]');
        var departmentCountWrapper = departmentSection.find('[data-filter="count"]');
        var departmentCount = departmentSection.find('.js-department-count');
        var accessibleDepartmentCount = departmentSection.find('.js-accessible-department-count');

        departmentCountWrapper.toggleClass('js-hidden', matchingOrgCount == 0 );

        if (matchingOrgCount > 0) {
          departmentCount.text(matchingOrgCount);
          accessibleDepartmentCount.text(matchingOrgCount);
        }

        totalMatchingOrgs += matchingOrgCount;
      });

      $('.js-no-filter-matches').toggleClass('js-hidden', totalMatchingOrgs > 0);
    }
  };

  $(function(){ GOVUK.filter.init(); })
}());
