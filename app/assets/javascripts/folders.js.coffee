jQuery ->
  $('tr[data-link]').click ->
    window.location = $(@).data('link')

  $(document).on 'ajax:error', '#new_folder',  (evt, xhr, status, error) ->
    $('.errors').removeClass('error')
    $(this).find('small.error').remove()

    if (xhr.status == 422)
      errors = $.parseJSON(xhr.responseText)
      $.each errors, (key, value) ->
        $('label[for=folder_name]').addClass('error')
        $('#folder_name')
          .addClass('error')
          .after("<small class='error medium input-text'>" + value + "</small>")
    $('#folder_name').focus()
