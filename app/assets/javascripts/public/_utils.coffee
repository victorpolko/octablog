class Utils
  constructor: () ->
    # Validate uploaded images
    @validateImage = (fileInput) ->
      file = fileInput.files[0]

      # Check files being uploaded: name and size (< 10 MB)
      if !file.name.match(/\.(jpg|jpeg|png|bmp|gif)$/i) || (file.size > 10 * (1024 * 1024) )
        fileInput.value = ''
        alert "File is not supportable\nФайл не соответсвует требованиям"
        fileInput.focus()

    # Fire event in a jQuery-like way
    @fireEvent = (eventName, domElement) ->
      if document.createEvent
        event = document.createEvent('HTMLEvents')
        event.initEvent(eventName, true, true)
        event.eventName = eventName
        domElement.dispatchEvent event

      # IE
      else if document.createEventObject
        event = document.createEventObject()
        event.eventType = eventName
        event.eventName = eventName
        domElement.fireEvent("on #{ event.eventType }", event)

    @setStorageItem = (name, value) ->
      if typeof(Storage) != 'undefined'
        localStorage.setItem(name, value)
      else
        console.warn 'localStorage is not supported by your browser. Some small features will not work.'
        false

    @getStorageItem = (name) ->
      if typeof(Storage) != 'undefined'
        localStorage.getItem(name)
      else
        console.warn 'localStorage is not supported by your browser. Some small features will not work.'
        false

window.utils = new Utils
