describe('An accordion with descriptions module', function () {
  "use strict";

  var $element;
  var accordion;
  var html = '\
    <div class="subsections js-hidden" data-module="accordion-with-descriptions">\
      <div class="subsection-wrapper">\
        <div class="subsection js-subsection">\
          <div class="subsection-header">\
            <h2 class="subsection-title" id="topic-section-one">Topic Section One</h2>\
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
        <div class="subsection js-subsection">\
          <div class="subsection-header">\
            <h2 class="subsection-title" id="topic-section-two">Topic Section Two</h2>\
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

  beforeEach(function () {
    accordion = new GOVUK.Modules.AccordionWithDescriptions();
    $element = $(html);
  });

  afterEach(function() {
    $(document).off();
  });

  it("has a class of js-accordion-with-descriptions to indicate the js has loaded", function () {
    accordion.start($element);

    expect($element).toHaveClass("js-accordion-with-descriptions");
  });

  it("is not hidden", function () {
    accordion.start($element);

    expect($element).not.toHaveClass("js-hidden");
  });

  it("has an open/close all button", function () {
    accordion.start($element);

    var $openCloseAllButton = $element.find('.js-subsection-controls button');

    expect($openCloseAllButton).toExist();
    expect($openCloseAllButton).toHaveText("Expand all");
    // It has an aria-expanded false attribute as all subsections are closed
    expect($openCloseAllButton).toHaveAttr("aria-expanded", "false");
    // It has an aria-controls attribute that includes all the subsection_content IDs
    expect($openCloseAllButton).toHaveAttr('aria-controls','subsection_content_0 subsection_content_1 ');
  });

  it("has no subsections which have an open state", function () {
    accordion.start($element);

    var openSubsections = $element.find('.subsection-is-open').length;

    expect(openSubsections).toEqual(0);
  });

  it("inserts a button into each subsection to show/hide content", function () {
    accordion.start($element);

    var $subsectionButton = $element.find('.subsection-title button');

    expect($subsectionButton).toHaveClass('subsection-button');
    // It has an aria-expanded false attribute as it is closed
    expect($subsectionButton).toHaveAttr('aria-expanded','false');
    // It has an aria-controls attribute to store the subsection_content ID
    expect($subsectionButton).toHaveAttr('aria-controls','subsection_content_0');
  });

  it("ensures all subsection content is hidden", function () {
    accordion.start($element);

    $.each($element.find('.subsection-content'), function(index, content) {
      expect(content).toHaveClass('js-hidden');
    });
  });

  it("adds an open/close icon to each subsection", function () {
    accordion.start($element);

    var $subsectionHeader = $element.find('.subsection-header');

    expect($subsectionHeader).toContainElement('.subsection-icon');
  });

  describe('Clicking the "Expand all" button', function () {

    it('adds a .subsection-is-open class to each subsection to hide the icon', function () {
      accordion.start($element);
      clickOpenCloseAll();

      expect($element.find('.subsection-is-open').length).toEqual(2);
    });

    it('adds an aria-expanded attribute to each subsection button', function () {
      accordion.start($element);
      clickOpenCloseAll();

      expect($element.find('.js-subsection-button[aria-expanded="true"]').length).toEqual(2);
    });

    it('removes the .js-hidden class from each subsection content to hide the list of links', function () {
      accordion.start($element);
      clickOpenCloseAll();

      expect($element.find('.js-subsection-content.js-hidden').length).toEqual(0);
    });

    it('changes the Open/Close all button text to "Close all"', function () {
      accordion.start($element);
      clickOpenCloseAll();

      expect($element.find('.js-subsection-controls button')).toContainText("Close all");
    });

    it("triggers a google analytics custom event", function () {
      GOVUK.analytics = {trackEvent: function() {}};
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      clickOpenCloseAll();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionAllOpened', {
        label: 'Open All'
      });
    });

  });

  describe('Clicking the "Close all" button', function () {
    it("triggers a google analytics custom event", function () {
      GOVUK.analytics = {trackEvent: function() {}};
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      clickOpenCloseAll();
      clickOpenCloseAll();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionAllClosed', {
        label: 'Close All'
      });
    });
  });

  describe('Opening a section', function () {

    // When a section is open (testing: toggleSection, openSection)
    it("does not have a class of js-hidden", function () {
      accordion.start($element);

      var $subsectionButton = $element.find('.subsection-title button:first');
      var $subsectionContent = $element.find('.subsection-content:first');
      $subsectionButton.click();
      expect($subsectionContent).not.toHaveClass("js-hidden");
    });

    // When a section is open (testing: toggleState, setExpandedState)
    it("has a an aria-expanded attribute and the value is true", function () {
      accordion.start($element);

      var $subsectionButton = $element.find('.subsection-title button:first');
      $subsectionButton.click();
      expect($subsectionButton).toHaveAttr('aria-expanded','true');
    });

    it("triggers a google analytics custom event when clicking on the title", function () {
      GOVUK.analytics = {trackEvent: function() {}};
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      var $subsectionButton = $element.find('.subsection-title button:first');
      $subsectionButton.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: 'Topic Section One - Heading Click'
      });
    });

    it("triggers a google analytics custom event when clicking on the icon", function () {
      GOVUK.analytics = {trackEvent: function() {}};
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      var $subsectionIcon = $element.find('.subsection-icon');
      $subsectionIcon.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: 'Topic Section One - Plus Click'
      });
    });

    it("triggers a google analytics custom event when clicking in space in the header", function () {
      GOVUK.analytics = {trackEvent: function() {}};
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      var $subsectionHeader = $element.find('.subsection-header');
      $subsectionHeader.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionOpened', {
        label: 'Topic Section One - Click Elsewhere'
      });
    });
  });

  describe('Closing a section', function () {

    // When a section is closed (testing: toggleSection, closeSection)
    it("has a class of js-hidden", function () {
      accordion.start($element);

      var $subsectionButton = $element.find('.subsection-title button:first');
      var $subsectionContent = $element.find('.subsection-content:first');
      $subsectionButton.click();
      expect($subsectionContent).not.toHaveClass("js-hidden");
      $subsectionButton.click();
      expect($subsectionContent).toHaveClass("js-hidden");
    });

    // When a section is closed (testing: toggleState, setExpandedState)
    it("has a an aria-expanded attribute and the value is false", function () {
      accordion.start($element);

      var $subsectionButton = $element.find('.subsection-title button:first');
      var $subsectionContent = $element.find('.subsection-content');
      $subsectionButton.click();
      expect($subsectionButton).toHaveAttr('aria-expanded','true');
      $subsectionButton.click();
      expect($subsectionButton).toHaveAttr('aria-expanded','false');
    });

    it("triggers a google analytics custom event when clicking on the title", function () {
      GOVUK.analytics = {trackEvent: function() {}};
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      var $subsectionButton = $element.find('.subsection-title button:first');
      $subsectionButton.click();
      $subsectionButton.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: 'Topic Section One - Heading Click'
      });
    });

    it("triggers a google analytics custom event when clicking on the icon", function () {
      GOVUK.analytics = {trackEvent: function() {}};
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      var $subsectionIcon = $element.find('.subsection-icon');
      $subsectionIcon.click();
      $subsectionIcon.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: 'Topic Section One - Minus Click'
      });
    });

    it("triggers a google analytics custom event when clicking in space in the header", function () {
      GOVUK.analytics = {trackEvent: function() {}};
      spyOn(GOVUK.analytics, 'trackEvent');

      accordion.start($element);
      var $subsectionHeader = $element.find('.subsection-header');
      $subsectionHeader.click();
      $subsectionHeader.click();

      expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith('pageElementInteraction', 'accordionClosed', {
        label: 'Topic Section One - Click Elsewhere'
      });
    });
  });

  describe('When linking to a topic section', function () {
    beforeEach(function() {
      spyOn(GOVUK, 'getCurrentLocation').and.returnValue({
        hash: '#topic-section-one'
      });
    });

    it("opens the linked to topic section", function () {
      accordion.start($element);

      var $subsectionContent = $element.find('#topic-section-one')
        .parents('.subsection').find('.subsection-content');

      expect($subsectionContent).not.toHaveClass('js-hidden');
    });

    it("leaves other sections closed", function () {
      accordion.start($element);

      var $subsectionContent = $element.find('#topic-section-two')
        .parents('.subsection').find('.subsection-content');

      expect($subsectionContent).toHaveClass('js-hidden');
    });
  });

  function clickOpenCloseAll() {
    $element.find('.js-subsection-controls button').click();
  }
});
