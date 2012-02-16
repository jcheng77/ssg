class Item
  MARK_BYTE = 2

  include Mongoid::Document
  include ObjectIdHelper

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

  has_many :shares
  
  # comments
  def comments
    Comment.where(object_id: self._id)
  end
  
  # likes
  def likes
    all = Array.new
    self.shares.each do |share|
      shares.likes.each do |item|
        all << item
      end
    end
    return all
  end
  
  # wishes
  def wishes
    all = Array.new
    self.shares.each do |share|
      shares.wishes.each do |item|
        all << item
      end
    end
    return all
  end
  
  # recommends
  def recommends
    all = Array.new
    self.shares.each do |share|
      shares.recommends.each do |item|
        all << item
      end
    end
    return all
  end

  
  def get_share(user_id)
    if(!self.shares)
      self.shares=Array.new
    end
    self.shares.each do |s|
      if s.user_id == user_id
        return s
      end
    end
    return Share.new
  end
  
  def add_share(share)
    if(!self.shares)
      self.shares=Array.new
    end
    self.shares.each {|s| self.shares.delete (s) if s.user_id == share.user_id}
    self.shares << share
  end
  
  #before_save { |record| record.shares.each {|s| record.shares.delete(s) if !s.user_id } }
end
