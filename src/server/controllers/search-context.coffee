logger = require '../lib/logger'

SearchContext = require '../models/search-context'
ContextKeywords = require '../models/context-keywords'

searchContext = new SearchContext
ctxtKeywords = new ContextKeywords

exports.new = (req, res) ->
  searchContext.new(
    req.user.id,
    (searchContextId, err) ->
      if (err)
        logger.log('error', err)
      else
        res.send(
          'searchContextId': searchContextId
          'stageId': '1'
          'query': ''
          'contextKeywords': []
        )
  )

exports.sync = (req, res) ->
  sCtxtId = req.params.searchCtxtId
  stageId = req.params.stageId
  query = req.params.query

  searchContext.sync(
    req.user.id,
    sCtxtId,
    stageId,
    query,
    (sCtxt, err) ->
      if(err)
        logger.log('error', err)
      if not sCtxt
        res.redirect('/')
      else res.send sCtxt
    )

exports.advance = (req, res) ->
  sCtxtId = req.params.searchCtxtId
  query = req.params.query
  keywordIds = req.params.keywordIds.toString().split(':')

  ctxtKeywords.mapIdsToName(keywordIds, (map, err) ->
    searchContext.advance(
      req.user.id,
      sCtxtId,
      query,
      map,
      (stageId, err) ->
        if(err)
          logger.log('error', err)
        else res.send 'stageId': stageId
    )
  )

exports.summary = (req, res) ->
  sCtxtId = req.params.searchCtxtId
  stageId = req.params.stageId

  searchContext.detail(
    req.user.id,
    sCtxtId,
    stageId,
    (sCtxt, err) ->
      if(err)
        logger.log('error', err)
      else res.send sCtxt
  )

exports.addCtxtKeyword = (req, res) ->
  sCtxtId = req.params.searchCtxtId
  stageId = req.params.stageId
  keyword = req.params.keyid + ':' + req.params.keyword

  searchContext.addCtxtKeyword(
    req.user.id,
    sCtxtId,
    stageId,
    keyword,
    (result, err) ->
      if(err)
        logger.log('error', err)
        res.send persisted: false
      else res.send persisted: true
  )

exports.suggestCtxtKeywords = (req, res) ->
  res.send([{
              name: 'Physics'
              keyid: '12334SD45'
            },
            {
              name: 'Theory'
              keyid: '3J45JJRJ'
            },
            {
              name: 'Relativity'
              keyid: '23JJK45'
            },
            {
              name: 'Two body problem'
              keyid: '3495345'
            },
            {
              name: 'General Theory of Relativity'
              keyid: '346657'
            },
            {
              name: 'Minkowski matrix'
              keyid: '345345'
            },
            {
              name: "Dark Matter"
              keyid: '34534234'
            },
            {
              name: "Cosmology"
              keyid: '123689'
            },
            {
              name: "Germany"
              keyid: '245876'
            },
            {
              name: "Scientist"
              keyid: '2348456'
            },
            {
              name: "Nobel Prize"
              keyid: '23468'
            }
    ])

exports.suggestQuery = (req, res) ->
  query = req.params.query
  query += "asdf"
  setTimeout((() ->
    res.send({
      suggestion:  query
    })
  ), 400)