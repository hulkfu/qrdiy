
##
# i18n
langMapping = {}

for key, value of Trix.config.lang
  selector = "button[title='#{value}'], input[value='#{value}'], input[placeholder='#{value}']"
  if element = Trix.config.toolbar.content.querySelector(selector)
    langMapping[key] = element

Trix.config.lang =
  bold: "粗体"
  italic: "斜体"
  strike: "删除线"
  link: "链接"
  underline: "下划线"
  unlink: "取消链接"
  urlPlaceholder: "请输入超级链接..."
  captionPlaceholder: "请输入一个标题..."
  captionPrompt: "添加一个标题..."
  heading1: "标题"
  quote: "引用"
  code: "代码"
  bullets: "列表"
  numbers: "数字列表"
  indent: "减少缩进"
  outdent: "增加缩进"
  undo: "撤销"
  redo: "重做"
  remove: "删除"

for key, element of langMapping
  value = Trix.config.lang[key]

  if element.hasAttribute("title")
    element.setAttribute("title", value)

  if element.hasAttribute("value")
    element.setAttribute("value", value)

  if element.hasAttribute("placeholder")
    element.setAttribute("placeholder", value)

  if element.textContent
    element.textContent = value

langMapping = null
