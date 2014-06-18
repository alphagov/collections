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
    showSection: function(title, data){
      if(this.state !== 'section'){
        // animate to the right position and update the data
        this.$el.removeClass('subsection').addClass('section');
        this.$el.find('#subsection').hide();
        this.state = 'section';
      }
      // update the data
      this.$el.find('#section').addClass('with-sort').mustache('browse/_section', { title: title, options: data.results});
    },
    showSubsection: function(title, data){
      if(this.state !== 'subsection'){
        // animate to the right position and update the data
        this.$el.removeClass('section').addClass('subsection');
        this.$el.find('#section').removeClass('with-sort');
        this.state = 'subsection';
        if(this.$el.find('#subsection').length === 0){
          this.$el.prepend('<div id="subsection" class="pane" />');
        } else {
          this.$el.find('#subsection').show();
        }
      }
      // update the data
      this.$el.find('#subsection').mustache('browse/_section', { title: title, options: data.results});
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
      this.$el.find('a[href="'+slug+'"]').parent().addClass('active');
    },
    navigate: function(e){
      if(e.target.pathname.match(/^\/browse/)){
        e.preventDefault();

        var $target = $(e.target);
        var slug = e.target.pathname.replace('/browse/', '');
        var title = $target.text();

        var dataPromise = this.getSectionData(slug);

        dataPromise.done($.proxy(function(data){
          if(slug.indexOf('/') > -1){
            this.showSubsection(title, data);
            this.highlightSection('section', $target.attr('href'));
          } else {
            this.showSection(title, data);
            this.highlightSection('root', $target.attr('href'));
          }
        }, this));
      }
    }
  };


  GOVUK.BrowseColumns = BrowseColumns;

  $(function(){ GOVUK.browseColumns = new BrowseColumns({$el: $('.browse-panes')}); })
}());
