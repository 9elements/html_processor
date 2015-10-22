module HtmlProcessor
  module Step

module RemoveIds
  def self.step_name
    :remove_ids
  end

  def self.call(fragment)
    fragment.xpath('*//@id').each(&:unlink)
  end
end

  end
end
