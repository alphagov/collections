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
        this.showSubsection(state.title, state.data);
        this.highlightSection('section', state.path);
        this.highlightSection('root', '/browse/' + state.section);
      } else {
        this.showSection(state.title, state.data);
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
    showSection: function(title, data){
      this.setTitle(title);
      data.results.sort(function(a, b){ return a.title.localeCompare(b.title); });
      this.$section.mustache('browse/_section', { title: title, options: data.results});

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
    showSubsection: function(title, data){
      this.setTitle(title);
      this.$subsection.mustache('browse/_section', { title: title, options: data.results});

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
    // getSection: returns a promise which will contain the data
    // Returns data from the cache if it is their of puts the data in the cache
    // if it is not.
    getSectionData: function(slug){
      var data = this.sectionCache(slug),
          sectionUrl = "/api/tags.json?type=section&parent_id=",
          subsectionUrl = "/api/with_tag.json?section=",
          url;

      if(slug.indexOf('/') > -1){
        url = subsectionUrl;
      } else {
        url = sectionUrl;
      }

      if(typeof data !== 'undefined'){
        var out = new $.Deferred()
        return out.resolve(data);
      } else {
        return $.ajax({
          url: url + slug
        }).done($.proxy(function(data){
          this.sectionCache(slug, data);
        }, this));
      }
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
      if(e.target.pathname.match(/^\/browse/)){
        e.preventDefault();

        var $target = $(e.target);
        var state = this.parsePathname(e.target.pathname);
        state.title = $target.text();

        if(state.path === window.location.pathname){
          return;
        }

        var dataPromise = this.getSectionData(state.slug);

        dataPromise.done($.proxy(function(data){
          state.data = data;
          history.pushState(state, '', e.target.pathname);

          this.scrollToBrowse();

          if(state.slug.indexOf('/') > -1){
            this.showSubsection(state.title, data);
            this.highlightSection('section', state.path);
          } else {
            this.showSection(state.title, data);
            this.highlightSection('root', state.path);
          }
        }, this));
      }
    }
  };


  GOVUK.BrowseColumns = BrowseColumns;

  $(function(){ GOVUK.browseColumns = new BrowseColumns({$el: $('.browse-panes')}); })
}());
