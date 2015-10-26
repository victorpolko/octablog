ko.bindingHandlers.phonemasked =
  init: (element, placeholder) ->
    $(element).attr('placeholder', '+7(___)___-__-__') if placeholder()

    $(element).inputmask '+7(999)999-99-99',
      placeholder: '_'
      showMaskOnHover: false
