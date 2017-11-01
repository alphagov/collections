describe('An accordion module', function () {
  "use strict";

  var $element;
  var accordion;
  var html = '\
    <div class="app-c-accordion js-hidden" data-module="accordion">\
      <div class="app-c-accordion__section js-section" id="topic-section-one">\
        <div class="app-c-accordion__header js-toggle-panel">\
          <h2 class="app-c-accordion__title js-section-title">Topic Section One</h2>\
          <p class="app-c-accordion__description">Section description in here</p>\
        </div>\
        <div class="app-c-accordion__panel js-panel" id="section_panel_10_0">\
          <ul>\
            <li>\
              <a href="">list item in here</a>\
            </li>\
          </ul>\
        </div>\
      </div>\
      <div class="app-c-accordion__section js-section" id="topic-section-two">\
        <div class="app-c-accordion__header js-toggle-panel">\
          <h2 class="app-c-accordion__title js-section-title">Topic Section Two</h2>\
          <p class="app-c-accordion__description">Section description in here</p>\
        </div>\
        <div class="app-c-accordion__panel js-panel" id="section_panel_11_1">\
          <ul>\
            <li>\
              <a href="">list item in here</a>\
            </li>\
          </ul>\
        </div>\
      </div>\
    </div>';
  var expectedAccordionSectionCount = 2;
  var expectedAccordionContentCount = 1;

  beforeEach(function () {
    accordion = new GOVUK.Modules.Accordion();
    $element = $(html);
    accordion.start($element);
  });

  afterEach(function () {
    $(document).off();
    location.hash = "#";
  });

  it("has a class of app-c-accordion--active to indicate the js has loaded", function () {
    expect($element).toHaveClass("app-c-accordion--active");
  });

  it("is not hidden", function () {
    expect($element).not.toHaveClass("js-hidden");
  });

  it("has an open/close all button", function () {
    var $openCloseAllButton = $element.find('.js-section-controls-button');

    expect($openCloseAllButton).toExist();
    expect($openCloseAllButton).toHaveText("Open all");
    // It has an aria-expanded false attribute as all sections are closed
    expect($openCloseAllButton).toHaveAttr("aria-expanded", "false");
    // It has an aria-controls attribute that includes all the section_content IDs
    expect($openCloseAllButton).toHaveAttr('aria-controls', 'section_panel_10_0 section_panel_11_1 ');
  });

  it("has no sections which have an open state", function () {
    var openSections = $element.find('.section-is-open').length;
    expect(openSections).toEqual(0);
  });

  it("inserts a button into each section to show/hide content", function () {
    var $titleButton = $element.find('.app-c-accordion__header .app-c-accordion__button--title');

    expect($titleButton).toHaveClass('app-c-accordion__button--title');
    expect($titleButton).toHaveAttr('aria-expanded', 'false');
    expect($titleButton[0]).toHaveAttr('aria-controls', 'section_panel_10_0');
    expect($titleButton[1]).toHaveAttr('aria-controls', 'section_panel_11_1');
  });

  it("ensures all section content is hidden", function () {
    $element.find('.app-c-accordion__section').each(function (index, $section) {
      expect($section).not.toHaveClass('section-is-open');
    });
  });

  it("adds an open/close icon to each section", function () {
    var $sectionHeader = $element.find('.app-c-accordion__header');
    expect($sectionHeader).toContainElement('.app-c-accordion__icon');
  });

  describe('Clicking the "Expand all" button', function () {
    beforeEach(function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');
      clickOpenCloseAll();
    });

    it('adds a .section-is-open class to each section to hide the icon', function () {
      expect($element.find('.section-is-open').length).toEqual(2);
    });

    it('adds an aria-expanded attribute to each section link', function () {
      expect($element.find('.js-section-title-button[aria-expanded="true"]').length).toEqual(2);
    });

    it('changes the Open/Close all button text to "Close all"', function () {
      expect($element.find('.js-section-controls-button')).toContainText("Close all");
    });

    it("triggers a google analytics custom event", function () {
      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionAllOpened', {
        label: 'Open All',
        dimension28: expectedAccordionSectionCount.toString()
      });
    });
  });

  describe('Clicking the "Close all" button', function () {
    it("triggers a google analytics custom event", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      clickOpenCloseAll();
      clickOpenCloseAll();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionAllClosed', {
        label: 'Close All',
        dimension28: expectedAccordionSectionCount.toString()
      });
    });
  });

  describe('Opening a section', function () {

    // When a section is open (testing: toggleSection, openSection)
    it("has a class of section-is-open", function () {
      var $sectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title');
      var $section = $element.find('.app-c-accordion__section');
      $sectionLink.click();
      expect($section).toHaveClass("section-is-open");
    });

    // When a section is open (testing: toggleState, setExpandedState)
    it("has a an aria-expanded attribute and the value is true", function () {
      var $sectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title');
      $sectionLink.click();
      expect($sectionLink).toHaveAttr('aria-expanded', 'true');
    });

    it("triggers a google analytics custom event when clicking on the title", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $sectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title');
      $sectionLink.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      });
    });

    it("triggers a google analytics custom event when clicking on the icon", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $sectionIcon = $element.find('.app-c-accordion__icon');
      $sectionIcon.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      });
    });

    it("triggers a google analytics custom event when clicking in space in the header", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $sectionHeader = $element.find('.app-c-accordion__header');
      $sectionHeader.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      });
    });
  });

  describe('Closing a section', function () {

    // When a section is closed (testing: toggleSection, closeSection)
    it("removes the section-is-open class", function () {
      var $sectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title');
      var $section = $element.find('.app-c-accordion__section');
      $sectionLink.click();
      expect($section).toHaveClass("section-is-open");
      $sectionLink.click();
      expect($section).not.toHaveClass("section-is-open");
    });

    // When a section is closed (testing: toggleState, setExpandedState)
    it("has a an aria-expanded attribute and the value is false", function () {
      var $sectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title');
      $sectionLink.click();
      expect($sectionLink).toHaveAttr('aria-expanded', 'true');
      $sectionLink.click();
      expect($sectionLink).toHaveAttr('aria-expanded', 'false');
    });

    it("triggers a google analytics custom event when clicking on the title", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $sectionLink = $element.find('.app-c-accordion__header .app-c-accordion__button--title');
      $sectionLink.click();
      $sectionLink.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      });
    });

    it("triggers a google analytics custom event when clicking on the icon", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $sectionIcon = $element.find('.app-c-accordion__icon');
      $sectionIcon.click();
      $sectionIcon.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      });
    });

    it("triggers a google analytics custom event when clicking in space in the header", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      var $sectionHeader = $element.find('.app-c-accordion__header');
      $sectionHeader.click();
      $sectionHeader.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionContentCount.toString()
      });
    });
  });

  describe('When linking to a topic section', function () {
    beforeEach(function () {
      spyOn(GOVUK, 'getCurrentLocation').and.returnValue({
        hash: '#topic-section-one'
      });

      // Restart accordion after setting up mock location provider
      accordion.start($element);
    });

    it("opens the linked to topic section", function () {
      var $section = $element.find('#topic-section-one');
      expect($section).toHaveClass('section-is-open');
    });

    it("leaves other sections closed", function () {
      var $section = $element.find('#topic-section-two');
      expect($section).not.toHaveClass('section-is-open');
    });
  });

  function clickOpenCloseAll() {
    $element.find('.js-section-controls-button').click();
  }
});
