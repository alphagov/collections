//= require govuk_publishing_components/vendor/polyfills/closest
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function BrowseColumns ($module) {
    this.$module = $module
  }

  BrowseColumns.prototype.init = function () {
    if (!GOVUK.support.history()) return
    if (window.screen.width < 640) return // don't ajax navigation on mobile

    this.$root = this.$module.querySelector('#root')
    this.$section = this.$module.querySelector('#section')
    this.$subsection = this.$module.querySelector('#subsection')
    this.$breadcrumbs = document.querySelector('.gem-c-breadcrumbs')
    this.animateSpeed = 330

    this.createSections()

    this.displayState = this.$module.getAttribute('data-state')
    if (typeof this.displayState === 'undefined') {
      this.displayState = 'root'
    }

    this._cache = {}
    this.lastState = this.parsePathname(window.location.pathname)

    this.$module.addEventListener('click', this.navigate.bind(this))
    window.addEventListener('popstate', this.popState.bind(this))
  }

  BrowseColumns.prototype.createSections = function () {
    if (!this.$section) {
      this.$section = document.createElement('div')
      this.$section.setAttribute('id', 'section')
      this.$section.setAttribute('class', 'section-pane pane with-sort')
      this.$module.insertBefore(this.$section, this.$module.firstChild)
      this.$module.classList.add('section')
    }

    if (!this.$subsection) {
      this.$subsection = document.createElement('div')
      this.$subsection.setAttribute('id', 'subsection')
      this.$subsection.setAttribute('class', 'subsection-pane pane')
      this.$subsection.style.display = 'none'
      this.$module.insertBefore(this.$subsection, this.$module.firstChild)
    } else {
      this.$subsection.style.display = 'block'
    }
  }

  BrowseColumns.prototype.navigate = function (event) {
    var target = event.target
    var clicked = target.tagName === 'A' ? target : target.closest('a')

    if (!clicked) {
      return
    }

    if (clicked.pathname.match(/^\/browse\/[^/]+(\/[^/]+)?$/)) {
      event.preventDefault()

      var state = this.parsePathname(clicked.pathname)
      state.title = clicked.textContent

      if (state.path === window.location.pathname) {
        return
      }

      this.addLoading(clicked)
      this.getSectionData(state)
    }
  }

  BrowseColumns.prototype.getSectionData = function (state) {
    var cacheForSlug = this.sectionCache(state.slug)

    if (typeof state.sectionData !== 'undefined') {
      this.handleResponse(state.sectionData, state)
    } else if (typeof cacheForSlug !== 'undefined') {
      this.handleResponse(cacheForSlug, state)
    } else {
      var done = function (e) {
        if (xhr.readyState === 4 && xhr.status === 200) {
          var data = JSON.parse(e.target.response)
          this.sectionCache(state.slug, data)
          this.handleResponse(data, state)
        } else {
          // error FIXME
        }
      }
      var xhr = new XMLHttpRequest()
      var url = '/browse/' + state.slug + '.json'
      xhr.open('GET', url, true)
      xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
      xhr.addEventListener('load', done.bind(this))

      xhr.send()
    }
  }

  // if passed data, sets the cache to that data
  // otherwise returns the matching cache
  BrowseColumns.prototype.sectionCache = function (slug, data) {
    if (typeof data === 'undefined') {
      return this._cache['section' + slug]
    } else {
      this._cache['section' + slug] = data
    }
  }

  BrowseColumns.prototype.handleResponse = function (data, state, poppingState) {
    state.sectionData = data
    this.scrollToBrowse()
    this.lastState = state
    if (state.subsection) {
      this.showSubsection(state)
    } else {
      this.showSection(state)
    }
    if (typeof poppingState === 'undefined') {
      history.pushState(state, '', state.path)
      this.trackPageview(state)
    }
    this.removeLoading()
  }

  BrowseColumns.prototype.popState = function (e) {
    var state = e.originalEvent.state
    if (!state) { // state will be null if there was no state set
      state = this.parsePathname(window.location.pathname)
    }

    if (this.lastState.slug === state.slug) {
      return // nothing has changed
    }

    if (state.slug === '') {
      this.showRoot()
    } else if (state.subsection) {
      this.restoreSubsection(state)
    } else {
      this.loadSectionFromState(state, true)
    }
    this.trackPageview(state)
  }

  BrowseColumns.prototype.restoreSubsection = function (state) {
    // are we displaying the correct section for the subsection?
    if (this.lastState.section !== state.section) {
      // load the section then load the subsection after
      var sectionPathname = window.location.pathname.split('/').slice(0, -1).join('/')
      var sectionState = this.parsePathname(sectionPathname)
      this.loadSectionFromState(sectionState, true)
    }
    this.loadSectionFromState(state, true)
  }

  BrowseColumns.prototype.isDesktop = function () {
    return window.screen.width > 768
  }

  BrowseColumns.prototype.showRoot = function () {
    this.$section.innerHTML = ''
    this.displayState = 'root'
    this.$root.querySelector('.js-heading').focus()
  }

  BrowseColumns.prototype.showSection = function (state) {
    this.setContentIdMetaTag(state.sectionData.content_id)
    this.setNavigationPageTypeMetaTag(state.sectionData.navigation_page_type)
    state.title = this.getTitle(state.slug)
    this.setTitle(state.title)
    this.$section.innerHTML = state.sectionData.html

    this.highlightSection('root', state.path)
    this.updateBreadcrumbs(state)

    // var animationDone
    if (this.displayState === 'subsection') {
      // animate to the right position and update the data
      this.animateSubsectionToSectionDesktop()
    } else if (this.displayState === 'root') {
      this.animateRootToSectionDesktop()
    }
    this.$section.querySelector('.js-heading').focus()
  }

  BrowseColumns.prototype.animateSubsectionToSectionDesktop = function () {
    // animate to the right position and update the data
    var width = parseFloat(getComputedStyle(this.$root, null).width.replace('px', ''))
    this.$root.style.position = 'absolute'
    this.$root.style.width = width
    this.$subsection.style.display = 'none'
    this.$section.style.marginRight = '63%'
    var sectionProperties

    if (this.isDesktop()) {
      var curated = this.$section.querySelector('.pane-inner.curated')
      if (curated) {
        curated.style.paddingLeft = '30px'
      }

      var alphabetical = this.$section.querySelector('.pane-inner.alphabetical')
      if (alphabetical) {
        alphabetical.style.paddingLeft = '96px'
      }

      sectionProperties = {
        width: '35%',
        marginLeft: '0%',
        marginRight: '40%'
      }
    } else {
      sectionProperties = {
        width: '30%',
        marginLeft: '0%',
        marginRight: '45%'
      }
    }
    this.setStyles(this.$section, sectionProperties)
    this.displayState = 'section'
    this.$module.classList.remove('subsection')
    this.$module.classList.add('section')
    this.$section.setAttribute('style', '')
    this.$section.querySelector('.pane-inner').setAttribute('style', '')
    this.$section.classList.add('with-sort')
    this.$root.setAttribute('style', '')
  }

  BrowseColumns.prototype.setStyles = function (el, properties) {
    for (var property in properties) {
      el.style[property] = properties[property]
    }
  }

  BrowseColumns.prototype.animateRootToSectionDesktop = function () {
    this.displayState = 'section'
    this.$module.classList.remove('subsection')
    this.$module.classList.add('section')
  }

  BrowseColumns.prototype.showSubsection = function (state) {
    this.setContentIdMetaTag(state.sectionData.content_id)
    this.setNavigationPageTypeMetaTag(state.sectionData.navigation_page_type)
    state.title = this.getTitle(state.slug)
    this.setTitle(state.title)
    this.$subsection.innerHTML = state.sectionData.html
    this.highlightSection('section', state.path)
    this.highlightSection('root', '/browse/' + state.section)
    this.updateBreadcrumbs(state)

    if (this.displayState !== 'subsection') {
      this.animateSectionToSubsectionDesktop()
    }
    this.$subsection.querySelector('.js-heading').focus()
  }

  BrowseColumns.prototype.animateSectionToSubsectionDesktop = function () {
    // animate to the right position and update the data
    var width = parseFloat(getComputedStyle(this.$root, null).width.replace('px', ''))
    this.$root.style.position = 'absolute'
    this.$root.style.width = width
    var sortOrder = this.$section.querySelector('.sort-order')
    if (sortOrder) {
      sortOrder.style.display = 'none'
    }

    var rightPanel = this.$section.querySelector('.pane-inner')
    if (rightPanel) {
      rightPanel.style.paddingLeft = 0
    }

    var sectionProperties

    if (this.isDesktop()) {
      sectionProperties = {
        width: '25%',
        marginLeft: '-13%',
        marginRight: '63%'
      }
    } else {
      sectionProperties = {
        width: '30%',
        marginLeft: '-18%',
        marginRight: '63%'
      }
    }

    this.setStyles(this.$section, sectionProperties)
    this.$module.classList.remove('section')
    this.$module.classList.add('subsection')
    this.$subsection.style.display = 'block'
    this.$section.classList.remove('with-sort')
    this.displayState = 'subsection'

    if (sortOrder) {
      sortOrder.setAttribute('style', '')
    }
    this.$section.setAttribute('style', '')
    this.$section.querySelector('.pane-inner').setAttribute('style', '')
    this.$root.setAttribute('style', '')
  }

  BrowseColumns.prototype.getTitle = function (slug) {
    var $link = this.$module.querySelector('a[href$="/browse/' + slug + '"]')
    var $heading = $link.querySelector('h3')
    if ($heading) {
      return $heading.textContent
    } else {
      return $link.textContent
    }
  }

  BrowseColumns.prototype.setTitle = function (title) {
    document.title = title + ' - GOV.UK'
  }

  BrowseColumns.prototype.setContentIdMetaTag = function (contentId) {
    var contentTag = document.querySelector('meta[name="govuk:content-id"]')
    if (contentTag) {
      contentTag.setAttribute('content', contentId)
    }
  }

  BrowseColumns.prototype.setNavigationPageTypeMetaTag = function (navigationPageType) {
    document.querySelector('meta[name="govuk:navigation-page-type"]').setAttribute('content', navigationPageType)
  }

  BrowseColumns.prototype.addLoading = function (el) {
    this.$module.setAttribute('aria-busy', 'true')
    el.classList.add('loading')
  }

  BrowseColumns.prototype.removeLoading = function () {
    this.$module.setAttribute('aria-busy', 'false')
    this.$module.querySelector('a.loading').classList.remove('loading')
  }

  BrowseColumns.prototype.highlightSection = function (section, slug) {
    var $section = this.$module.querySelector('#' + section)
    var selected = $section.querySelector('.active')
    if (selected) {
      selected.classList.remove('active')
    }
    this.$module.querySelector('a[href$="' + slug + '"]').parentNode.classList.add('active')
  }

  BrowseColumns.prototype.parsePathname = function (pathname) {
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
  }

  BrowseColumns.prototype.scrollToBrowse = function () {
    var $body = document.body
    var elTop = this.$module.getBoundingClientRect()
    elTop = elTop.top

    if ($body.scrollTop > elTop) {
      // $('body').animate({ scrollTop: elTop }, this.animateSpeed) // FIXME
    }
  }

  BrowseColumns.prototype.updateBreadcrumbs = function (state) {
    var tempDiv = document.createElement('div')
    tempDiv.innerHTML = state.sectionData.breadcrumbs
    var markup = tempDiv.querySelector('ol')
    this.$breadcrumbs.innerHTML = markup.outerHTML
  }

  BrowseColumns.prototype.trackPageview = function (state) {
    var sectionTitle = this.$section.querySelector('h1')
    sectionTitle = sectionTitle ? sectionTitle.textContent.toLowerCase() : 'browse'
    var navigationPageType = 'none'

    if (this.displayState === 'section') {
      navigationPageType = 'First Level Browse'
    } else if (this.displayState === 'subsection') {
      navigationPageType = 'Second Level Browse'
    }

    this.firePageview(state, sectionTitle, navigationPageType)
    this.firePageview(state, sectionTitle, navigationPageType, 'govuk')
  }

  BrowseColumns.prototype.firePageview = function (state, sectionTitle, navigationPageType, tracker) {
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

  Modules.BrowseColumns = BrowseColumns
})(window.GOVUK.Modules)
