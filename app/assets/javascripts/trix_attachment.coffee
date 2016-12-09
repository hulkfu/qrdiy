$ ->
  HOST = "/publications/trix_attachment"

  document.addEventListener 'trix-attachment-add', (event) ->
    attachment = event.attachment
    if attachment.file
      return uploadAttachment(attachment)
    return

  document.addEventListener 'trix-attachment-remove', (event) ->
    attachment = event.attachment
    deleteAttachment attachment

  uploadAttachment = (attachment) ->
    file = attachment.file
    form = new FormData
    form.append 'Content-Type', file.type
    form.append 'file', file
    xhr = new XMLHttpRequest
    xhr.responseType = 'json'
    xhr.open "POST", HOST, true
    # 放入 CSRF
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));

    xhr.upload.onprogress = (event) ->
      progress = undefined
      progress = event.loaded / event.total * 100
      attachment.setUploadProgress progress

    xhr.onload = ->
      response = xhr.response
      if xhr.status == 200
        attachment.setAttributes
          publication_id: response.id
          url: response.url
          href: response.url

    xhr.send form

  deleteAttachment = (n) ->
    $.ajax
      type: 'DELETE'
      url: '/publications/' + n.attachment.attributes.values.publication_id
      cache: false
      contentType: false
      processData: false

  return
