require "nokogiri"

require "html_processor/step"

module HtmlProcessor
  class Processor
    def initialize(*steps)
      @steps = steps.map(&Step.method(:to_step)).freeze
    end

    def call(text)
      fragment = parse_to_fragment(text)

      @steps.each do |step|
        step.call(fragment)
      end

      fragment.inner_html
    end

    private

    def parse_to_fragment(html)
      # I would like to use Nokogiri::HTML.fragment, but it does not let me pass parse options.
      # Code below basically taken from DocumentFragment#initialize

      # Surprizingly, this approach already makes ID collision warnings disappear, even though
      # it should use the same parsing options as Nokogiri::HTML.fragment(html).

      temp_doc = Nokogiri::HTML.parse("<html><body>#{html}", nil, nil, Nokogiri::XML::ParseOptions::DEFAULT_HTML)
      result = Nokogiri::HTML::DocumentFragment.new(temp_doc) # takes encoding from document, not content
      temp_doc.xpath('/html/body/node()').each { |child| child.parent = result }
      result
    end
  end
end
