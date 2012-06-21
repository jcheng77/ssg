class Category

  include Mongoid::Document
  include Mongo::Followable
  include TaggableHelper

  field :cid, type: Integer
  field :cn, type: String

  belongs_to :item

end
