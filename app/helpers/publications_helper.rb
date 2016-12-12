module PublicationsHelper
  def quote_content(content, opts={})
    if content.present?
      content_tag(:div, class: "quote-content") do
        fa_icon("quote-left") + \
          content_tag(:span, content, opts) \
          + fa_icon("quote-right")
      end
    end
  end
end
