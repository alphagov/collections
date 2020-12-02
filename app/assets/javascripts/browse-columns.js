(function () {
  'use strict'
  window.GOVUK = window.GOVUK || {}
  var $ = window.jQuery

  function BrowseColumns (options) {
    if (options.$el.length === 0) return
    if (!GOVUK.support.history()) return
    if ($(window).width() < 640) return // don't ajax navigation on mobile

    this.$el = options.$el
    this.$root = this.$el.find('#root')
    this.$section = this.$el.find('#section')
    this.$subsection = this.$el.find('#subsection')
    this.$breadcrumbs = $('.gem-c-breadcrumbs')
    this.animateSpeed = 330

    if (this.$section.length === 0) {
      this.$section = $('<div id="section" class="section-pane pane with-sort" />')
      this.$el.prepend(this.$section)
      this.$el.addClass('section')
    }

    if (this.$subsection.length === 0) {
      this.$subsection = $('<div id="subsection" class="subsection-pane pane" />').hide()
      this.$el.prepend(this.$subsection)
    } else {
      this.$subsection.show()
    }

    this.displayState = this.$el.data('state')
    if (typeof this.displayState === 'undefined') {
      this.displayState = 'root'
    }
    this._cache = {}

    this.lastState = this.parsePathname(window.location.pathname)

    this.$el.on('click', 'a', this.navigate.bind(this))

    $(window).on('popstate', this.popState.bind(this))
  }
  BrowseColumns.prototype = {
    popState: function (e) {
      var state = e.originalEvent.state
      var loadPromise
      if (!state) { // state will be null if there was no state set
        state = this.parsePathname(window.location.pathname)
      }

      if (this.lastState.slug === state.slug) {
        return // nothing has changed
      }

      if (state.slug == '') {
        loadPromise = this.showRoot()
      } else if (state.subsection) {
        loadPromise = this.restoreSubsection(state)
      } else {
        loadPromise = this.loadSectionFromState(state, true)
      }
      loadPromise.then(function () {
        this.trackPageview(state)
      }.bind(this))
    },
    restoreSubsection: function (state) {
      // are we displaying the correct section for the subsection?
      if (this.lastState.section != state.section) {
        // load the section then load the subsection after
        var sectionPathname = window.location.pathname.split('/').slice(0, -1).join('/')
        var sectionState = this.parsePathname(sectionPathname)
        return this.loadSectionFromState(sectionState, true)
          .then(function () {
            return this.loadSectionFromState(state, true)
          }.bind(this))
      } else {
        return this.loadSectionFromState(state, true)
      }
    },
    sectionCache: function (prefix, slug, data) {
      if (typeof data === 'undefined') {
        return this._cache[prefix + slug]
      } else {
        this._cache[prefix + slug] = data
      }
    },
    isDesktop: function () {
      return $(window).width() > 768
    },
    showRoot: function () {
      this.$section.html('')
      this.displayState = 'root'
      this.$root.find('.js-heading').focus()

      var out = new $.Deferred()
      return out.resolve()
    },
    showSection: function (state) {
      this.setContentIDMetaTag(state.sectionData.content_id)
      this.setNavigationPageTypeMetaTag(state.sectionData.navigation_page_type)
      state.title = this.getTitle(state.slug)
      this.setTitle(state.title)
      this.$section.html(state.sectionData.html)

      this.highlightSection('root', state.path)
      this.removeLoading()
      this.updateBreadcrumbs(state)

      var animationDone
      if (this.displayState === 'subsection') {
        // animate to the right position and update the data
        animationDone = this.animateSubsectionToSectionDesktop()
      } else if (this.displayState === 'root') {
        animationDone = this.animateRootToSectionDesktop()
      } else {
        animationDone = new $.Deferred()
        animationDone.resolve()
      }
      return animationDone.then(function () {
        this.$section.find('.js-heading').focus()
      }.bind(this))
    },
    animateSubsectionToSectionDesktop: function () {
      var out = new $.Deferred()
      function afterAnimate () {
        this.displayState = 'section'

        this.$el.removeClass('subsection').addClass('section')
        this.$section.attr('style', '')
        this.$section.find('.pane-inner').attr('style', '')
        this.$section.addClass('with-sort')
        this.$root.attr('style', '')
        out.resolve()
      }

      // animate to the right position and update the data
      this.$root.css({ position: 'absolute', width: this.$root.width() })
      this.$subsection.hide()
      this.$section.css('margin-right', '63%')
      if (this.isDesktop()) {
        this.$section.find('.pane-inner.curated').animate({
          paddingLeft: '30px'
        }, this.animateSpeed)

        this.$section.find('.pane-inner.alphabetical').animate({
          paddingLeft: '96px'
        }, this.animateSpeed)

        var sectionProperties = {
          width: '35%',
          marginLeft: '0%',
          marginRight: '40%'
        }
      } else {
        var sectionProperties = {
          width: '30%',
          marginLeft: '0%',
          marginRight: '45%'
        }
      }
      this.$section.animate(sectionProperties, this.animateSpeed, afterAnimate.bind(this))
      return out
    },
    animateRootToSectionDesktop: function () {
      var out = new $.Deferred()
      this.displayState = 'section'
      this.$el.removeClass('subsection').addClass('section')

      return out.resolve()
    },
    showSubsection: function (state) {
      this.setContentIDMetaTag(state.sectionData.content_id)
      this.setNavigationPageTypeMetaTag(state.sectionData.navigation_page_type)
      state.title = this.getTitle(state.slug)
      this.setTitle(state.title)
      this.$subsection.html(state.sectionData.html)
      this.highlightSection('section', state.path)
      this.highlightSection('root', '/browse/' + state.section)
      this.removeLoading()
      this.updateBreadcrumbs(state)

      var animationDone
      if (this.displayState !== 'subsection') {
        animationDone = this.animateSectionToSubsectionDesktop()
      } else {
        animationDone = new $.Deferred()
        animationDone.resolve()
      }
      return animationDone.then(function () {
        this.$subsection.find('.js-heading').focus()
      }.bind(this))
    },
    animateSectionToSubsectionDesktop: function () {
      var out = new $.Deferred()
      // animate to the right position and update the data
      this.$root.css({ position: 'absolute', width: this.$root.width() })
      this.$section.find('.sort-order').hide()
      this.$section.find('.pane-inner').animate({
        paddingLeft: '0'
      }, this.animateSpeed)
      if (this.isDesktop()) {
        var sectionProperties = {
          width: '25%',
          marginLeft: '-13%',
          marginRight: '63%'
        }
      } else {
        var sectionProperties = {
          width: '30%',
          marginLeft: '-18%',
          marginRight: '63%'
        }
      }
      this.$section.animate(sectionProperties, this.animateSpeed, function () {
        this.$el.removeClass('section').addClass('subsection')
        this.$subsection.show()
        this.$section.removeClass('with-sort')
        this.displayState = 'subsection'

        this.$section.find('.sort-order').attr('style', '')
        this.$section.attr('style', '')
        this.$section.find('.pane-inner').attr('style', '')
        this.$root.attr('style', '')
        out.resolve()
      }.bind(this))
      return out
    },
    getTitle: function (slug) {
      var $link = this.$el.find('a[href$="/browse/' + slug + '"]:first')
      var $heading = $link.find('h3')
      if ($heading.length > 0) {
        return $heading.text()
      } else {
        return $link.text()
      }
    },
    setTitle: function (title) {
      $('title').text(title + ' - GOV.UK')
    },
    setContentIDMetaTag: function (content_id) {
      $('meta[name="govuk:content-id"]').attr('content', content_id)
    },
    setNavigationPageTypeMetaTag: function (navigation_page_type) {
      $('meta[name="govuk:navigation-page-type"]').attr('content', navigation_page_type)
    },
    addLoading: function ($el) {
      this.$el.attr('aria-busy', 'true')
      $el.addClass('loading')
    },
    removeLoading: function () {
      this.$el.attr('aria-busy', 'false')
      this.$el.find('a.loading').removeClass('loading')
    },

    // getSectionData: returns a promise which will contain the data
    // Returns data from the cache if it is there or puts the data in the cache
    // if it is not.
    getSectionData: function (state) {
      var cacheForSlug = this.sectionCache('section', state.slug)
      var out = new $.Deferred()
      var url = '/browse/' + state.slug + '.json'

      if (typeof state.sectionData !== 'undefined') {
        out.resolve(state.sectionData)
      } else if (typeof cacheForSlug !== 'undefined') {
        out.resolve(cacheForSlug)
      } else {
        $.ajax({
          url: url
        }).then(function (data) {
          this.sectionCache('section', state.slug, data)

          out.resolve(data)
        }.bind(this))
      }
      return out
    },
    highlightSection: function (section, slug) {
      this.$el.find('#' + section + ' .active').removeClass('active')
      this.$el.find('a[href$="' + slug + '"]').parent().addClass('active')
    },
    parsePathname: function (pathname) {
      var out = {
        path: pathname,
        slug: pathname.replace(/\/browse\/?/, '')
      }

      if (out.slug.indexOf('/') > -1) {
        out.section = out.slug.split('/')[0]
        out.subsection = out.slug.split('/')[1]
      } else {
        out.section = out.slug
      }
      return out
    },
    scrollToBrowse: function () {
      var $body = $('body')
      var elTop = this.$el.offset().top

      if ($body.scrollTop() > elTop) {
        $('body').animate({ scrollTop: elTop }, this.animateSpeed)
      }
    },
    loadSectionFromState: function (state, poppingState) {
      var donePromise = this.getSectionData(state)
      if (state.subsection) {
        var sectionPromise = donePromise
        donePromise = $.when(sectionPromise)
      }

      return donePromise
        .then(function (sectionData) {
          state.sectionData = sectionData
          this.scrollToBrowse()

          this.lastState = state

          if (state.subsection) {
            return this.showSubsection(state)
          } else {
            return this.showSection(state)
          }
        }.bind(this))
        .then(function () {
          if (typeof poppingState === 'undefined') {
            history.pushState(state, '', state.path)
            this.trackPageview(state)
          }
        }.bind(this))
    },
    navigate: function (e) {
      if (e.currentTarget.pathname.match(/^\/browse\/[^\/]+(\/[^\/]+)?$/)) {
        var $target = $(e.currentTarget)
        e.preventDefault()

        var state = this.parsePathname(e.currentTarget.pathname)
        state.title = $target.text()

        if (state.path === window.location.pathname) {
          return
        }

        this.addLoading($target)
        this.loadSectionFromState(state)
      }
    },
    updateBreadcrumbs: function (state) {
      // Calling `.last()` is necessary because the breadcrumbs component has 2
      // elements, the breadcrumbs and the schema.org data.
      // https://govuk-publishing-components.herokuapp.com/component-guide/breadcrumbs
      var $newBreadcrumbs = $(state.sectionData.breadcrumbs).last()
      this.$breadcrumbs.html($newBreadcrumbs.html())
    },
    trackPageview: function (state) {
      var sectionTitle = this.$section.find('h1').text()
      sectionTitle = sectionTitle ? sectionTitle.toLowerCase() : 'browse'
      var navigationPageType = 'none'

      if (this.displayState == 'section') {
        navigationPageType = 'First Level Browse'
      } else if (this.displayState == 'subsection') {
        navigationPageType = 'Second Level Browse'
      }

      this.firePageview(state, sectionTitle, navigationPageType)
      this.firePageview(state, sectionTitle, navigationPageType, 'govuk')
    },
    firePageview: function (state, sectionTitle, navigationPageType, tracker) {
      if (GOVUK.analytics && GOVUK.analytics.trackPageview) {
        var options = {
          dimension1: sectionTitle,
          dimension32: navigationPageType
        }

        if (typeof tracker !== 'undefined') {
          options.trackerName = tracker
        }

        GOVUK.analytics.trackPageview(
          state.path,
          null,
          options
        )
      }
    }
  }

  GOVUK.BrowseColumns = BrowseColumns

  $(function () { GOVUK.browseColumns = new BrowseColumns({ $el: $('.browse-panes') }) })
}())
