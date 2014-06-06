$(document).on 'opened', '[data-reveal]', ->
  select = $('#select-emails')
  if select.length
    select.select2({tags:[], tokenSeparators: [",", "/n"]})
