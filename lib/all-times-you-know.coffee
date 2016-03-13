AllTimesYouKnowView = require './all-times-you-know-view'
{CompositeDisposable} = require 'atom'

module.exports = AllTimesYouKnow =
    config:
        topics:
            title: 'Background Topics'
            description: 'Seperated by commas with no space.'
            type: 'string'
            default: 'food'
        screenWidth:
            title: 'Screen Resolution Width'
            type: 'number'
            default: 1368
        screenHeight:
            title: 'Screen Resolution Height'
            type: 'number'
            default: 768
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
