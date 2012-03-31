class Wish
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include TaggableHelper

  field :share_id, type: BSON::ObjectId

  acts_as_taggable
  belongs_to :user

  def share
    Share.find self.share_id
  end
end