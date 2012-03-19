module TaggableHelper
  # Inject the class methods to the object's class.
  def self.included(c)
    c.instance_eval do
      extend TaggableHelper::ClassMethods
    end
  end

  module ClassMethods
    def acts_as_taggable
      include Mongoid::Taggable
      include TaggableHelper::LocalInstanceMethods
      extend TaggableHelper::SingletonMethods
    end
  end

  # Singleton methods.
  module SingletonMethods
  end

  # Local instance methods.
  module LocalInstanceMethods
    def add_tag(tag)
      self.add_to_set(:tags_array, tag)
    end

    def tags_each
      (self.tags_array || []).each { |tag| yield tag }
    end
  end
end