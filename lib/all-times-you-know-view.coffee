{CompositeDisposable} = require 'atom'
request = require 'request'

class AllTimesYouKnowView

    constructor: (serializedState) ->
        # Create the background element
        @background = document.createElement('div')
        @background.classList.add('all-times-you-know')

        @refresh()
        @startRefresh()

    refresh: =>
        @topics = atom.config.get('all-times-you-know.topics')
        @screenWidth = atom.config.get('all-times-you-know.screenWidth')
        @screenHeight = atom.config.get('all-times-you-know.screenHeight')
        @image = "http://loremflickr.com/#{@screenWidth}/#{@screenHeight}/#{@topics}?#{Math.random()}"
        @background.style.backgroundImage = 'url(' + @image + ')'

    stopRefresh: =>
        clearInterval @refreshInterval

    startRefresh: =>
        @refreshRate = atom.config.get('all-times-you-know.refreshRate')
        @refreshInterval = setInterval @refresh, @refreshRate

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @background.remove()

    getElement: ->
        @background

module.exports = AllTimesYouKnowView
