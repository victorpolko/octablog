class SearchVM
  constructor: ->
    @koArticles = ko.observableArray []

$ ->
  ko.applyBindings new SearchVM, document.getElementById('search')
