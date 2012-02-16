class Follow
  include Mongoid::Document
  
  field :user_id, type: BSON::ObjectId # the guy that followed by user_id
  field :following_id, type: BSON::ObjectId # the guy that followed by user_id
  field :nick_name, type: String # the nick name defined by user_id, for user_id's convenience 
  field :tags, type: Array # tags
  
  index :following_id
  index :user_id
end