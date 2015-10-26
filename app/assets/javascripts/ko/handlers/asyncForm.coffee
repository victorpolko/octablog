DEBOUNCE_DELAY = 500

ko.bindingHandlers.asyncForm =
  init: (form, koValueAccessor, allBindings) ->
    $(form).find('input, select').on 'change', ->
      if document.readyState == 'complete'
        do _.debounce =>
          $.ajax
            type: 'get'
            url: $(@).attr('action')
            dataType: 'json'
            data: $(@).serialize()

            success: (data) ->
              koValueAccessor()(data)

            error: (data, text, error) ->
              console.warn "Something went wrong: #{ error } : #{ text }"

        , DEBOUNCE_DELAY

    $(form).find('input, select').on 'keyup', ->
      if document.readyState == 'complete'
        $.ajax
          type: 'get'
          url: $(@).attr('action')
          dataType: 'json'
          data: $(@).serialize()

          success: (data) ->
            koValueAccessor()(data)

          error: (data, text, error) ->
            console.warn "Something went wrong: #{ error } : #{ text }"

    setTimeout ->
      $(form).find('input').trigger('change')
    , 200
