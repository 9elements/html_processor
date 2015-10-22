require 'html_processor/html'

module HtmlProcessor
  module Step

module RemoveRelativeHrefs
  def self.step_name
    :remove_relative_hrefs
  end

  URI_TAGS = Html.uri_tags

  def self.call(fragment)
    fragment.css(URI_TAGS.keys.join(', ')).each do |node|
      node.attributes.values_at(*URI_TAGS[node.name]).each do |attr_node|
        next unless attr_node
        value = attr_node.value

        uri = URI(value) rescue URI('bogus') # rescue null object -> attr will be removed

        attr_node.unlink unless uri.host || uri.path.start_with?('/')
      end
    end
  end
end

  end
end
