class Bag
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :share_id, type: BSON::ObjectId

  belongs_to :user

  def share
    Share.find self.share_id
  end
end