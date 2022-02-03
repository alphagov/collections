describe('browse-columns.js', function () {
  var el
  var title
  var fixture =
    '<div class="gem-c-breadcrumbs"></div>' +
    '<div id="browse">' +
      '<div id="subsection" class="browse__subsection-pane"></div>' +
      '<div id="section" class="browse__section-pane"></div>' +
      '<div id="root" class="pane root-pane">' +
        '<h2 class="govuk-visually-hidden" tabindex="-1">All categories</h2>' +
        "<ul class='browse__list'>" +
          '<li>' +
            '<a data-track-category="firstLevelBrowseLinkClicked" data-track-action="1" data-track-label="/browse/benefits" data-track-options="{&quot;dimension28&quot;:&quot;1&quot;,&quot;dimension29&quot;:&quot;Benefits&quot;,&quot;dimension32&quot;:&quot;Browse Index&quot;}" class="govuk-link" href="/browse/benefits">Benefits</a>' +
          '</li>' +
          '<li>' +
            '<a data-track-category="firstLevelBrowseLinkClicked" data-track-action="2" data-track-label="/browse/births-deaths-marriages" data-track-options="{&quot;dimension28&quot;:&quot;16&quot;,&quot;dimension29&quot;:&quot;Births, deaths, marriages and care&quot;,&quot;dimension32&quot;:&quot;Browse Index&quot;}" class="govuk-link" href="/browse/births-deaths-marriages">Benefits</a>' +
          '</li>' +
        '</ul>' +
      '</div>' +
    '</div>'

  var metatags = ['govuk:content-id', 'govuk:navigation-page-type']

  var sectionBreadcrumbs = "<script type='application/ld+json'>  {  '@context': 'http://schema.org',  '@type': 'BreadcrumbList',  'itemListElement': [  { '@type': 'ListItem', 'position': 1, 'item': { 'name': 'Home', '@id': 'https://www.gov.uk/' }  }  ]}</script><div class='gem-c-breadcrumbs govuk-breadcrumbs govuk-breadcrumbs--collapse-on-mobile' data-module='gem-track-click'>  <ol class='govuk-breadcrumbs__list'> <li class='govuk-breadcrumbs__list-item'>   <a data-track-category='homeLinkClicked' data-track-action='homeBreadcrumb' data-track-label=' data-track-options='{}' class='govuk-breadcrumbs__link' href='/'>Home</a> </li>  </ol></div>"

  var subSectionBreadcrumbs = "<script type='application/ld+json'>  {  '@context': 'http://schema.org',  '@type': 'BreadcrumbList',  'itemListElement': [    {      '@type': 'ListItem',      'position': 1,      'item': {        'name': 'Home',        '@id': 'https://www.gov.uk/'      }    },    {      '@type': 'ListItem',      'position': 2,      'item': {        'name': 'Benefits',        '@id': 'https://www.gov.uk/browse/benefits'      }    }  ]}</script><div class='gem-c-breadcrumbs govuk-breadcrumbs govuk-breadcrumbs--collapse-on-mobile' data-module='gem-track-click'>  <ol class='govuk-breadcrumbs__list'>        <li class='govuk-breadcrumbs__list-item'>          <a data-track-category='homeLinkClicked' data-track-action='homeBreadcrumb' data-track-label=' data-track-options='{}' class='govuk-breadcrumbs__link' href='/'>Home</a>        </li>        <li class='govuk-breadcrumbs__list-item'>          <a data-track-category='breadcrumbClicked' data-track-action='2' data-track-label='/browse/benefits' data-track-options='{&quot;dimension28&quot;:&quot;2&quot;,&quot;dimension29&quot;:&quot;Benefits&quot;}' class='govuk-breadcrumbs__link' href='/browse/benefits'>Benefits</a>        </li>  </ol></div><!-- END /Users/andysellick/.rbenv/versions/2.7.2/lib/ruby/gems/2.7.0/gems/govuk_publishing_components-24.20.0/app/views/govuk_publishing_components/components/_breadcrumbs.html.erb --><!-- END app/views/application/_breadcrumbs.html.erb -->"

  var sectionHtml =
    "<div class='pane-inner curated'>" +
      "<h2 tabindex='-1' class='js-heading'>Browse: Benefits</h2>" +
        "<ul class='browse__list'>" +
          '<li>' +
            "<a data-track-category='secondLevelBrowseLinkClicked' data-track-action='1' data-track-label='/browse/benefits/manage-your-benefit' data-track-options='{&quot;dimension1&quot;:&quot;benefits&quot;,&quot;dimension28&quot;:&quot;2&quot;,&quot;dimension29&quot;:&quot;Manage an existing benefit, payment or claim&quot;,&quot;dimension32&quot;:&quot;First Level Browse&quot;}' class='govuk-link' href='/browse/benefits/manage-your-benefit'>" +
              "<h3 class='pane-inner__title'>Manage an existing benefit, payment or claim</h3>" +
              "<p class='pane-inner__description'>Sign in to your account, report changes, find out about overpayments, or appeal a decision</p>" +
            '</a>' +
          '</li>' +
          '<li>' +
            "<a data-track-category='secondLevelBrowseLinkClicked' data-track-action='2' data-track-label='/browse/benefits/looking-for-work' data-track-options='{&quot;dimension1&quot;:&quot;benefits&quot;,&quot;dimension28&quot;:&quot;2&quot;,&quot;dimension29&quot;:&quot;Benefits and financial support if you&#39;re looking for work&quot;,&quot;dimension32&quot;:&quot;First Level Browse&quot;}' class='govuk-link' href='/browse/benefits/looking-for-work'>" +
              "<h3 class='pane-inner__title'>Benefits and financial support if you&#39;re looking for work</h3>" +
              "<p class='pane-inner__description'>Help if you&#39;re looking for a new job, are out of work or affected by redundancy</p>" +
            '</a>' +
          '</li>' +
        '</ul>' +
      '</div>'

  var subSectionHtml =
    "<div class='pane-inner curated-list'>" +
      "<h2 tabindex='-1' class='js-heading'>Browse: Manage an existing benefit, payment or claim</h2>" +
      "<h3 class='list-header'>Manage your benefit, payment or claim online</h3>" +
      "<ul class='browse__list'>" +
        '<li>' +
          "<a data-track-category='thirdLevelBrowseLinkClicked' data-track-action='1.1' data-track-label='/sign-in-universal-credit' data-track-options='{&quot;dimension1&quot;:&quot;benefits&quot;,&quot;dimension28&quot;:&quot;2&quot;,&quot;dimension29&quot;:&quot;Sign in to your Universal Credit account&quot;,&quot;dimension32&quot;:&quot;Second Level Browse&quot;}' class='govuk-link' href='/sign-in-universal-credit'>Sign in to your Universal Credit account</a>" +
        '</li>' +
        '<li>' +
          "<a data-track-category='thirdLevelBrowseLinkClicked' data-track-action='1.2' data-track-label='/sign-in-childcare-account' data-track-options='{&quot;dimension1&quot;:&quot;benefits&quot;,&quot;dimension28&quot;:&quot;2&quot;,&quot;dimension29&quot;:&quot;Sign in to your childcare account&quot;,&quot;dimension32&quot;:&quot;Second Level Browse&quot;}' class='govuk-link' href='/sign-in-childcare-account'>Sign in to your childcare account</a>" +
        '</li>' +
      '</ul>' +
      "<ul class='browse__list'>" +
        '<li>' +
          "<a data-track-category='thirdLevelBrowseLinkClicked' data-track-action='2.1' data-track-label='/how-to-have-your-benefits-paid' data-track-options='{&quot;dimension1&quot;:&quot;benefits&quot;,&quot;dimension26&quot;:6,&quot;dimension27&quot;:42,&quot;dimension28&quot;:&quot;11&quot;,&quot;dimension29&quot;:&quot;How and when your benefits are paid&quot;,&quot;location&quot;:&quot;/how-to-have-your-benefits-paid&quot;,&quot;title&quot;:&quot;How and when your benefits are paid&quot;,&quot;dimension32&quot;:&quot;Second Level Browse&quot;}' class='browse__normal-link govuk-link' href='/how-to-have-your-benefits-paid'>How and when your benefits are paid</a>" +
        '</li>' +
      '</ul>' +
    '</div>'

  var sectionResponse = '{"content_id": "1", "navigation_page_type": "First Level Browse", "breadcrumbs": "' + sectionBreadcrumbs + '", "html": "' + sectionHtml + '"}'
  var sectionCache = {
    sectionbenefits: {
      content_id: '1',
      navigation_page_type: 'First Level Browse',
      breadcrumbs: sectionBreadcrumbs,
      html: sectionHtml
    }
  }

  var subSectionResponse = '{"content_id": "2", "navigation_page_type": "Second Level Browse", "breadcrumbs": "' + subSectionBreadcrumbs + '", "html": "' + subSectionHtml + '"}'
  var subSectionCache = {
    sectionbenefits: {
      content_id: '1',
      navigation_page_type: 'First Level Browse',
      breadcrumbs: sectionBreadcrumbs,
      html: sectionHtml
    },
    'sectionbenefits/manage-your-benefit': {
      content_id: '2',
      navigation_page_type: 'Second Level Browse',
      breadcrumbs: subSectionBreadcrumbs,
      html: subSectionHtml
    }
  }

  beforeEach(function () {
    GOVUK.analytics = GOVUK.analytics || {}
    title = document.title
    // The window size needs to be wider than 500 pixels, otherwise the
    // ajax-browsing will be disabled.
    setWindowSize(1024)
    jasmine.Ajax.install()
    jasmine.clock().install()
    el = document.createElement('div')
    el.setAttribute('id', 'browseTest')
    el.innerHTML = fixture
    document.body.appendChild(el)
    el.addEventListener('click', function (e) { e.preventDefault() })

    for (var i = 0; i < metatags.length; i++) {
      var meta = document.createElement('meta')
      meta.name = metatags[i]
      document.getElementsByTagName('head')[0].appendChild(meta)
    }
    spyOn(history, 'pushState').and.returnValue('')
  })

  function resetAnalyticsCalls () {
    if (GOVUK.analytics.trackEvent && GOVUK.analytics.trackEvent.calls) {
      GOVUK.analytics.trackEvent.calls.reset()
    }
  }

  afterEach(function () {
    resetAnalyticsCalls()
    jasmine.Ajax.uninstall()
    jasmine.clock().uninstall()
    document.body.removeChild(el)
    document.title = title
  })

  it('should cache objects', function () {
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()

    expect(bc.sectionCache('object-name')).toBe(undefined)

    bc.sectionCache('object-name', 'cache-thing')
    expect(bc.sectionCache('object-name')).toBe('cache-thing')
  })

  it('should set page title with the GOV.UK suffix', function () {
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()
    bc.setTitle('new-title')

    expect($('title').text()).toBe('new-title - GOV.UK')
  })

  it('should get section data and cache it', function () {
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    spyOn(bc, 'sectionCache').and.callThrough()
    spyOn(bc, 'handleResponse').and.callThrough()
    spyOn(bc, 'parsePathname').and.returnValue({
      path: '/browse/benefits',
      slug: 'benefits',
      section: 'benefits'
    })
    bc.init()
    el.querySelector('[href="/browse/benefits"]').click()
    expect(jasmine.Ajax.requests.mostRecent().url).toBe('/browse/benefits.json')

    jasmine.Ajax.requests.mostRecent().respondWith({
      status: 200,
      response: sectionResponse
    })

    expect(bc.sectionCache).toHaveBeenCalledWith('benefits', JSON.parse(sectionResponse))
    expect(bc.handleResponse).toHaveBeenCalled()
    expect(bc._cache).toEqual(sectionCache)
  })

  it('should use the section data from the cache if it has it', function () {
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()
    el.querySelector('[href="/browse/benefits"]').click()

    jasmine.Ajax.requests.mostRecent().respondWith({
      status: 200,
      response: sectionResponse
    })

    expect(bc._cache).toEqual(sectionCache)
    el.querySelector('[href="/browse/benefits"]').click()
    expect(jasmine.Ajax.requests.count()).toEqual(1)
  })

  it('should get subsection data and cache it', function () {
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()

    el.querySelector('[href="/browse/benefits"]').click()
    jasmine.Ajax.requests.mostRecent().respondWith({
      status: 200,
      response: sectionResponse
    })

    el.querySelector('[href="/browse/benefits/manage-your-benefit"]').click()
    jasmine.Ajax.requests.mostRecent().respondWith({
      status: 200,
      response: subSectionResponse
    })

    expect(bc._cache).toEqual(subSectionCache)
  })

  it('should use the subsection data from the cache if it has it', function () {
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()

    el.querySelector('[href="/browse/benefits"]').click()
    jasmine.Ajax.requests.mostRecent().respondWith({
      status: 200,
      response: sectionResponse
    })
    expect(bc._cache).toEqual(sectionCache)

    el.querySelector('[href="/browse/benefits/manage-your-benefit"]').click()
    jasmine.Ajax.requests.mostRecent().respondWith({
      status: 200,
      response: subSectionResponse
    })
    expect(bc._cache).toEqual(subSectionCache)

    el.querySelector('[href="/browse/benefits/manage-your-benefit"]').click()
    expect(jasmine.Ajax.requests.count()).toEqual(2)
  })

  it('should parse a pathname', function () {
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()

    var paths = [
      {
        path: '/browse',
        output: { section: '', path: '/browse', slug: '' }
      },
      {
        path: '/browse/tax',
        output: { section: 'tax', path: '/browse/tax', slug: 'tax' }
      },
      {
        path: '/browse/tax/money',
        output: { section: 'tax', subsection: 'money', path: '/browse/tax/money', slug: 'tax/money' }
      },
      {
        path: '/browse/tax-money/money',
        output: { section: 'tax-money', subsection: 'money', path: '/browse/tax-money/money', slug: 'tax-money/money' }
      }
    ]
    for (var i = 0, pathLength = paths.length; i < pathLength; i++) {
      expect(bc.parsePathname(paths[i].path)).toEqual(paths[i].output)
    }
  })

  it('should update breadcrumbs from cache', function () {
    var context = {
      $breadcrumbs: $('<div class="gem-c-breadcrumbs"><ol><li>one</li></ol></div>')[0]
    }

    var cachedData = {
      sectionData: {
        breadcrumbs: '<div class="gem-c-breadcrumbs"><script type="application/ld+json">{"something":"other"}</script><ol><li>one</li><li>two</li></ol></div>'
      }
    }
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()
    bc.updateBreadcrumbs.call(context, cachedData)
    expect($(context.$breadcrumbs).find('li').length).toEqual(2)
  })

  it('should track a page view', function () {
    GOVUK.analytics = jasmine.createSpyObj('analytics', ['trackPageview'])

    var state = {
      path: 'foo'
    }

    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()
    bc.trackPageview(state)
    var title = document.title

    expect(GOVUK.analytics.trackPageview).toHaveBeenCalledTimes(2)
    expect(GOVUK.analytics.trackPageview).toHaveBeenCalledWith(
      'foo',
      title,
      {
        dimension1: 'browse',
        dimension26: 1,
        dimension27: 2,
        dimension32: 'none',
        location: String(window.location)
      }
    )
    expect(GOVUK.analytics.trackPageview).toHaveBeenCalledWith(
      'foo',
      title,
      {
        dimension1: 'browse',
        dimension26: 1,
        dimension27: 2,
        dimension32: 'none',
        trackerName: 'govuk',
        location: String(window.location)
      }
    )
  })

  it('should fire link click events at the root level in the first column', function () {
    GOVUK.analytics = jasmine.createSpyObj('analytics', ['trackEvent'])
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()
    bc.setTitle('Root level click')

    var link1 = $('#root').find('a').first()
    link1[0].click()

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'firstLevelBrowseLinkClicked',
      '1',
      {
        dimension26: 1,
        dimension27: 2,
        dimension28: '1',
        dimension29: 'Benefits',
        dimension32: 'Browse Index',
        label: '/browse/benefits',
        location: String(window.location),
        title: 'Root level click - GOV.UK'
      }
    )
  })

  // events should show where the user is when they click, not the destination they get to
  it('should fire link click events at the section level', function () {
    GOVUK.analytics = jasmine.createSpyObj('analytics', ['trackEvent'])
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()

    el.querySelector('[href="/browse/benefits"]').click()
    jasmine.Ajax.requests.mostRecent().respondWith({
      status: 200,
      response: sectionResponse
    })

    resetAnalyticsCalls()
    bc.setTitle('Section level click')
    // click on a link in the middle column
    $('#section').find('a:eq(1)')[0].click()

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'secondLevelBrowseLinkClicked',
      '2',
      {
        dimension1: 'benefits',
        dimension26: 1,
        dimension27: 2,
        dimension28: '2',
        dimension29: "Benefits and financial support if you're looking for work",
        dimension32: 'First Level Browse',
        label: '/browse/benefits/looking-for-work',
        location: String(window.location),
        title: 'Section level click - GOV.UK'
      }
    )

    resetAnalyticsCalls()
    bc.setTitle('Section/Root level click')
    // now click on a link in the left column
    $('#root').find('a').first()[0].click()

    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'firstLevelBrowseLinkClicked',
      '1',
      {
        dimension26: 1,
        dimension27: 2,
        dimension28: '1',
        dimension29: 'Benefits',
        dimension32: 'First Level Browse',
        label: '/browse/benefits',
        location: String(window.location),
        title: 'Section/Root level click - GOV.UK'
      }
    )
  })

  it('should fire link click events at the subsection level', function () {
    GOVUK.analytics = jasmine.createSpyObj('analytics', ['trackEvent'])
    var bc = new window.GOVUK.Modules.BrowseColumns(el)
    bc.init()

    el.querySelector('[href="/browse/benefits"]').click()
    jasmine.Ajax.requests.mostRecent().respondWith({
      status: 200,
      response: sectionResponse
    })

    el.querySelector('[href="/browse/benefits/manage-your-benefit"]').click()
    jasmine.Ajax.requests.mostRecent().respondWith({
      status: 200,
      response: subSectionResponse
    })

    resetAnalyticsCalls()
    bc.setTitle('Section level click')
    $('#section').find('a:eq(1)')[0].click()
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'secondLevelBrowseLinkClicked',
      '2',
      {
        dimension1: 'benefits',
        dimension26: 2,
        dimension27: 3,
        dimension28: '2',
        dimension29: "Benefits and financial support if you're looking for work",
        dimension32: 'Second Level Browse',
        label: '/browse/benefits/looking-for-work',
        location: String(window.location),
        title: 'Section level click - GOV.UK'
      }
    )

    resetAnalyticsCalls()
    bc.setTitle('Subsection level click')
    $('#subsection').find('a').first()[0].click()
    expect(GOVUK.analytics.trackEvent).toHaveBeenCalledWith(
      'thirdLevelBrowseLinkClicked',
      '1.1',
      {
        dimension1: 'benefits',
        dimension26: 2,
        dimension27: 3,
        dimension28: '2',
        dimension29: 'Sign in to your Universal Credit account',
        dimension32: 'Second Level Browse',
        label: '/sign-in-universal-credit',
        location: String(window.location),
        title: 'Subsection level click - GOV.UK'
      }
    )
  })

  // http://stackoverflow.com/questions/9821166/error-accessing-jquerywindow-height-in-jasmine-while-running-tests-in-maven
  function setWindowSize (size) {
    $.prototype.width = function () {
      var original = $.prototype.width

      if (this[0] === window) {
        return size
      } else {
        return original.apply(this, arguments)
      }
    }
  }
})
