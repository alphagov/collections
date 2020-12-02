// Most of this is taken from the service manual

window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  Modules.CollectionsAccordion = function () {
    var bulkActions = {
      openAll: {
        buttonText: 'Open all',
        eventLabel: 'Open All'
      },
      closeAll: {
        buttonText: 'Close all',
        eventLabel: 'Close All'
      }
    }

    this.start = function ($element) {
      $(window).unload(storeScrollPosition)

      // Indicate that js has worked
      $element.addClass('app-c-accordion--active')

      // Prevent FOUC, remove class hiding content
      $element.removeClass('js-hidden')

      var $subsections = $element.find('.js-section')
      var $subsectionHeaders = $element.find('.js-toggle-panel')
      var totalSubsections = $element.find('.js-panel').length

      var $openOrCloseAllButton

      var accordionTracker = new AccordionTracker(totalSubsections)

      addButtonstoSections()
      addOpenCloseAllButton()
      addIconsToSubsections()
      addAriaControlsAttrForOpenCloseAllButton()

      closeAllSections()
      openLinkedSection()

      bindToggleForSubsections(accordionTracker)
      bindToggleOpenCloseAllButton(accordionTracker)

      // When navigating back in browser history to the accordion, the browser will try to be "clever" and return
      // the user to their previous scroll position. However, since we collapse all but the currently-anchored
      // subsection, the content length changes and the user is returned to the wrong position (often the footer).
      // In order to correct this behaviour, as the user leaves the page, we anticipate the correct height we wish the
      // user to return to by forcibly scrolling them to that height, which becomes the height the browser will return
      // them to.
      // If we can't find an element to return them to, then reset the scroll to the top of the page. This handles
      // the case where the user has expanded all sections, so they are not returned to a particular section, but
      // still could have scrolled a long way down the page.
      function storeScrollPosition () {
        closeAllSections()
        var $subsection = getSubsectionForAnchor()

        document.body.scrollTop = $subsection && $subsection.length
          ? $subsection.offset().top
          : 0
      }

      function addOpenCloseAllButton () {
        $element.prepend('<div class="app-c-accordion__controls"><button aria-expanded="false" class="govuk-link app-c-accordion__button app-c-accordion__button--controls js-section-controls-button">' + bulkActions.openAll.buttonText + '</button></div>')
      }

      function addIconsToSubsections () {
        $subsectionHeaders.append('<span class="app-c-accordion__icon"></span>')
      }

      function addAriaControlsAttrForOpenCloseAllButton () {
        var ariaControlsValue = ''
        var $subsectionPanels = $element.find('.js-panel')
        for (var i = 0; i < totalSubsections; i++) {
          ariaControlsValue += $subsectionPanels[i].id + ' '
        }

        $openOrCloseAllButton = $element.find('.js-section-controls-button')
        $openOrCloseAllButton.attr('aria-controls', ariaControlsValue)
      }

      function closeAllSections () {
        setAllSectionsOpenState(false)
      }

      function setAllSectionsOpenState (isOpen) {
        $.each($subsections, function () {
          var subsectionView = new SubsectionView($(this))
          subsectionView.preventHashUpdate()
          subsectionView.setIsOpen(isOpen)
        })
      }

      function openLinkedSection () {
        var $subsection = getSubsectionForAnchor()

        if ($subsection && $subsection.length) {
          var subsectionView = new SubsectionView($subsection)
          subsectionView.open()
        }
      }

      function getSubsectionForAnchor () {
        var anchor = getActiveAnchor()

        return anchor.length
          ? $element.find('#' + escapeSelector(anchor.substr(1)))
          : null
      }

      function getActiveAnchor () {
        return GOVUK.getCurrentLocation().hash
      }

      function addButtonstoSections () {
        $.each($subsections, function () {
          var $section = $(this)
          var $title = $section.find('.js-section-title')
          var contentId = $section.find('.js-panel').first().attr('id')

          $title.wrapInner(
            '<button ' +
            'class="govuk-link app-c-accordion__button app-c-accordion__button--title js-section-title-button" ' +
            'aria-expanded="false" aria-controls="' + contentId + '">' +
            '</button>')
        })
      }

      function bindToggleForSubsections (accordionTracker) {
        $element.find('.js-toggle-panel').click(function (event) {
          preventLinkFollowingForCurrentTab(event)

          var subsectionView = new SubsectionView($(this).closest('.js-section'))
          subsectionView.toggle()

          var toggleClick = new SubsectionToggleClick(subsectionView, $subsections, accordionTracker)
          toggleClick.track()

          setOpenCloseAllText()
        })
      }

      function preventLinkFollowingForCurrentTab (event) {
        // If the user is holding the ⌘ or Ctrl key, they're trying
        // to open the link in a new window, so let the click happen
        if (event.metaKey || event.ctrlKey) {
          return
        }

        event.preventDefault()
      }

      function bindToggleOpenCloseAllButton (accordionTracker) {
        $openOrCloseAllButton = $element.find('.js-section-controls-button')
        $openOrCloseAllButton.on('click', function () {
          var shouldOpenAll

          if ($openOrCloseAllButton.text() === bulkActions.openAll.buttonText) {
            $openOrCloseAllButton.text(bulkActions.closeAll.buttonText)
            shouldOpenAll = true

            accordionTracker.track('pageElementInteraction', 'accordionAllOpened', {
              label: bulkActions.openAll.eventLabel
            })
          } else {
            $openOrCloseAllButton.text(bulkActions.openAll.buttonText)
            shouldOpenAll = false

            accordionTracker.track('pageElementInteraction', 'accordionAllClosed', {
              label: bulkActions.closeAll.eventLabel
            })
          }

          setAllSectionsOpenState(shouldOpenAll)
          $openOrCloseAllButton.attr('aria-expanded', shouldOpenAll)
          setOpenCloseAllText()
          setHash(null)

          return false
        })
      }

      function setOpenCloseAllText () {
        var openSubsections = $element.find('.section-is-open').length
        // Find out if the number of is-opens == total number of sections
        if (openSubsections === totalSubsections) {
          $openOrCloseAllButton.text(bulkActions.closeAll.buttonText)
        } else {
          $openOrCloseAllButton.text(bulkActions.openAll.buttonText)
        }
      }

      // Ideally we'd use jQuery.escapeSelector, but this is only available from v3
      // See https://github.com/jquery/jquery/blob/2d4f53416e5f74fa98e0c1d66b6f3c285a12f0ce/src/selector-native.js#L46
      function escapeSelector (s) {
        var cssMatcher = /([\x00-\x1f\x7f]|^-?\d)|^-$|[^\x80-\uFFFF\w-]/g // eslint-disable-line no-control-regex
        return s.replace(cssMatcher, '\\$&')
      }
    }

    function SubsectionView ($subsectionElement) {
      var $titleLink = $subsectionElement.find('.js-section-title-button')
      var $subsectionContent = $subsectionElement.find('.js-panel')
      var shouldUpdateHash = true

      this.title = $subsectionElement.find('.js-section-title').text()
      this.href = $titleLink.attr('href')
      this.element = $subsectionElement

      this.open = open
      this.close = close
      this.toggle = toggle
      this.setIsOpen = setIsOpen
      this.isOpen = isOpen
      this.isClosed = isClosed
      this.preventHashUpdate = preventHashUpdate
      this.numberOfContentItems = numberOfContentItems

      function open () {
        setIsOpen(true)
      }

      function close () {
        setIsOpen(false)
      }

      function toggle () {
        setIsOpen(isClosed())
      }

      function setIsOpen (isOpen) {
        $subsectionElement.toggleClass('section-is-open', isOpen)
        $subsectionContent.toggleClass('js-hidden', !isOpen)
        $titleLink.attr('aria-expanded', isOpen)

        if (shouldUpdateHash) {
          updateHash($subsectionElement)
        }
      }

      function isOpen () {
        return $subsectionElement.hasClass('section-is-open')
      }

      function isClosed () {
        return !isOpen()
      }

      function preventHashUpdate () {
        shouldUpdateHash = false
      }

      function numberOfContentItems () {
        return $subsectionContent.find('li').length
      }
    }

    function updateHash ($subsectionElement) {
      var subsectionView = new SubsectionView($subsectionElement)
      var hash = subsectionView.isOpen() && '#' + $subsectionElement.attr('id')
      setHash(hash)
    }

    // Sets the hash for the page. If a falsy value is provided, the hash is cleared.
    function setHash (hash) {
      if (!GOVUK.support.history()) {
        return
      }

      var newLocation = hash || GOVUK.getCurrentLocation().pathname
      history.replaceState({}, '', newLocation)
    }

    function SubsectionToggleClick (subsectionView, $subsections, accordionTracker) {
      this.track = trackClick

      function trackClick () {
        var trackingOptions = { label: trackingLabel(), dimension28: subsectionView.numberOfContentItems().toString() }
        accordionTracker.track('pageElementInteraction', trackingAction(), trackingOptions)

        if (!subsectionView.isClosed()) {
          accordionTracker.track(
            'navAccordionLinkClicked',
            String(subsectionIndex()),
            {
              label: subsectionView.href,
              dimension28: String(subsectionView.numberOfContentItems()),
              dimension29: subsectionView.title
            }
          )
        }
      }

      function trackingLabel () {
        return subsectionIndex() + '. ' + subsectionView.title
      }

      function subsectionIndex () {
        return $subsections.index(subsectionView.element) + 1
      }

      function trackingAction () {
        return (subsectionView.isClosed() ? 'accordionClosed' : 'accordionOpened')
      }
    }

    // A helper that sends a custom event request to Google Analytics if
    // the GOVUK module is setup
    function AccordionTracker (totalSubsections) {
      this.track = function (category, action, options) {
        if (GOVUK.analytics && GOVUK.analytics.trackEvent) {
          options = options || {}
          options.dimension28 = options.dimension28 || totalSubsections.toString()
          GOVUK.analytics.trackEvent(category, action, options)
        }
      }
    }
  }
})(window.GOVUK.Modules)
