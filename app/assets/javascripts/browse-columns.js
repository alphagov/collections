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

    if(this.$subsection.length === 0){
      this.$subsection = $('<div id="subsection" class="pane" />').hide();
      this.$el.prepend(this.$subsection);
    } else {
      this.$subsection.show();
    }

    this.state = this.$el.data('state');
    this._cache = {};

    this.$el.on('click', 'a', $.proxy(this.navigate, this));

    $(window).on('popstate', $.proxy(this.popState, this));
  }
  BrowseColumns.prototype = {
    popState: function(e){
      var state = e.originalEvent.state;

      if(state.subsection){
        this.showSubsection(state);
        this.highlightSection('section', state.path);
        this.highlightSection('root', '/browse/' + state.section);
      } else {
        this.showSection(state);
        this.highlightSection('root', state.path);
      }
    },
    sectionCache: function(slug, data){
      if(typeof data === 'undefined'){
        return this._cache[slug];
      } else {
        this._cache[slug] = data;
      }
    },
    showSection: function(state){
      this.setTitle(state.title);
      state.sectionData.results.sort(function(a, b){ return a.title.localeCompare(b.title); });
      this.$section.mustache('browse/_section', { title: state.title, options: state.sectionData.results});

      if(this.state !== 'section'){
        // animate to the right position and update the data
        this.$subsection.hide();
        this.$section.css('margin-right', '63%');
        this.$section.find('.pane-inner').animate({
          paddingLeft: '96px'
        }, this.animateSpeed);
        this.$section.animate({
          width: '35%',
          marginLeft: '0%',
          marginRight: '40%'
        }, this.animateSpeed, $.proxy(function(){
          this.state = 'section';

          this.$el.removeClass('subsection').addClass('section');
          this.$section.attr('style', '');
          this.$section.find('.pane-inner').attr('style', '');
          this.$section.addClass('with-sort');
        }, this));
      }
      // update the data
    },
    showSubsection: function(state){
      this.setTitle(state.title);
      this.$subsection.mustache('browse/_section', {
        title: state.title,
        options: state.sectionData.results,
        "detailed_guide_categories_any?": state.detailedGuideData.results,
        detailed_guide_categories: state.detailedGuideData.results
      });

      if(this.state !== 'subsection'){
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
          this.state = 'section';

          this.$el.removeClass('section').addClass('subsection');
          this.$subsection.show();
          this.$section.removeClass('with-sort');
          this.state = 'subsection';

          this.$section.find('.sort-order').attr('style', '');
          this.$section.attr('style', '');
          this.$section.find('.pane-inner').attr('style', '');
        }, this));

      }
      // update the data
    },
    setTitle: function(title){
      $('title').text(title);
    },

    getDetailedGuideData: function(slug, dataPromise){
      var data = this.sectionCache(slug);
      var url = "/api/specialist/tags.json?type=section&parent_id=";

      var out = new $.Deferred()
      if(typeof data !== 'undefined'){
        out.resolve(data);
      } else {
        $.ajax({
          url: url + slug
        }).done($.proxy(function(data){
          this.sectionCache(slug, data);
          out.resolve(data);
        }, this)).fail($.proxy(function(jqXHR, textStatus, errorThrown){
          console.log(arguments);
          out.resolve({});
        }, this));
      }
      return out;
    },

    // getSection: returns a promise which will contain the data
    // Returns data from the cache if it is their of puts the data in the cache
    // if it is not.
    getSectionData: function(slug){
      var data = this.sectionCache(slug),
          sectionUrl = "/api/tags.json?type=section&parent_id=",
          subsectionUrl = "/api/with_tag.json?section=",
          out = new $.Deferred(),
          url;

      if(slug.indexOf('/') > -1){
        url = subsectionUrl;
      } else {
        url = sectionUrl;
      }

      if(typeof data !== 'undefined'){
        out.resolve(data);
      } else {
        $.ajax({
          url: url + slug
        }).done($.proxy(function(data){
          this.sectionCache(slug, data);
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
    navigate: function(e){
      if(e.target.pathname.match(/^\/browse\/[^\/]+(\/[^\/]+)?$/)){
        e.preventDefault();

        var $target = $(e.target);
        var state = this.parsePathname(e.target.pathname);
        state.title = $target.text();

        if(state.path === window.location.pathname){
          return;
        }

        var donePromise = this.getSectionData(state.slug);
        if(state.subsection){
          var sectionPromise = donePromise;
          var detailedGuidePromise = this.getDetailedGuideData(state.slug);
          donePromise = $.when(sectionPromise, detailedGuidePromise);
        }

        donePromise.done($.proxy(function(sectionData, detailedGuideData){
          state.sectionData = sectionData;
          state.detailedGuideData = detailedGuideData;
          history.pushState(state, '', e.target.pathname);

          this.scrollToBrowse();

          if(state.slug.indexOf('/') > -1){
            this.showSubsection(state);
            this.highlightSection('section', state.path);
          } else {
            this.showSection(state);
            this.highlightSection('root', state.path);
          }
        }, this));
      }
    }
  };


  GOVUK.BrowseColumns = BrowseColumns;

  $(function(){ GOVUK.browseColumns = new BrowseColumns({$el: $('.browse-panes')}); })
}());
