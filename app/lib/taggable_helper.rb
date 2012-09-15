module TaggableHelper
  def self.included(base)
    # create fields for tags and index it
    base.field :tags_array, :type => Array, :default => []
    base.index [['tags_array', Mongo::ASCENDING]]

    # add callback to save tags index
    base.after_save do |document|
      if document.tags_array_changed
        document.class.save_tags_index!
        document.tags_array_changed = false
      end
    end

    # extend model
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.send :attr_accessor, :tags_array_changed

    # disable index as default
    base.disable_tags_index!
    base.tags_index_group_by 'default'
  end

  module ClassMethods
    # returns an array of distinct ordered list of tags defined in all documents
    def tagged_with(tag)
      self.any_in(:tags_array => [tag])
    end

    def tagged_with_all(*tags)
      self.all_in(:tags_array => tags.flatten)
    end

    def tagged_with_any(*tags)
      self.any_in(:tags_array => tags.flatten)
    end

    def tags
      tags_index_collection.master.find.to_a.map { |r| r["_id"] }
    end

    # retrieve the list of tags with weight(i.e. count), this is useful for
    # create tags index
    def tags_with_weight(group = nil)
      hash = {}
      array = tags_index_collection.master.find.to_a
      array.select! { |v| v["value"].key? group } unless group.blank?
      array.each do |r|
        sum = r["value"].values.inject { |total, x| total + x }
        hash[r["_id"]] = sum
      end
      hash
    end

    def disable_tags_index!
      @do_tags_index = false
    end

    def enable_tags_index!
      @do_tags_index = true
    end

    def tags_index_group_by(value)
      @tags_index_group = value
    end

    def tags_separator(separator = nil)
      @tags_separator = separator if separator
      @tags_separator || ' '
    end

    def tags_index_collection_name
      "#{collection_name}_tags_index"
    end

    def tags_index_collection
      @@tags_index_collection ||= Mongoid::Collection.new(self, tags_index_collection_name)
    end

    def save_tags_index!
      return unless @do_tags_index

      map = "function() {
        if (!this.tags_array) {
          return;
        }

        for (i in this.tags_array) {
          var hash = {}
          if ('#{@tags_index_group}' == 'default') {
            hash['default'] = 1
          } else {
            hash[this.#{@tags_index_group}] = 1
          }
          emit(this.tags_array[i], hash);
        }
      }"

      reduce = "function(key, emits) {
        var total = {};

        for (i in emits) {
          for (val in emits[i]) {
            if (total[val] == null) {
              total[val] = emits[i][val]
            } else {
              total[val] += emits[i][val]
            }
          }
        }

        return total;
      }"

      self.collection.master.map_reduce(map, reduce, :out => tags_index_collection_name)
    end
  end

  module InstanceMethods
    def tags
      (tags_array || []).join(self.class.tags_separator)
    end

    def tags=(tags)
      self.tags_array = tags.split(self.class.tags_separator).map(&:strip).reject(&:blank?)
      @tags_array_changed = true
    end

    def add_tag(tag)
      self.add_to_set(:tags_array, tag)
      self.class.save_tags_index!
    end

    def clear_tags
      self.update_attribute(:tags_array, [])
    end

    def tags_each
      (self.tags_array || []).each { |tag| yield tag }
    end
  end
end
