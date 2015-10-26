ko.bindingHandlers.datemasked =
  init: (element, placeholder) ->
    ph =
      if gon.locale == 'ru'
        'дд-мм-гггг'
      else
        'dd-mm-yyyy'

    $(element).attr('placeholder', ph) if placeholder()

    $(element).inputmask 'dd-mm-yyyy',
      placeholder: '_'
      showMaskOnHover: false
