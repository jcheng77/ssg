class Item
  MARK_BYTE = 2

  include Mongoid::Document
  include Mongo::Followable
  include ObjectIdHelper
  include TaggableHelper

  after_initialize do |o|
    o.mark_id! # mark the _id with the mark byte
  end  

  field :title, type: String
  field :description, type: String
  field :product_rating, type: Float # overall product rating 
  field :price_low, type: Float # lowest price
  field :price_high, type: Float # highest price
  field :image, type: String # title picture
  field :tags, type: Array # string[]
  field :root_share_id, type: BSON::ObjectId

  acts_as_taggable
  has_many :shares

  def root_share
    Share.find(self.root_share_id)
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
    num = 0
    self.shares.all.each do |share|
      num += Wish.where(share_id: share._id).count
    end
    num
  end

  def in_bags_num
    num = 0
    self.shares.all.each do |share|
      num += Bag.where(share_id: share._id).count
    end
    num
  end
end
