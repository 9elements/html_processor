module HtmlProcessor
  module Html
    # Staticly encodes all "knowledge" about HTML used in the gem

    extend self

    # returns hash: tag_name => [uri attributes...]
    def uri_tags
      {
        "a" => "href",
        "img" => "src",
        "q" => "cite",
        "blockquote" => "cite"
      }
    end
  end
end
