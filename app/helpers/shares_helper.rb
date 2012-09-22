# encoding: utf-8

module SharesHelper
  def share_image_tag(share)
    html_title = html_class = ""
    case share.share_type
      when Share::TYPE_WISH
        html_class = "captionme"
        html_title = "##{share.tags_array.first}"
      when Share::TYPE_BAG
        html_class = "captionme"
        html_title = "已购"
    end
    image_tag share.item.image, class: html_class, title: html_title
  end
end
