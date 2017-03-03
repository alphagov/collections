// Most of this is taken from the service manual and at some point needs to be
// separated out into a component.  We are currently holding off on this until
// it is tested more within the current navigation changes.

window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  "use strict";

  Modules.AccordionWithDescriptions = function () {

    var bulkActions = {
      openAll: {
        buttonText: "Expand all",
        eventLabel: "Open All"
      },
      closeAll: {
        buttonText: "Close all",
        eventLabel: "Close All"
      }
    };

    this.start = function ($element) {

      // Indicate that js has worked
      $element.addClass('js-accordion-with-descriptions');

      // Prevent FOUC, remove class hiding content
      $element.removeClass('js-hidden');

      var $subsections = $element.find('.js-subsection');
      var $subsectionHeaders = $element.find('.subsection-header');
      var totalSubsections = $element.find('.subsection-content').length;

      var $openOrCloseAllButton;

      wrapHeadersInLinks();
      addOpenCloseAllButton();
      addIconsToSubsections();
      addAriaControlsAttrForOpenCloseAllButton();

      closeAllSections();
      openLinkedSection();

      bindToggleForSubsections();
      bindToggleOpenCloseAllButton();

      function addOpenCloseAllButton() {
        $element.prepend('<div class="subsection-controls js-subsection-controls"><button aria-expanded="false">' + bulkActions.openAll.buttonText + '</button></div>');
      }

      function addIconsToSubsections() {
        $subsectionHeaders.append('<span class="subsection-icon"></span>');
      }

      function addAriaControlsAttrForOpenCloseAllButton() {
        var ariaControlsValue = "";
        for (var i = 0; i < totalSubsections; i++) {
          ariaControlsValue += "subsection_content_" + i + " ";
        }

        $openOrCloseAllButton = $element.find('.js-subsection-controls button');
        $openOrCloseAllButton.attr('aria-controls', ariaControlsValue);
      }

      function closeAllSections() {
        setAllSectionsOpenState(false);
      }

      function setAllSectionsOpenState(isOpen) {
        $.each($subsections, function () {
          var subsectionView = new SubsectionView($(this));
          subsectionView.preventHashUpdate();
          subsectionView.setIsOpen(isOpen);
        });
      }

      function openLinkedSection() {
        var anchor = getActiveAnchor(),
          $subsection;

        if (!anchor.length) {
          return;
        }

        anchor = '#' + escapeSelector(anchor.substr(1));
        $subsection = $element.find(anchor);

        if ($subsection.length) {
          var subsectionView = new SubsectionView($subsection);
          subsectionView.open();
        }
      }

      function getActiveAnchor() {
        return GOVUK.getCurrentLocation().hash;
      }

      function wrapHeadersInLinks() {
        $.each($subsections, function () {
          var $subsection = $(this);
          var id = $subsection.attr('id');
          var $title = $subsection.find('.js-subsection-title');
          var contentId = $subsection.find('.js-subsection-content').first().attr('id');

          $title.wrap(
            '<a ' +
            'class="subsection-title-link js-subsection-title-link" ' +
            'href="#' + id + '" ' +
            'aria-controls="' + contentId + '"></a>'
          )
        });
      }

      function bindToggleForSubsections() {
        $element.find('.js-subsection-header').click(function (event) {
          event.preventDefault();

          var subsectionView = new SubsectionView($(this).closest('.js-subsection'));
          subsectionView.toggle();

          var toggleClick = new SubsectionToggleClick(subsectionView, event);
          toggleClick.track();

          setOpenCloseAllText();
        });
      }

      function bindToggleOpenCloseAllButton() {
        $openOrCloseAllButton = $element.find('.js-subsection-controls button');
        $openOrCloseAllButton.on('click', function () {
          var shouldOpenAll;

          if ($openOrCloseAllButton.text() == bulkActions.openAll.buttonText) {
            $openOrCloseAllButton.text(bulkActions.closeAll.buttonText);
            shouldOpenAll = true;

            track('pageElementInteraction', 'accordionAllOpened', {
              label: bulkActions.openAll.eventLabel
            });
          } else {
            $openOrCloseAllButton.text(bulkActions.openAll.buttonText);
            shouldOpenAll = false;

            track('pageElementInteraction', 'accordionAllClosed', {
              label: bulkActions.closeAll.eventLabel
            });
          }

          setAllSectionsOpenState(shouldOpenAll);
          $openOrCloseAllButton.attr('aria-expanded', shouldOpenAll);
          setOpenCloseAllText();
          setHash(null);

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

      // Ideally we'd use jQuery.escapeSelector, but this is only available from v3
      // See https://github.com/jquery/jquery/blob/2d4f53416e5f74fa98e0c1d66b6f3c285a12f0ce/src/selector-native.js#L46
      function escapeSelector(s) {
        var cssMatcher = /([\x00-\x1f\x7f]|^-?\d)|^-$|[^\x80-\uFFFF\w-]/g;
        return s.replace(cssMatcher, "\\$&");
      }
    };

    function SubsectionView($subsectionElement) {
      var $subsectionContent = $subsectionElement.find('.js-subsection-content');
      var $titleLink = $subsectionElement.find('.js-subsection-title-link');
      var shouldUpdateHash = true;

      this.title = $subsectionElement.find('.js-subsection-title').text();

      this.open = open;
      this.close = close;
      this.toggle = toggle;
      this.setIsOpen = setIsOpen;
      this.isOpen = isOpen;
      this.isClosed = isClosed;
      this.preventHashUpdate = preventHashUpdate;

      function open() {
        setIsOpen(true);
      }

      function close() {
        setIsOpen(false);
      }

      function toggle() {
        setIsOpen(isClosed());
      }

      function setIsOpen(isOpen) {
        $subsectionContent.toggleClass('js-hidden', !isOpen);
        $subsectionElement.toggleClass('subsection-is-open', isOpen);
        $titleLink.attr("aria-expanded", isOpen);

        if (shouldUpdateHash) {
          updateHash($subsectionElement);
        }
      }

      function isOpen() {
        return !isClosed();
      }

      function isClosed() {
        return $subsectionContent.hasClass('js-hidden');
      }

      function preventHashUpdate() {
        shouldUpdateHash = false;
      }
    }

    function updateHash($subsectionElement) {
      if (!GOVUK.support.history()) {
        return;
      }

      var subsectionView = new SubsectionView($subsectionElement);
      var hash = subsectionView.isOpen() && '#' + $subsectionElement.attr('id');
      setHash(hash)
    }

    // Sets the hash for the page. If a falsy value is provided, the hash is cleared.
    function setHash(hash) {
      var newLocation = hash || GOVUK.getCurrentLocation().pathname;
      history.replaceState({}, '', newLocation);
    }

    // A constructor for an object that represents a click event on a subsection which
    // handles the complexity of sending different tracking labels to Google Analytics
    // depending on which part of the subsection the user clicked.
    function SubsectionToggleClick(subsectionView, event) {
      var $target = $(event.target);

      this.track = trackClick;

      function trackClick() {
        track('pageElementInteraction', trackingAction(), {label: trackingLabel()});
      }

      function trackingAction() {
        return (subsectionView.isClosed() ? 'accordionClosed' : 'accordionOpened');
      }

      function trackingLabel() {
        if (clickedOnIcon()) {
          return subsectionView.title + ' - ' + iconType() + ' Click';
        } else if (clickedOnHeading()) {
          return subsectionView.title + ' - Heading Click';
        } else {
          return subsectionView.title + ' - Click Elsewhere';
        }
      }

      function clickedOnIcon() {
        return $target.hasClass('subsection-icon');
      }

      function clickedOnHeading() {
        return $target.hasClass('js-subsection-title-link');
      }

      function iconType() {
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
