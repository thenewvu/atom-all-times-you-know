{CompositeDisposable} = require 'atom'
request = require 'request'

class AllTimesYouKnowView

  constructor: (serializedState) ->
    # Create the background element
    @background = document.createElement('div')
    @background.classList.add('all-times-you-know')

    @tags = null
    @text = null
    @sort = null
    @pages = 0
    @page = 1
    @photos = []
    @current = -1
    @refresh()
    @startRefresh()

  refresh: =>
    tags = atom.config.get('all-times-you-know.tags')
    text = atom.config.get('all-times-you-know.text')
    sort = atom.config.get('all-times-you-know.sort')
    if tags != @tags or text != @text or sort != @sort or @current >= @photos.length
      @tags = tags
      @text = text
      @sort = sort
      @page = if @current >= @photos.length then (@page + 1) else 1
      if @tags
        url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=5d6a54435c9da0c091e94cf2232e94eb&tags=#{@tags}&sort=#{@sort}&media=photos&page=#{@page}&format=json&nojsoncallback=1"
      else
        url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=5d6a54435c9da0c091e94cf2232e94eb&text=#{@text}&sort=#{@sort}&media=photos&page=#{@page}&format=json&nojsoncallback=1"
      console.log url
      request url, (err, res, body) =>
        if res && res.statusCode == 200
          body = JSON.parse(body)
          console.log body
          @pages = body.photos.pages
          @photos = body.photos.photo
          @current = 0
        @refresh()

    else
      image = @photoToUrl(@photos[@current])
      console.log image
      request {url: image, encoding: null}, (err, res, body) =>
        if res && res.statusCode == 200
          contentType = res.headers["content-type"]
          base64 = new Buffer(body).toString('base64')
          data = "url(\"data:#{contentType};base64,#{base64}\")"
          @background.style.backgroundImage = data
        @current += 1

  stopRefresh: =>
    if @refreshInterval
      clearInterval @refreshInterval

  startRefresh: =>
    @stopRefresh()
    @refreshRate = atom.config.get('all-times-you-know.refreshRate') * 1000
    @refreshInterval = setInterval @refresh, @refreshRate

  photoToUrl: (photo) =>
    size = atom.config.get('all-times-you-know.size')
    return "https://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}_#{size}.jpg"

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @background.remove()

  getElement: ->
    @background

module.exports = AllTimesYouKnowView
