class Status
  include Mongoid::Document

  field :n, as: :last_since_id, type:Integer
end
