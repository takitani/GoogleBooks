require 'book/item'

module GoogleBooks
  class Response < ActiveJob::Base
    include Enumerable
    include GlobalID::Identification

    def initialize(response)
      @response = response
    end

    # Returns nil if no records are returned. Otherwise, response returns
    # hash of generally unusable Google API specific data.
    def each(&block)
      return [] if total_items == 0
      @response['items'].each do |item|
        block.call(Item.new(item))
      end
    end

    # Total items returnable based on query, not total items in response
    # (which is throttled by maxResults)
    def total_items
      @response['totalItems'].to_i
    end

    @all = []
    def self.all; @all end

    def self.find(id)
      all.detect {|item| item.id.to_s == id.to_s }
    end

    def initialize
      self.class.all << self
    end

    def id
      object_id
    end

  end
end
