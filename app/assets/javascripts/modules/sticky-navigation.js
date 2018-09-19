/*
  This module will cause the target element to:
  - display in it's normal visible position until the element is almost scrolled out of view
  - stick near the top of the window after this point
  - stop displaying sticky behaviour before reaching the end of the container
  - at this point it will anchor to the bottom of it's container

  Use 'data-module="sticky-navigation"' to the element you wish to be sticky and add
  `data-module="sticky-navigation-container"` to the containing element.
  The element will now be sticky only within that container.
*/

window.GOVUK.Modules = window.GOVUK.Modules || {};

(function(Modules) {
  "use strict";

  Modules.StickyNavigation = function () {
    var calculateStickyStartPoint = function () {
      var stickyElement = $('[data-module=sticky-navigation]')
      return stickyElement.offset().top;
    }

    var calculateStickyStopPoint = function() {
      var stickyElementContainer = $('[data-module=sticky-navigation-container]');
      var stickyElementHeight = $('[data-module=sticky-navigation]').height();

      var stickyContainerEnd = (stickyElementContainer.height() + stickyElementContainer.offset().top) - stickyElementHeight;

      return stickyContainerEnd
    }

    var stickyStart = calculateStickyStartPoint();
    var stickyStop = calculateStickyStopPoint();

    this.start = function (stickyNavigation) {
      $(window).resize(function() {
        stickyStop = calculateStickyStopPoint();
      });

      // A toggle click indicates some content on the page is expanding/collapsing.
      // This will change the height of the topic page, so we need to recaculate
      // where the end of the sidebar should be
      $('[data-module=toggle]').on('click', function() {
        stickyStop = calculateStickyStopPoint();
        $(document).trigger("scroll");
      })

      $(document).scroll(function() {
        var scroll = $(document).scrollTop();

        if (scroll >= stickyStart && scroll < stickyStop)  {
          stickyNavigation.addClass("sticky-navigation--enabled");
          stickyNavigation.removeClass("sticky-navigation--anchored");
        }
        else if (scroll > stickyStop) {
          stickyNavigation.removeClass("sticky-navigation--enabled");
          stickyNavigation.addClass("sticky-navigation--anchored");
        }
        else {
          stickyNavigation.removeClass("sticky-navigation--enabled");
          stickyNavigation.removeClass("sticky-navigation--anchored");
        }
      });
    };
  };
})(window.GOVUK.Modules);
