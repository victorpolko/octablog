$ ->
  if $('.js-image-form').length
    $.ajaxSettings.dataType = 'json' # Important!

    # В случае успеха обновляем все аватары на странице
    $('.js-image-form').on 'ajax:success', (e, data, status, xhr) ->
      $('.x-avatar').attr 'src', data.url

    # Иначе показываем ошибку
    .on 'ajax:error', (e, xhr, status, error) ->
      alert "#{ xhr.responseJSON.klass } #{ xhr.responseJSON.error.avatar }"
