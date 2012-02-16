module VisibleToHelper
  VISIBLE_TO_SELF = '$' # nil = visible to all

  # return 'SELF' if it's visible to self
  def visible_to_self
    return VISIBLE_TO_SELF if visible_to && visible_to.length==1 && visible_to.include?(VISIBLE_TO_SELF)
  end

  # setter
  def visible_to_self=(v)
    self.visible_to = [VISIBLE_TO_SELF] if v==VISIBLE_TO_SELF
  end

  # visible_to, id->nick, and join them to create a string
  def visible_to_nick_str
    return '' if !visible_to || visible_to_self
    ary = Array.new
    visible_to.each do |uid|
      user = User.find(uid)
      ary << user.nick_name if user && !ary.include?(user.nick_name)
    end
    return ary.sort.join(',')
  end

  # visible_to, build array from comma seperated nicks 
  def visible_to_nick_str=(str)
    if str==VISIBLE_TO_SELF
      return self.visible_to = [VISIBLE_TO_SELF]
    end
    ary = Array.new
    str.split(%r{\s*,\s*}).each do |nick|
      user = User.first(conditions: {nick_name: nick})
      ary << user._id if user
    end
    self.visible_to = ary
  end
  
  # check if this share is visible ot given user
  def visible_to?(user)
    return self.user==user || !self.visible_to || self.visible_to.include?(user._id)
  end
end

