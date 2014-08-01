describe('browse-columns.js', function() {
  it("should cache objects", function() {
    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });

    expect(bc.sectionCache('prefix', 'object-name')).toBe(undefined);

    bc.sectionCache('prefix', 'object-name', 'cache-thing');

    expect(bc.sectionCache('prefix', 'object-name')).toBe('cache-thing');
  });

  it("should set page title", function() {
    GOVUK.BrowseColumns.prototype.setTitle('new-title');

    expect($('title').text()).toBe('new-title');
  });

  it("should get section data and cache it", function() {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['done', 'error']);
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj);
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj);

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });
    spyOn(bc, 'sectionCache');

    var responseObj = bc.getSectionData('section');

    expect(jQuery.ajax).toHaveBeenCalledWith({
      url: '/api/tags.json?type=section&parent_id=section'
    });
    expect(promiseObj.done).toHaveBeenCalled();
    promiseObj.done.calls.mostRecent().args[0]('response data')
    expect(bc.sectionCache).toHaveBeenCalled();
  });

  it("should use the section data from the cache if it has it", function() {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['done', 'resolve']);
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj);
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj);

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });
    bc.sectionCache('section', 'section', 'data');

    var responseObj = bc.getSectionData('section');

    expect(jQuery.ajax.calls.any()).toBe(false);

    expect(promiseObj.resolve).toHaveBeenCalled();
    expect(promiseObj.resolve.calls.mostRecent().args[0]).toBe('data')
  });

  it("should get subsection data and cache it", function() {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['done', 'error']);
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj);
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj);

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });
    spyOn(bc, 'sectionCache');

    var responseObj = bc.getSectionData('section/subsection');

    expect(jQuery.ajax).toHaveBeenCalledWith({
      url: '/api/with_tag.json?section=section/subsection'
    });
    expect(promiseObj.done).toHaveBeenCalled();
    promiseObj.done.calls.mostRecent().args[0]('response data')
    expect(bc.sectionCache).toHaveBeenCalled();
  });

  it("should use the subsection data from the cache if it has it", function() {
    var promiseObj = jasmine.createSpyObj('promiseObj', ['done', 'resolve']);
    spyOn(jQuery, 'ajax').and.returnValue(promiseObj);
    spyOn(jQuery, 'Deferred').and.returnValue(promiseObj);

    var bc = new GOVUK.BrowseColumns({ $el: $('<div>') });
    bc.sectionCache('section', 'section/subsection', 'data');

    var responseObj = bc.getSectionData('section/subsection');

    expect(jQuery.ajax.calls.any()).toBe(false);

    expect(promiseObj.resolve).toHaveBeenCalled();
    expect(promiseObj.resolve.calls.mostRecent().args[0]).toBe('data')
  });

  it("should parse a pathname", function() {
    var paths = [
      {
        path: '/browse',
        output: { section: '', path: '/browse/tax', slug: '' }
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
    ];
    for(var i=0, pathLength=paths.length; i<pathLength; i++){
      expect(GOVUK.BrowseColumns.prototype.parsePathname(paths[i].path)).toEqual(paths[i].output);
    }
  });



});
