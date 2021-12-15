//= require govuk_publishing_components/vendor/polyfills/closest
window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function BrowseColumns ($module) {
    this.$module = $module
  }

  BrowseColumns.prototype.init = function () {
    if (!GOVUK.support.history()) return
    if (window.screen.width < 640) return // don't do JS on mobile

    this.$root = this.$module.querySelector('#root')
    this.$section = this.$module.querySelector('#section')
    this.$subsection = this.$module.querySelector('#subsection')
    this.$breadcrumbs = document.querySelector('.gem-c-breadcrumbs')

    this.displayState = this.$module.getAttribute('data-state')
    if (typeof this.displayState === 'undefined') {
      this.displayState = 'root'
    }

    this._cache = {}
    this.lastState = this.parsePathname(window.location.pathname)

    this.$module.addEventListener('click', this.navigate.bind(this))
    window.addEventListener('popstate', this.popState.bind(this))
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
      this.showBanner(state.slug)
    }
  }

  BrowseColumns.prototype.getSectionData = function (state, poppingState) {
    var cacheForSlug = this.sectionCache(state.slug)

    if (typeof state.sectionData !== 'undefined') {
      this.handleResponse(state.sectionData, state, poppingState)
    } else if (typeof cacheForSlug !== 'undefined') {
      this.handleResponse(cacheForSlug, state, poppingState)
    } else {
      var done = function (e) {
        if (xhr.readyState === 4 && xhr.status === 200) {
          var data = JSON.parse(e.target.response)
          this.sectionCache(state.slug, data)
          this.handleResponse(data, state)
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
    var state = e.state
    if (!state) { // state will be null if there was no state set
      state = this.parsePathname(window.location.pathname)
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
      this.getSectionData(sectionState, true)
      this.loadSectionFromState(sectionState, true)
    }
    this.loadSectionFromState(state, true)
  }

  BrowseColumns.prototype.loadSectionFromState = function (state, poppingState) {
    if (state.subsection) {
      this.showSubsection(state)
    } else {
      this.showSection(state)
    }

    if (typeof poppingState === 'undefined') {
      history.pushState(state, '', state.path)
      this.trackPageview(state)
    }
  }

  BrowseColumns.prototype.showRoot = function () {
    this.$section.innerHTML = ''
    this.displayState = 'root'
  }

  BrowseColumns.prototype.showSection = function (state) {
    this.setContentIdMetaTag(state.sectionData.content_id)
    this.setNavigationPageTypeMetaTag(state.sectionData.navigation_page_type)
    state.title = this.getTitle(state.slug)
    this.setTitle(state.title)
    this.$section.innerHTML = state.sectionData.html

    this.highlightSection('root', state.path)
    this.updateBreadcrumbs(state)

    if (this.displayState === 'subsection') {
      this.changeColumnVisibility(1)
    } else {
      this.changeColumnVisibility(2)
    }
    this.$section.querySelector('.js-heading').focus()
  }

  BrowseColumns.prototype.changeColumnVisibility = function (columns) {
    if (columns === 3) {
      this.$module.classList.remove('browse--two-columns')
      this.$module.classList.add('browse--three-columns')
    } else if (columns === 2) {
      this.$module.classList.add('browse--two-columns')
      this.$module.classList.remove('browse--three-columns')
    } else {
      this.$module.classList.remove('browse--two-columns')
      this.$module.classList.remove('browse--three-columns')
    }
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

    this.changeColumnVisibility(3)
    this.showBanner(state.slug)
    this.$subsection.querySelector('.js-heading').focus()
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
    var meta = document.querySelector('meta[name="govuk:navigation-page-type"]')
    if (meta) {
      meta.setAttribute('content', navigationPageType)
    }
  }

  BrowseColumns.prototype.addLoading = function (el) {
    this.$module.setAttribute('aria-busy', 'true')
    el.classList.add('loading')
  }

  BrowseColumns.prototype.removeLoading = function () {
    this.$module.setAttribute('aria-busy', 'false')
    var loading = this.$module.querySelector('a.loading')
    if (loading) {
      loading.classList.remove('loading')
    }
  }

  BrowseColumns.prototype.highlightSection = function (section, slug) {
    var $section = this.$module.querySelector('#' + section)
    var selected = $section.querySelector('.browse__link--active')
    if (selected) {
      selected.classList.remove('browse__link--active')
      selected.classList.add('browse__link--inactive')
    }
    var link = this.$module.querySelector('a[href$="' + slug + '"]')
    link.classList.add('browse__link--active')
    link.classList.remove('browse__link--inactive')
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

  BrowseColumns.prototype.showBanner = function (slug) {
    var topicSlugs = [
      'benefits/manage-your-benefit',
      'benefits/looking-for-work',
      'benefits/unable-to-work',
      'benefits/families',
      'benefits/disability',
      'benefits/help-for-carers',
      'benefits/low-income',
      'benefits/bereavement',
      'business/business-tax',
      'business/limited-company',
      'tax/capital-gains',
      'tax/court-claims-debt-bankruptcy',
      'tax/dealing-with-hmrc',
      'tax/income-tax',
      'tax/inheritance-tax',
      'tax/national-insurance',
      'tax/self-assessment',
      'tax/vat'
    ]
    var banner = document.getElementsByClassName('gem-c-intervention')

    if (banner.length > 0) {
      banner[0].hidden = !topicSlugs.some(function (topicSlug) {
        return slug === topicSlug
      })
    }
  }

  Modules.BrowseColumns = BrowseColumns
})(window.GOVUK.Modules)
