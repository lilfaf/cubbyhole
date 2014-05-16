jQuery ->
  $(document).on 'opened', '[data-reveal]', ->
    $("#s3upload").S3Uploader
      remove_completed_progress_bar: false


  # Subscribe to websocket events
  dispatcher = new WebSocketRails('localhost:3000/websocket')
  channel = dispatcher.subscribe('main_channel')

  dispatcher.on_open = (data) ->
    console.log('Connection has been established: ', data)

  channel.bind 'picture_processed', (data) ->
    $("#asset-#{data.id} td:first-child a img").attr('src', data.url)
