require 'html_processor/html'

require 'uri'

module HtmlProcessor
  module Step

module BasicSanitizing
  # An effort do provide server-side html5 sanitization.
  # This does NOT check nesting rules!
  # It does however remove tags and attributes known for security problems, as
  # far as the parser from https://github.com/Voog/wysihtml does this (we got
  # all of our inspiration from there).

  extend self
  def step_name
    :basic_sanitizing
  end

  # ATTN before copying any of these into another module, consider moving to HtmlProcessor::Html

  REMOVE_TAGS = %w{strike title area command iframe noframe bgsound basefont head object track wbr noscript svg input keygen meta isindex base video canvas applet spacer source frame del style device embed noembed xml param nextid audio col link script colgroup comment frameset}

  KNOWN_TAGS = %w{tr strike form rt code acronym br details h4 em title multicol figure xmp small area time dir bdi command ul progress dfn iframe figcaption a img rb footer noframes abbr u bgsound sup address basefont nav h1 head tbody dd s li td object div option select i track wbr fieldset big button noscript svg input table keygen h5 meta map isindex mark caption tfoot base video strong canvas output marquee b q applet span rp spacer source aside frame section body ol nobr html summary var del blockquote style device meter h3 textarea embed hgroup font tt noembed thead blink plaintext xml h6 param th legend hr label dl kbd listing dt nextid pre center audio datalist samp col article cite link script bdo menu colgroup ruby h2 ins p sub comment frameset optgroup header}

  ALLOWED_TAGS = KNOWN_TAGS - REMOVE_TAGS
  DISALLOWED_TAGS_XPATH = "descendant::*[not(#{  ALLOWED_TAGS.map { |tag| tag.prepend 'self::'}.join ' or '  })]"

  RENAME_TAGS = {
    "form" => "div",
    "rt" => "span",
    "acronym" => "span",
    "details" => "div",
    "multicol" => "div",
    "figure" => "div",
    "xmp" => "span",
    "small" => "span",
    "time" => "span",
    "dir" => "ul",
    "bdi" => "span",
    "progress" => "span",
    "dfn" => "span",
    "figcaption" => "div",
    "rb" => "span",
    "footer" => "div",
    "abbr" => "span",
    "sup" => "span",
    "address" => "div",
    "nav" => "div",
    "dd" => "div",
    "s" => "span",
    "option" => "span",
    "select" => "span",
    "fieldset" => "div",
    "big" => "span",
    "button" => "span",
    "map" => "div",
    "mark" => "span",
    "output" => "span",
    "marquee" => "span",
    "rp" => "span",
    "aside" => "div",
    "section" => "div",
    "body" => "div",
    "nobr" => "span",
    "html" => "div",
    "summary" => "span",
    "var" => "span",
    "meter" => "span",
    "textarea" => "span",
    "hgroup" => "div",
    "font" => "span",
    "tt" => "span",
    "blink" => "span",
    "plaintext" => "span",
    "legend" => "span",
    "label" => "span",
    "dl" => "div",
    "kbd" => "span",
    "listing" => "div",
    "dt" => "span",
    "center" => "div",
    "datalist" => "span",
    "samp" => "span",
    "article" => "div",
    "bdo" => "span",
    "menu" => "ul",
    "ruby" => "span",
    "ins" => "span",
    "sub" => "span",
    "optgroup" => "span",
    "header" => "div"
  }

  CHECK_NUMERICITY = {
    "img" => ["width", "height"],
    "td" => ["rowspan", "colspan"],
    "th" => ["rowspan", "colspan"]
  }

  URI_TAGS = Html.uri_tags

  ALLOWED_SCHEMES = %w{http https}

  def call(fragment)
    fragment.xpath(DISALLOWED_TAGS_XPATH).each(&:unlink)

    fragment.css(RENAME_TAGS.keys.join(', ')).each do |node|
      node.name = RENAME_TAGS[node.name]
    end

    fragment.css(CHECK_NUMERICITY.keys.join(', ')).each do |node|
      numeric_attrs = CHECK_NUMERICITY[node.name]
      node.attributes.values_at(*numeric_attrs).each do |attr_node|
        next unless attr_node
        attr_node.unlink unless /\A[0-9]+\Z/.match attr_node.value
      end
    end

    # remove url attributes with bad protocol schemes
    fragment.css(URI_TAGS.keys.join(', ')).each do |node|
      node.attributes.values_at(*URI_TAGS[node.name]).each do |attr_node|
        next unless attr_node
        value = attr_node.value

        scheme = URI(value).scheme rescue "failed to parse URI -> attr will be removed"
        if scheme
          attr_node.unlink unless ALLOWED_SCHEMES.include?(scheme)
        end
      end
    end
  end
end

  end
end
