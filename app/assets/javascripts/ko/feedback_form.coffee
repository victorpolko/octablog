class FeedbackFormVM
  constructor: ->
    @koEnabled = ko.observable(false)
    @enable = =>
      @koEnabled(true)
      $('body, html').scrollWithSpeed $('[name="footer"]'), 1000
      $('#feedback_company').focus()

    @koCompany = ko.observable().extend
      required: true
      minLength: 4
    @koContact = ko.observable().extend
      required: true
      minLength: 4
    @koPhone = ko.observable().extend
      required: true
      pattern:
        message: ko.validation.rules.pattern.message
        params: /^\+7\(\d{3}\)\d{3}\-\d{2}\-\d{2}$/
    @koEmail = ko.observable().extend
      email: true
    @koCountry = ko.observable().extend
      required: true
      minLength: 4
    @koComment = ko.observable().extend
      required: true
      minLength: 10

    @errors = ko.validation.group(@)

    @submit = =>
      if @errors().length == 0 then true else @errors.showAllMessages()

$ ->
  ko.applyBindings new FeedbackFormVM, document.getElementById('footer')
