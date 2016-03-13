{CompositeDisposable} = require 'atom'
request = require 'request'

class AllTimesYouKnowView

    constructor: (serializedState) ->
        # Create the background element
        @background = document.createElement('div')
        @background.classList.add('all-times-you-know')

        @refreshing = false
        @refresh()
        @startRefresh()

    refresh: =>
        return if @refreshing
        @refreshing = true

        topics = atom.config.get('all-times-you-know.topics')
        screenWidth = atom.config.get('all-times-you-know.screenWidth')
        screenHeight = atom.config.get('all-times-you-know.screenHeight')
        image = "http://loremflickr.com/#{screenWidth}/#{screenHeight}/#{topics}?#{Math.random()}"

        request {url: image, encoding: null}, (err, res, body) =>
            if res && res.statusCode == 200
                contentType = res.headers["content-type"]
                base64 = new Buffer(body).toString('base64')
                data = "url(\"data:#{contentType};base64,#{base64}\")"
                @background.style.backgroundImage = data

            @refreshing = false

    stopRefresh: =>
        if @refreshInterval
            clearInterval @refreshInterval

    startRefresh: =>
        @stopRefresh()
        @refreshRate = atom.config.get('all-times-you-know.refreshRate') * 1000
        @refreshInterval = setInterval @refresh, @refreshRate

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @background.remove()

    getElement: ->
        @background

module.exports = AllTimesYouKnowView
