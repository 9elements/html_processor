module HtmlProcessor
  module Step

module Detag
  # This step removes all tags from the HTML, preserving content.
  # Block element tags are replaced with whitespace.
  #
  # If you need this, you will probably need to process HTML entities to UTF8 as well --
  # this is a step yet to be written (using https://github.com/threedaymonk/htmlentities)
  # Also, you may want to squish the result.

  def self.step_name
    :detag
  end

  BLOCK_TAGS = %w{address article aside blockquote center dir div dd details dl dt fieldset
    figcaption figure form footer frameset h1 h2 h3 h4 h5 h6 hr header hgroup
    isindex menu nav noframes noscript ol p pre section summary ul}
  BLOCK_TAGS_SELECTOR = BLOCK_TAGS.join(',')

  def self.call(fragment)
    fragment.css('br').each { |br| br.replace(' ') }
    fragment.css(BLOCK_TAGS_SELECTOR).each do |node|
      node.before ' '
      node.after ' '
    end
    fragment.inner_html = fragment.text
  end
end

  end
end
