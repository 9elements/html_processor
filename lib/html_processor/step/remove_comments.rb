module HtmlProcessor
  module Step

module RemoveComments
  def self.step_name
    :remove_comments
  end

  def self.call(fragment)
    fragment.xpath("*//comment()|comment()").each(&:unlink)
  end
end

  end
end

