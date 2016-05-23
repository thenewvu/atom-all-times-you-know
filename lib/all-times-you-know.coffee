AllTimesYouKnowView = require './all-times-you-know-view'
{CompositeDisposable} = require 'atom'

module.exports = AllTimesYouKnow =
  config:
    tags:
      title: 'Background tags'
      description: 'Seperated by commas with no space.'
      type: 'string'
      default: ''
    text:
      title: 'Background keywords'
      description: 'Optional included keywords'
      type: 'string'
      default: ''
    size:
      title: 'Size of backgrounds'
      type: 'string'
      description: 'Read https://www.flickr.com/services/api/misc.urls.html  '
      default: 'h'
      enum: ['s', 'q', 't', 'm', 'n', '-', 'z', 'c', 'b', 'h', 'k', 'o']
    sort:
      title: 'Sort order'
      type: 'string'
      description: 'Read https://www.flickr.com/services/api/flickr.photos.search.html  '
      default: 'relevance'
      enum: ['date-posted-asc', 'date-posted-desc', 'date-taken-asc', 'date-taken-desc', 'interestingness-desc', 'interestingness-asc', 'relevance']
    refreshRate:
      title: 'Refresh Rate'
      description: 'How often the background is refreshed (in seconds).'
      type: 'number'
      default: 120

  allTimesYouKnowView: null
  subscriptions: null

  activate: (state) ->
    @allTimesYouKnowView = new AllTimesYouKnowView(state.allTimesYouKnowViewState)
    document.body.appendChild @allTimesYouKnowView.getElement()

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'all-times-you-know:refresh': @allTimesYouKnowView.refresh
    @subscriptions.add atom.commands.add 'atom-workspace', 'all-times-you-know:stop-refresh': @allTimesYouKnowView.stopRefresh
    @subscriptions.add atom.commands.add 'atom-workspace', 'all-times-you-know:start-refresh': @allTimesYouKnowView.startRefresh

  deactivate: ->
    @subscriptions.dispose()
    @allTimesYouKnowView.destroy()

  serialize: ->
    allTimesYouKnowViewState: @allTimesYouKnowView.serialize()
