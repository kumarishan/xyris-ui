define [
  'jquery'
  'config'
  'backbone'
  'models/base/model'
  'views/base/view'
  'text!views/templates/search-context-page.hbs'
], ($,
    config,
    Backbone,
    Model,
    View,
    template) ->

  'use strict'

  class SearchContextPageView extends View
    template: template
    tagName: 'div'
    id: 'search-context-page'
    className: 'twelve columns container'
    containerMethod: 'html'

    regions:
      '#search-context-query': 'searchContextQuery'
      '#context-keyword-suggest': 'contextKeywordsSuggest'

    initialize: ->
      super
      @searchContextId = @options.newSearchContext.searchContextId
      @stageId = @options.newSearchContext.stageId

    attach: ->
      super

      @subscribeEvent 'ctxtkeyword:selected', (attributes) =>
        @publishEvent 'searchContext:persistContextKeyword', attributes, (success) =>
          if !success
            return
          html = [
            "<a class='sc-sum-keywords not-persisted' id='keyword-",
            attributes.keyid,
            "'>",
            attributes.keyword,
            "</a>"
          ].join('')
          @$el.find('#search-context-keywords').append(html)

      @subscribeEvent 'searchContext:contextKeywordPersisted', (keyid) =>
        @$el.find('#keyword-' + keyid).removeClass('not-persisted')

      @subscribeEvent 'searchctxt:queryEntered', (attributes) =>
        if attributes.query == ""
          @$("#search-hint").show()
          @$("#search-context-suggest").hide()
          @$('.web a').attr('href', '#')
          @$('.rsrchart a').attr('href', '#')
          @$('.docs a').attr('href', '#')
        else
          @$("#search-hint").hide()
          @$("#search-context-suggest").show()

          query = encodeURIComponent(attributes.query)
          @$('.web a').attr('href',
                            '/search/web/' +
                            @searchContextId + '/' +
                            @stageId + '/' + query)

          @$('.rsrchart a').attr('href',
                                 '/search/rsrchart/' +
                                 @searchContextId + '/' +
                                 @stageId + '/' + query)

          @$('.docs a').attr('href',
                             '/search/docs/' +
                             @searchContextId + '/' +
                             @stageId + '/' + query)