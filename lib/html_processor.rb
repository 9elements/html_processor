require "html_processor/version"
require "html_processor/processor"

module HtmlProcessor
  def self.create(*args)
    Processor.new(*args)
  end
end
