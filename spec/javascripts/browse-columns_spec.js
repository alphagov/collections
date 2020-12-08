describe('browse-columns.js', function () {
  beforeEach(function () {
    // The window size needs to be wider than 500 pixels, otherwise the
    // ajax-browsing will be disabled.
    setWindowSize(1024)
  })

  it('should cache objects', function () {
    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') })

    expect(bc.sectionCache('prefix', 'object-name')).toBe(undefined)

    bc.sectionCache('prefix', 'object-name', 'cache-thing')

    expect(bc.sectionCache('prefix', 'object-name')).toBe('cache-thing')
  })

  it('should set page title with the GOV.UK suffix', function () {
    GOVUK.BrowseColumns.prototype.setTitle('new-title')

    expect($('title').text()).toBe('new-title - GOV.UK')
  })

  it('should get section data and cache it', function () {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['then', 'error', 'resolve'])
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj)
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj)

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') })
    spyOn(bc, 'sectionCache')

    bc.getSectionData({ slug: 'section' })

    expect(jQuery.ajax).toHaveBeenCalledWith({
      url: '/browse/section.json'
    })
    expect(promiseObj.then).toHaveBeenCalled()
    promiseObj.then.calls.mostRecent().args[0]('response data')
    expect(bc.sectionCache).toHaveBeenCalled()
  })

  it('should use the section data from the cache if it has it', function () {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['then', 'resolve'])
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj)
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj)

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') })
    bc.sectionCache('section', 'section', 'data')

    bc.getSectionData({ slug: 'section' })

    expect(jQuery.ajax.calls.any()).toBe(false)

    expect(promiseObj.resolve).toHaveBeenCalled()
    expect(promiseObj.resolve.calls.mostRecent().args[0]).toBe('data')
  })

  it('should get subsection data and cache it', function () {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['then', 'error', 'resolve'])
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj)
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj)

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') })
    spyOn(bc, 'sectionCache')

    bc.getSectionData({ subsection: true, slug: 'section/subsection' })

    expect(jQuery.ajax).toHaveBeenCalledWith({
      url: '/browse/section/subsection.json'
    })
    expect(promiseObj.then).toHaveBeenCalled()
    promiseObj.then.calls.mostRecent().args[0]('response data')
    expect(bc.sectionCache).toHaveBeenCalled()
  })

  it('should use the subsection data from the cache if it has it', function () {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['then', 'resolve'])
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj)
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj)

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') })
    bc.sectionCache('section', 'section/subsection', 'data')

    bc.getSectionData({ slug: 'section/subsection' })

    expect(jQuery.ajax.calls.any()).toBe(false)

    expect(promiseObj.resolve).toHaveBeenCalled()
    expect(promiseObj.resolve.calls.mostRecent().args[0]).toBe('data')
  })

  it('should parse a pathname', function () {
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
      expect(GOVUK.BrowseColumns.prototype.parsePathname(paths[i].path)).toEqual(paths[i].output)
    }
  })

  it('should update breadcrumbs from cache', function () {
    var context = {
      $breadcrumbs: $('<div class="gem-c-breadcrumbs"><ol><li>one</li></ol></div>')
    }

    var cachedData = {
      sectionData: {
        breadcrumbs: '<div class="gem-c-breadcrumbs"><script type="application/ld+json">{"something":"other"}</script><ol><li>one</li><li>two</li></ol></div>'
      }
    }
    GOVUK.BrowseColumns.prototype.updateBreadcrumbs.call(context, cachedData)
    expect(context.$breadcrumbs.find('li').length).toEqual(2)
  })

  it('should track a page view', function () {
    GOVUK.analytics = jasmine.createSpyObj('analytics', ['trackPageview'])

    var state = {
      path: 'foo'
    }

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') })
    bc.trackPageview(state)

    expect(GOVUK.analytics.trackPageview).toHaveBeenCalledTimes(2)
    expect(GOVUK.analytics.trackPageview).toHaveBeenCalledWith(
      'foo',
      null,
      {
        dimension1: 'browse',
        dimension32: 'none'
      }
    )
    expect(GOVUK.analytics.trackPageview).toHaveBeenCalledWith(
      'foo',
      null,
      {
        dimension1: 'browse',
        dimension32: 'none',
        trackerName: 'govuk'
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
