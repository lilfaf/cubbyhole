jQuery ->
  $('#fileupload').fileupload
    add: (e, data) ->
      data.submit()
