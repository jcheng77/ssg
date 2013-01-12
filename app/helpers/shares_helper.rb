# encoding: utf-8

module SharesHelper
  def share_image_tag(share)
    html_title = html_class = ""
    if share.is_a?(Share)
    case share.share_type
      when Share::TYPE_WISH
        html_class = "captionme"
        html_title = "##{share.tags_array.first}"
      when Share::TYPE_BAG
        html_class = "captionme"
        html_title = "已购"
    end
    end
    if share.is_a?(Share)
      image_tag share.item.image, class: html_class, title: html_title, type: share.share_type
      else
      image_tag share.image, class: html_class, title: html_title 
    end
  end

  def share_image(share)
    if share.item.nil?
      share.image
    else
      share.item.image
    end
  end

  def share_title(share)
    if share.item.nil?
      ''
    else
      share.item.title
    end
  end

  def price_tag(price)
    if price == 0 || price.nil?
      '暂无价格'
    else
      number_to_currency(price,unit: '￥')
    end
  end
end
