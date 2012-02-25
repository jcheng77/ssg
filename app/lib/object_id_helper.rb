module ObjectIdHelper
  MARK_POS = 4

  def mark_id!
    id = self[:_id]
    if !id
      id = BSON::ObjectId.new
    elsif id.data[MARK_POS]==self.class::MARK_BYTE
      return id
    end
    id.data[MARK_POS]=self.class::MARK_BYTE
    self[:_id] = id
  end
  
  def find_object(object_id)
    return nil if !object_id
    
    mark_byte = object_id.data[MARK_POS]
    
    case(mark_byte)
      when Choice::MARK_BYTE then return Choice.find object_id
      when Comment::MARK_BYTE then return Comment.find object_id
      when Item::MARK_BYTE then return Item.find object_id
      when Seller::MARK_BYTE then return Seller.find object_id
      when Share::MARK_BYTE then return Share.find object_id
      when User::MARK_BYTE then return User.find object_id
      else raise "Invalid ObjectId: #{object_id}"
    end
  end
  
=begin
db.choices.remove()
db.comments.remove()
db.follows.remove()
db.items.remove()
db.notifications.remove()
db.relations.remove()
db.shares.remove()
db.users.remove() 
=end
end

