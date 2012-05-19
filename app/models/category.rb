class Category

  include Mongoid::Document
  include Mongo::Followable
  include TaggableHelper

  field :cid, type: Integer
  field :cn, type: String

  acts_as_taggable
  belongs_to :item

end
