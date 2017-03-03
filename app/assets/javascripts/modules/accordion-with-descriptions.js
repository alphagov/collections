// Most of this is taken from the service manual and at some point needs to be
// separated out into a component.  We are currently holding off on this until
// it is tested more within the current navigation changes.

window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  "use strict";

  Modules.AccordionWithDescriptions = function() {

    var bulkActions = {
      openAll: {
        buttonText: "Expand all",
        eventLabel: "Open All"
      },
      closeAll: {
        buttonText: "Close all",
        eventLabel: "Close All"
      }
    }

    this.start = function($element) {

      // Indicate that js has worked
      $element.addClass('js-accordion-with-descriptions');

      // Prevent FOUC, remove class hiding content
      $element.removeClass('js-hidden');

      var $subsectionHeaders = $element.find('.subsection-header');
      var totalSubsections = $element.find('.subsection-content').length;

      var $openOrCloseAllButton;

      addOpenCloseAllButton();
      addButtonsToSubsections();
      addIconsToSubsections();
      addAriaControlsAttrForOpenCloseAllButton();

      closeAllSections();
      openLinkedSection();

      bindToggleForSubsections();
      bindToggleOpenCloseAllButton();

      function addOpenCloseAllButton() {
        $element.prepend( '<div class="subsection-controls js-subsection-controls"><button aria-expanded="false">' + bulkActions.openAll.buttonText + '</button></div>' );
      }

      function addButtonsToSubsections() {
        var $subsectionTitle = $element.find('.subsection-title');

        // Wrap each title in a button, with aria controls matching the ID of the subsection
        $subsectionTitle.each(function(index) {
          $(this).wrapInner( '<button class="subsection-button js-subsection-button" aria-expanded="false" aria-controls="subsection_content_' + index +'"></button>' );
        });
      }

      function addIconsToSubsections() {
        $subsectionHeaders.append( '<span class="subsection-icon"></span>' );
      }

      function addAriaControlsAttrForOpenCloseAllButton() {
        // For each of the sections, create a string with all the subsection content IDs
        var ariaControlsValue = "";
        for (var i = 0; i < totalSubsections; i++) {
          ariaControlsValue += "subsection_content_"+i+" ";
        }

        $openOrCloseAllButton = $element.find('.js-subsection-controls button');

        // Set the aria controls for the open/close all button value for all content items
        $openOrCloseAllButton.attr('aria-controls', ariaControlsValue);
      }

      function closeAllSections() {
        $.each($element.find('.js-subsection'), function () {
          var subsectionView = new SubsectionView($(this));
          subsectionView.close();
        });
      }

      function openLinkedSection() {
        var anchor = getActiveAnchor(),
            $subsection;

        if (!anchor.length) {
          return;
        }

        $subsection = $element.find(anchor).parents('.js-subsection');

        if ($subsection.length) {
          var subsectionView = new SubsectionView($subsection);
          subsectionView.open();
        }
      }

      function getActiveAnchor() {
        return GOVUK.getCurrentLocation().hash;
      }

      function bindToggleForSubsections() {
        $element.find('.subsection-header').on('click', function(event) {
          var $subsectionHeader = $(this);
          var $subsection = $subsectionHeader.parent('.js-subsection');
          var subsectionView = new SubsectionView($subsection);

          subsectionView.toggle();
          setOpenCloseAllText();

          var subsectionToggleClick = new SubsectionToggleClick(subsectionView, event);
          subsectionToggleClick.track();

          return false;
        });
      }

      function bindToggleOpenCloseAllButton() {
        $openOrCloseAllButton = $element.find('.js-subsection-controls button');
        $openOrCloseAllButton.on('click', function(e) {
          var action = '';

          // update button text
          if ($openOrCloseAllButton.text() == bulkActions.openAll.buttonText) {
            $openOrCloseAllButton.text(bulkActions.closeAll.buttonText);
            $openOrCloseAllButton.attr("aria-expanded", "true");
            action = 'open';

            track('pageElementInteraction', 'accordionAllOpened', {
              label: bulkActions.openAll.eventLabel
            });
          } else {
            $openOrCloseAllButton.text(bulkActions.openAll.buttonText);
            $openOrCloseAllButton.attr("aria-expanded", "false");
            action = 'close';

            track('pageElementInteraction', 'accordionAllClosed', {
              label: bulkActions.closeAll.eventLabel
            });
          }

          $element.find('.js-subsection').each(function() {
            var $subsection = $(this);
            var $button = $subsection.find('.js-subsection-button');
            var $subsectionContent = $subsection.find('.js-subsection-content');

            if (action == 'open') {
              $button.attr("aria-expanded", "true");
              $subsectionContent.removeClass('js-hidden');
              $subsection.removeClass('subsection');
              $subsection.addClass('subsection-is-open');
            } else {
              $button.attr("aria-expanded", "false");
              $subsectionContent.addClass('js-hidden');
              $subsection.addClass('subsection');
              $subsection.removeClass('subsection-is-open');
            }
          });

          return false;
        });
      }

      function setOpenCloseAllText() {
        var openSubsections = $element.find('.subsection-is-open').length;
        // Find out if the number of is-opens == total number of sections
        if (openSubsections === totalSubsections) {
          $openOrCloseAllButton.text(bulkActions.closeAll.buttonText);
        } else {
          $openOrCloseAllButton.text(bulkActions.openAll.buttonText);
        }
      }

    }

    function SubsectionView ($subsectionElement) {
      var that = this;

      // The 'Content' is the container of links to guides
      this.$subsectionContent = $subsectionElement.find('.js-subsection-content');
      // The 'Button' is a button element that is wrapped around the title for
      // accessibility reasons
      this.$subsectionButton = $subsectionElement.find('.js-subsection-button');

      this.title = that.$subsectionButton.text();

      this.toggle = function () {
        if (that.isClosed()) {
          that.open();
        } else {
          that.close();
        }
      }

      this.open = function () {
        // Show the subsection content
        that.$subsectionContent.removeClass('js-hidden');
        // Swap the plus and minus sign
        $subsectionElement.removeClass('subsection');
        $subsectionElement.addClass('subsection-is-open');
        // Tell impaired users that the section is open
        that.$subsectionButton.attr("aria-expanded", "true");
      }

      this.close = function () {
        // Hide the subsection content
        that.$subsectionContent.addClass('js-hidden');
        // Swap the plus and minus sign
        $subsectionElement.removeClass('subsection-is-open');
        $subsectionElement.addClass('subsection');
        // Tell impaired users that the section is closed
        that.$subsectionButton.attr("aria-expanded", "false");
      }

      this.isClosed = function () {
        return that.$subsectionContent.hasClass('js-hidden');
      }
    }

    // A contructor for an object that represents a click event on a subsection which
    // handles the complexity of sending different tracking labels to Google Analytics
    // depending on which part of the subsection the user clicked.
    function SubsectionToggleClick (subsectionView, event) {
      var that = this;

      this.$target = $(event.target);

      this.track = function () {
        track('pageElementInteraction', that._trackingAction(), { label: that._trackingLabel() });
      }

      this._trackingAction = function () {
        return (subsectionView.isClosed() ? 'accordionClosed' : 'accordionOpened');
      }

      this._trackingLabel = function () {
        if (that._clickedOnIcon()) {
          return subsectionView.title + ' - ' + that._iconType() + ' Click';
        } else if (that._clickedOnHeading()) {
          return subsectionView.title + ' - Heading Click';
        } else {
          return subsectionView.title + ' - Click Elsewhere';
        }
      }

      this._clickedOnIcon = function () {
        return that.$target.hasClass('subsection-icon');
      }

      this._clickedOnHeading = function () {
        return that.$target.hasClass('js-subsection-button');
      }

      this._iconType = function () {
        return (subsectionView.isClosed() ? 'Minus' : 'Plus');
      }
    }

    // A helper that sends an custom event request to Google Analytics if
    // the GOVUK module is setup
    function track(category, action, options) {
      if (GOVUK.analytics && GOVUK.analytics.trackEvent) {
        GOVUK.analytics.trackEvent(category, action, options);
      }
    }
  };
})(window.GOVUK.Modules);
