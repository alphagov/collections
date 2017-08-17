describe('An accordion with descriptions module', function () {
  "use strict";

  var $element;
  var accordion;
  var html = '\
    <div class="subsections js-hidden" data-module="accordion-with-descriptions">\
      <div class="subsection-wrapper">\
        <div class="subsection js-subsection" id="topic-section-one">\
          <div class="subsection-header js-subsection-header">\
            <h2 class="subsection-title js-subsection-title">Topic Section One</h2>\
            <p class="subsection-description">Subsection description in here</p>\
          </div>\
          <div class="subsection-content js-subsection-content" id="subsection_content_0">\
            <ul class="subsection-list">\
              <li class="subsection-list-item">\
                <a href="">Subsection list item in here</a>\
              </li>\
            </ul>\
          </div>\
        </div>\
        <div class="subsection js-subsection" id="topic-section-two">\
          <div class="subsection-header js-subsection-header">\
            <h2 class="subsection-title js-subsection-title">Topic Section Two</h2>\
            <p class="subsection-description">Subsection description in here</p>\
          </div>\
          <div class="subsection-content js-subsection-content" id="subsection_content_1">\
            <ul class="subsection-list">\
              <li class="subsection-list-item">\
                <a href="">Subsection list item in here</a>\
              </li>\
            </ul>\
          </div>\
        </div>\
      </div>\
    </div>';
  var expectedAccordionSectionCount = 2;

  beforeEach(function () {
    accordion = new GOVUK.Modules.AccordionWithDescriptions();
    $element = $(html);
    accordion.start($element);
  });

  afterEach(function () {
    $(document).off();
    location.hash = "#";
  });

  it("has a class of js-accordion-with-descriptions to indicate the js has loaded", function () {
    expect($element).toHaveClass("js-accordion-with-descriptions");
  });

  it("is not hidden", function () {
    expect($element).not.toHaveClass("js-hidden");
  });

  it("has an open/close all button", function () {
    var $openCloseAllButton = $element.find('.js-subsection-controls button');

    expect($openCloseAllButton).toExist();
    expect($openCloseAllButton).toHaveText("Expand all");
    // It has an aria-expanded false attribute as all subsections are closed
    expect($openCloseAllButton).toHaveAttr("aria-expanded", "false");
    // It has an aria-controls attribute that includes all the subsection_content IDs
    expect($openCloseAllButton).toHaveAttr('aria-controls', 'subsection_content_0 subsection_content_1 ');
  });

  it("has no subsections which have an open state", function () {
    var openSubsections = $element.find('.subsection-is-open').length;
    expect(openSubsections).toEqual(0);
  });

  it("inserts a link into each subsection to show/hide content", function () {
    var $titleLink = $element.find('.subsection-header a');

    expect($titleLink).toHaveClass('subsection-title-link');
    expect($titleLink).toHaveAttr('aria-expanded', 'false');
    expect($titleLink[0]).toHaveAttr('aria-controls', 'subsection_content_0');
    expect($titleLink[1]).toHaveAttr('aria-controls', 'subsection_content_1');
  });

  it("ensures all subsection content is hidden", function () {
    $element.find('.subsection').each(function (index, $subsection) {
      expect($subsection).not.toHaveClass('subsection-is-open');
    });
  });

  it("adds an open/close icon to each subsection", function () {
    var $subsectionHeader = $element.find('.subsection-header');
    expect($subsectionHeader).toContainElement('.subsection-icon');
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

    it('adds a .subsection-is-open class to each subsection to hide the icon', function () {
      expect($element.find('.subsection-is-open').length).toEqual(2);
    });

    it('adds an aria-expanded attribute to each subsection link', function () {
      expect($element.find('.js-subsection-title-link[aria-expanded="true"]').length).toEqual(2);
    });

    it('changes the Open/Close all button text to "Close all"', function () {
      expect($element.find('.js-subsection-controls button')).toContainText("Close all");
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
    it("has a class of subsection-is-open", function () {
      var $subsectionLink = $element.find('.subsection-header a:first');
      var $subsection = $element.find('.subsection');
      $subsectionLink.click();
      expect($subsection).toHaveClass("subsection-is-open");
    });

    // When a section is open (testing: toggleState, setExpandedState)
    it("has a an aria-expanded attribute and the value is true", function () {
      var $subsectionLink = $element.find('.subsection-header a:first');
      $subsectionLink.click();
      expect($subsectionLink).toHaveAttr('aria-expanded', 'true');
    });

    it("triggers a google analytics custom event when clicking on the title", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $subsectionLink = $element.find('.subsection-header a:first');
      $subsectionLink.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionSectionCount.toString()
      });
    });

    it("triggers a google analytics custom event when clicking on the icon", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $subsectionIcon = $element.find('.subsection-icon');
      $subsectionIcon.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionSectionCount.toString()
      });
    });

    it("triggers a google analytics custom event when clicking in space in the header", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $subsectionHeader = $element.find('.subsection-header');
      $subsectionHeader.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionSectionCount.toString()
      });
    });
  });

  describe('Closing a section', function () {

    // When a section is closed (testing: toggleSection, closeSection)
    it("removes the subsection-is-open class", function () {
      var $subsectionLink = $element.find('.subsection-header a:first');
      var $subsection = $element.find('.subsection');
      $subsectionLink.click();
      expect($subsection).toHaveClass("subsection-is-open");
      $subsectionLink.click();
      expect($subsection).not.toHaveClass("subsection-is-open");
    });

    // When a section is closed (testing: toggleState, setExpandedState)
    it("has a an aria-expanded attribute and the value is false", function () {
      var $subsectionLink = $element.find('.subsection-header a:first');
      $subsectionLink.click();
      expect($subsectionLink).toHaveAttr('aria-expanded', 'true');
      $subsectionLink.click();
      expect($subsectionLink).toHaveAttr('aria-expanded', 'false');
    });

    it("triggers a google analytics custom event when clicking on the title", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $subsectionLink = $element.find('.subsection-header a:first');
      $subsectionLink.click();
      $subsectionLink.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionSectionCount.toString()
      });
    });

    it("triggers a google analytics custom event when clicking on the icon", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      var $subsectionIcon = $element.find('.subsection-icon');
      $subsectionIcon.click();
      $subsectionIcon.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionSectionCount.toString()
      });
    });

    it("triggers a google analytics custom event when clicking in space in the header", function () {
      GOVUK.analytics = {
        trackEvent: function () {
        }
      };
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      var $subsectionHeader = $element.find('.subsection-header');
      $subsectionHeader.click();
      $subsectionHeader.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: '1. Topic Section One',
        dimension28: expectedAccordionSectionCount.toString()
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
      var $subsection = $element.find('#topic-section-one');
      expect($subsection).toHaveClass('subsection-is-open');
    });

    it("leaves other sections closed", function () {
      var $subsection = $element.find('#topic-section-two');
      expect($subsection).not.toHaveClass('subsection-is-open');
    });
  });

  function clickOpenCloseAll() {
    $element.find('.js-subsection-controls button').click();
  }
});
