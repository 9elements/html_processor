module HtmlProcessor
  module Step

module RemoveImgAlt
  def self.step_name
    :remove_img_alt
  end

  def self.call(fragment)
    fragment.xpath('descendant::img/attribute::alt').each(&:unlink)
  end
end

  end
end
