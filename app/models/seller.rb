class Seller
  MARK_BYTE = 4
  
  include Mongoid::Document
  include ObjectIdHelper

  after_initialize do |o|
    o.mark_id! # mark the _id with the mark byte
  end  

  field :name, type: BSON::ObjectId # the guy who follows follow
  field :image, type: String # url of the image
  field :source, type: String # source id of the shop, e.g. tbstore:13123, 360buy, vancl
  field :service_rating, type: Float # overall service rating 
  field :tags, type: Array # tags

  has_many :shares
  
  # comments
  def comments
    Comment.where(object_id_type: self._id)
  end
end