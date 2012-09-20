# -*- encoding: utf-8 -*-
class Item
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongo::Followable
  include TaggableHelper
  include BookmarkletHelper

  field :s, as: :source_site, type:String
  field :source_id, type: String
  field :title, type: String
  field :description, type: String
  field :product_rating, type: Float # overall product rating 
  field :price_low, type: Float # lowest price
  field :price_high, type: Float # highest price
  field :image, type: String # title picture
  # field :tags, type: Array # string[]
  field :category, type: String
  field :purchase_url, type: String
  field :root_share_id, type: BSON::ObjectId

  has_many :shares

  validates_presence_of :image, :purchase_url, :title, :category

  enable_tags_index!
  tags_index_group_by :category

  def self.in_categories_and_tags(categories, tags, page, per_page = 16)
    query = self.where(:category.in => categories)
    query = query.has_tags(tags) unless tags.blank?
    query.desc(:created_at).paginate(:page => page, :per_page => per_page)
  end

  def self.search(content, page, per_page = 16)
    item_tags = self.tags
    search_contents = []
    search_tags = []

    content.strip.split(/\s+/).each do |sub|
      if item_tags.include? sub
        search_tags << sub
      else
        search_contents << sub
      end
    end

    query = self.where(:title => /.*(#{search_contents.join "|"}).*/)
    query = query.has_tags(search_tags) unless search_tags.blank?
    [search_tags, query.paginate(:page => page, :per_page => per_page)]
  end

  def self.new_with_collector(collector)
    @item = Item.new({
      source_id: collector.item_id,
      source_site: collector.site,
      title: collector.title,
      image: collector.imgs.first,
      purchase_url: collector.purchase_url,
      category: collector.category
    })
    @item.shares << Share.new({
      source: collector.item_id,
      price: collector.price
    })

    return @item
  end

  def self.sync_data
    subscribed_items = all.select{|item| item.subscribed? }

    subscribed_items.each do |item|
      collector = Collector.new(item.purchase_url)
      next unless new_price = collector.price.try(:to_f)

      if item.price_low.nil? || item.price_low > new_price
        item.update_attributes(price_low: new_price)
      end

      item.subscribed_shares.each do |share|
        share.markdown_inform(new_price)
      end
    end
  end

  def subscribed_shares
    shares.select {|share| share.subscribed }
  end

  def subscribed?
    subscribed_shares.present?
  end

  def latest_price
    s = shares.desc(:create_at).select {|i| i.price}
    s.present? ? s.last.price : '暂无价格'
  end

  def root_share
    self.root_share_id.nil? ? nil : Share.find(self.root_share_id)
  end

  def with_any_same_tags
    self.class.tagged_with_any(self.tags_array)
  end

  def has_shared_by_user?(user)
    !self.share_by_user(user).nil?
  end

  def in_shares_num
    self.shares.by_type(Share::TYPE_SHARE).count
  end

  def in_wishes_num
    self.shares.by_type(Share::TYPE_WISH).count
  end

  def in_bags_num
    self.shares.by_type(Share::TYPE_BAG).count
  end

  def self.top_tags(category, num = 10)
    tags = self.tags_with_weight(category).sort_by { |k| -k[1] }
    tags.first(num).map { |t| t[0] }
  end
end
