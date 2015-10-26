ko.validation.init
  registerExtenders: true
  messagesOnModified: true
  insertMessages: false
  parseInputAttributes: true
  messageTemplate: null
, true

$ ->
  ko.validation.locale('ru-RU') if gon.locale == 'ru'
