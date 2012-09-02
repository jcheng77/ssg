class Invitation
  include Mongoid::Document

  field :code, type:String
  field :used, type:Integer, default: 0

  belongs_to :user

  index :code, unique: true

  def self.generate
    codes = Array.new
    500.times { codes << { :code => (0...16).map{65.+(rand(25)).chr}.join , :used => 0 } }
    self.collection.insert(codes)
  end
end
