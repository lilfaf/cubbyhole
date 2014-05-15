jQuery ->
  $(document).on 'opened', '[data-reveal]', ->
    $("#s3upload").S3Uploader
      remove_completed_progress_bar: false
