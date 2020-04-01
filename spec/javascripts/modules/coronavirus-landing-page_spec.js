describe('Coronavirus landing page', function () {
  "use strict"

  var coronavirusLandingPage;
  var html = '\
  <div id="element" data-module="coronavirus-landing-page">\
  </div>'
  var $element

  beforeEach(function () {
    coronavirusLandingPage = new GOVUK.Modules.CoronavirusLandingPage();
    $element = $(html);
    GOVUK.approveAllCookieTypes();
  })

  it("sets global_bar_seen to automatically hide if on /coronavirus", function () {
    GOVUK.cookie("global_bar_seen", JSON.stringify({"count": 0, "version": 1}));
    spyOn(coronavirusLandingPage, "checkOnLandingPage").and.returnValue(true)
    coronavirusLandingPage.start($element);

    expect(parseCookie(GOVUK.cookie("global_bar_seen")).count).toBe(999)
  })

  it("only sets global_bar_seen if on /coronavirus", function () {
    GOVUK.cookie("global_bar_seen", JSON.stringify({"count": 0, "version": 1}));
    spyOn(coronavirusLandingPage, "checkOnLandingPage").and.returnValue(false)
    coronavirusLandingPage.start($element);

    expect(parseCookie(GOVUK.cookie("global_bar_seen")).count).not.toBe(999)
    expect(parseCookie(GOVUK.cookie("global_bar_seen")).version).toBe(1)
  })
});

function parseCookie(cookie) {
  var parsedCookie = JSON.parse(cookie)

  // Tests seem to run differently on CI, and require an extra parse
  if (typeof parsedCookie !== "object") {
    parsedCookie = JSON.parse(parsedCookie)
  }

  return parsedCookie
}
