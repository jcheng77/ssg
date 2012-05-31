class Item
  MARK_BYTE = 2

  include Mongoid::Document
  include Mongo::Followable
  include TaggableHelper

  field :source_id, type: String
  field :title, type: String
  field :description, type: String
  field :product_rating, type: Float # overall product rating 
  field :price_low, type: Float # lowest price
  field :price_high, type: Float # highest price
  field :image, type: String # title picture
  field :tags, type: Array # string[]
  field :purchase_url, type: String 
  field :root_share_id, type: BSON::ObjectId

  acts_as_taggable
  has_many :shares
  has_many :wishes
  has_many :bags
  has_one :category

  def root_share
    self.root_share_id.nil? ? nil : Share.find(self.root_share_id)
  end

  def with_any_same_tags
    self.class.tagged_with_any(self.tags_array)
  end

  def share_by_user(user)
    self.shares.where(user_id: user._id).first
  end

  def has_shared_by_user?(user)
    !self.share_by_user(user).nil?
  end

  def in_shares_num
    self.shares.count
  end

  def in_wishes_num
    share_ids = self.shares.all.map { |share| share._id }
    share_ids.blank? ? 0 : Wish.any_in(share_id: share_ids).count
  end

  def in_bags_num
    share_ids = self.shares.all.map { |share| share._id }
    share_ids.blank? ? 0 : Bag.any_in(share_id: share_ids).count
  end

  def self.top_tags
    tags = self.tags_with_weight.sort_by { |k| k[1] }
    tags.last(10)
  end

end
