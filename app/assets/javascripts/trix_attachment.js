(function() {
  var createStorageKey, host, uploadAttachment;

  document.addEventListener("trix-attachment-add", function(event) {
    var attachment;
    attachment = event.attachment;
    if (attachment.file) {
      return uploadAttachment(attachment);
    }
  });

  host = "/publications/trix_attachment";

  uploadAttachment = function(attachment) {
    var file, form, key, xhr;
    file = attachment.file;
    key = createStorageKey(file);
    form = new FormData;
    form.append("key", key);
    form.append("Content-Type", file.type);
    form.append("file", file);
    xhr = new XMLHttpRequest;
    xhr.open("POST", host, true);
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));  // 放入 CSRF
    xhr.upload.onprogress = function(event) {
      var progress;
      progress = event.loaded / event.total * 100;
      return attachment.setUploadProgress(progress);
    };
    xhr.onload = function() {
      var href, url;
      if (xhr.status === 200) {
        url = href = JSON.parse(xhr.response).url;
        console.log(url)
        return attachment.setAttributes({
          url: url,
          href: href
        });
      }
    };
    return xhr.send(form);
  };

  createStorageKey = function(file) {
    var date, day, time;
    date = new Date();
    day = date.toISOString().slice(0, 10);
    time = date.getTime();
    return "tmp/" + day + "/" + time + "-" + file.name;
  };

}).call(this);
