(function() {
  "use strict";
  window.GOVUK = window.GOVUK || {};
  var $ = window.jQuery;

  function BrowseColumns(options){
    if(options.$el.length === 0) return;
    if(!GOVUK.support.history()) return;

    this.$el = options.$el;
    this.$root = this.$el.find('#root');
    this.$section = this.$el.find('#section');
    this.$subsection = this.$el.find('#subsection');
    this.animateSpeed = 200;

    if(this.$section.length === 0){
      this.$section = $('<div id="section" class="pane with-sort" />');
      this.$el.prepend(this.$section);
      this.$el.addClass('section');
    }

    if(this.$subsection.length === 0){
      this.$subsection = $('<div id="subsection" class="pane" />').hide();
      this.$el.prepend(this.$subsection);
    } else {
      this.$subsection.show();
    }

    this.displayState = this.$el.data('state');
    if(typeof this.displayState === 'undefined'){
      this.displayState = 'root';
    }
    this._cache = {};

    this.lastState = this.parsePathname(window.location.pathname);

    this.mobile = this.isMobile();

    this.$el.on('click', 'a', $.proxy(this.navigate, this));

    $(window).on('popstate', $.proxy(this.popState, this));
  }
  BrowseColumns.prototype = {
    popState: function(e){
      var state = e.originalEvent.state;
      var pathState = this.parsePathname(window.location.pathname);

      if(pathState.slug == ''){
        this.showRoot();
      } else if(pathState.subsection){
        // are we displaying the correct section for the subsection?
        if(this.lastState.section != pathState.section){
          // load the section then load the subsection after
          var sectionPathname = window.location.pathname.split('/').slice(0,-1).join('/');
          var sectionState = this.parsePathname(sectionPathname);
          var sectionPromise = this.loadSectionFromState(sectionState);
          sectionPromise.done($.proxy(function(){
            this.loadSectionFromState(pathState);
          }, this));
        } else {
          if(state.sectionData){
            this.showSubsection(state);
          } else {
            this.loadSectionFromState(pathState);
          }
        }
      } else {
        this.showSection(state);
        if(state.sectionData){
          this.showSection(state);
        } else {
          this.loadSectionFromState(pathState);
        }
      }
    },
    isMobile: function(){
      return $(window).width() < 640;
    },
    sectionCache: function(prefix, slug, data){
      if(typeof data === 'undefined'){
        return this._cache[prefix + slug];
      } else {
        this._cache[prefix + slug] = data;
      }
    },
    showRoot: function(){
      this.$section.html('');
      this.displayState = 'root';
    },
    showSection: function(state){
      state.title = this.getTitle(state.slug);
      state.sectionData.results.sort(function(a, b){ return a.title.localeCompare(b.title); });

      this.setTitle(state.title);
      this.$section.mustache('browse/_section', { title: state.title, options: state.sectionData.results});
      this.highlightSection('root', state.path);

      function afterAnimate(){
        this.displayState = 'section';

        this.$el.removeClass('subsection').addClass('section');
        this.$section.attr('style', '');
        this.$section.find('.pane-inner').attr('style', '');
        this.$section.addClass('with-sort');
      }

      if(this.displayState === 'subsection'){
        // animate to the right position and update the data
        this.$subsection.hide();
        if(!this.mobile){
          this.$section.css('margin-right', '63%');
          this.$section.find('.pane-inner').animate({
            paddingLeft: '96px'
          }, this.animateSpeed);
          this.$section.animate({
            width: '35%',
            marginLeft: '0%',
            marginRight: '40%'
          }, this.animateSpeed, $.proxy(afterAnimate, this));
        } else {
          afterAnimate();
        }
      }
    },
    showSubsection: function(state){
      state.title = this.getTitle(state.slug);

      this.setTitle(state.title);
      this.$subsection.mustache('browse/_section', {
        title: state.title,
        options: state.sectionData.results,
        "detailed_guide_categories_any?": !!state.detailedGuideData.results,
        detailed_guide_categories: state.detailedGuideData.results
      });
      this.highlightSection('section', state.path);
      this.highlightSection('root', '/browse/' + state.section);

      if(this.displayState !== 'subsection'){
        // animate to the right position and update the data
        this.$section.find('.sort-order').hide();
        this.$section.find('.pane-inner').animate({
          paddingLeft: '0'
        }, this.animateSpeed);
        this.$section.animate({
          width: '25%',
          marginLeft: '-13%',
          marginRight: '63%'
        }, this.animateSpeed, $.proxy(function(){
          this.displayState = 'section';

          this.$el.removeClass('section').addClass('subsection');
          this.$subsection.show();
          this.$section.removeClass('with-sort');
          this.displayState = 'subsection';

          this.$section.find('.sort-order').attr('style', '');
          this.$section.attr('style', '');
          this.$section.find('.pane-inner').attr('style', '');
        }, this));

      }
      // update the data
    },
    getTitle: function(slug){
      return this.$el.find('a[href$="/browse/'+slug+'"]:first').text();
    },
    setTitle: function(title){
      $('title').text(title);
    },

    getDetailedGuideData: function(slug, dataPromise){
      var data = this.sectionCache('detailed', slug);
      var url = "/api/specialist/tags.json?type=section&parent_id=";

      var out = new $.Deferred()
      if(typeof data !== 'undefined'){
        out.resolve(data);
      } else {
        $.ajax({
          url: url + slug
        }).done($.proxy(function(data){
          this.sectionCache('detailed', slug, data);
          out.resolve(data);
        }, this)).fail($.proxy(function(jqXHR, textStatus, errorThrown){
          out.resolve({});
        }, this));
      }
      return out;
    },

    // getSectionData: returns a promise which will contain the data
    // Returns data from the cache if it is there or puts the data in the cache
    // if it is not.
    getSectionData: function(state){
      var cacheForSlug = this.sectionCache('section', state.slug),
          sectionUrl = "/api/tags.json?type=section&parent_id=",
          subsectionUrl = "/api/with_tag.json?section=",
          out = new $.Deferred(),
          url;

      if(state.subsection){
        url = subsectionUrl;
      } else {
        url = sectionUrl;
      }

      if(typeof cacheForSlug !== 'undefined'){
        out.resolve(cacheForSlug);
      } else {
        $.ajax({
          url: url + state.slug
        }).done($.proxy(function(data){
          this.sectionCache('secton', state.slug, data);
          out.resolve(data);
        }, this));
      }
      return out;
    },
    highlightSection: function(section, slug){
      this.$el.find('#'+section+' .active').removeClass('active')
      this.$el.find('a[href$="'+slug+'"]').parent().addClass('active');
    },
    parsePathname: function(pathname){
      var out = {
        path: pathname,
        slug: pathname.replace('/browse/', '')
      };

      if(out.slug.indexOf('/') > -1){
        out.section = out.slug.split('/')[0];
        out.subsection = out.slug.split('/')[1];
      } else {
        out.section = out.slug;
      }
      return out;
    },
    scrollToBrowse: function(){
      var $body = $('body'),
          elTop = this.$el.offset().top;

      if( $body.scrollTop() > elTop ){
        $('body').animate({scrollTop: elTop}, this.animateSpeed);
      }
    },
    loadSectionFromState: function(state){
      var donePromise = this.getSectionData(state);
      if(state.subsection){
        var sectionPromise = donePromise;
        var detailedGuidePromise = this.getDetailedGuideData(state.slug);
        donePromise = $.when(sectionPromise, detailedGuidePromise);
      }

      donePromise.done($.proxy(function(sectionData, detailedGuideData){
        state.sectionData = sectionData;
        state.detailedGuideData = detailedGuideData;
        history.pushState(state, '', state.path);

        this.scrollToBrowse();

        if(state.subsection){
          this.showSubsection(state);
        } else {
          this.showSection(state);
        }
        this.lastState = state;
      }, this));

      return donePromise;
    },
    navigate: function(e){
      if(e.target.pathname.match(/^\/browse\/[^\/]+(\/[^\/]+)?$/)){
        e.preventDefault();

        var $target = $(e.target);
        var state = this.parsePathname(e.target.pathname);
        state.title = $target.text();

        if(state.path === window.location.pathname){
          return;
        }

        this.loadSectionFromState(state);
      }
    }
  };


  GOVUK.BrowseColumns = BrowseColumns;

  $(function(){ GOVUK.browseColumns = new BrowseColumns({$el: $('.browse-panes')}); })
}());
