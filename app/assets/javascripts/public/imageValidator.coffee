$ ->
  if document.getElementById('image_input_validated')?
    document.querySelector('body').addEventListener 'change', (event) ->
      if event.target == document.getElementById('image_input_validated')
        utils.validateImage(event.target)
