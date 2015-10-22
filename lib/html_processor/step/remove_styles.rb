module HtmlProcessor
  module Step

module RemoveStyles
  def self.step_name
    :remove_styles
  end

  def self.call(fragment)
    fragment.xpath('descendant::*/attribute::class').each(&:unlink)
    fragment.xpath('descendant::*/attribute::style').each(&:unlink)
  end
end

  end
end
