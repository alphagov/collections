(function() {
  "use strict";
  window.GOVUK = window.GOVUK || {};
  var $ = window.jQuery;

  function BrowseColumns(options){
    if(options.$el.length === 0) return;

    this.$el = options.$el;

    this.state = this.$el.data('state');
    this._cache = {};

    this.$el.on('click', 'a', $.proxy(this.navigate, this));
  }
  BrowseColumns.prototype = {
    sectionCache: function(slug, data){
      if(typeof data === 'undefined'){
        return this._cache[slug];
      } else {
        this._cache[slug] = data;
      }
    },
    showSection: function(data){
      if(this.state !== 'section'){
        // animate to the right position and update the data
        this.$el.removeClass('subsection').addClass('section');
        this.$el.find('#subsection').hide();
        this.state = 'section';
      }
      // update the data
      var html = $.map(data.results, function(el){ return '<a href="'+el.web_url+'">'+el.title+'</a>'; }).join(' ');
      this.$el.find('#section').html(html);
    },
    showSubsection: function(data){
      if(this.state !== 'subsection'){
        // animate to the right position and update the data
        this.$el.removeClass('section').addClass('subsection');
        this.state = 'subsection';
        if(this.$el.find('#subsection').length === 0){
          this.$el.prepend('<div id="subsection" class="pane" />');
        } else {
          this.$el.find('#subsection').show();
        }
      }
      // update the data
      var html = $.map(data.results, function(el){ return '<a href="'+el.web_url+'">'+el.title+'</a>'; }).join(' ');
      this.$el.find('#subsection').html(html);
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
    navigate: function(e){
      if(e.target.pathname.match(/^\/browse/)){
        e.preventDefault();

        var slug = e.target.pathname.replace('/browse/', '');

        var dataPromise = this.getSectionData(slug);

        dataPromise.done($.proxy(function(data){
          if(slug.indexOf('/') > -1){
            this.showSubsection(data);
          } else {
            this.showSection(data);
          }
        }, this));
      }
    }
  };


  GOVUK.BrowseColumns = BrowseColumns;

  $(function(){ GOVUK.browseColumns = new BrowseColumns({$el: $('.browse-panes')}); })
}());
