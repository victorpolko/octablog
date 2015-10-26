class DeepStruct < OpenStruct
  def initialize(hash = nil)
    check_hash = lambda { |entry| entry.is_a?(Hash) ? self.class.new(entry) : entry }

    @table = {}
    @hash_table = {}

    hash.try(:each) do |key, val|
      if val.is_a?(Array)
        other = Array.new

        val.each do |entry|
          other.push check_hash.yield(entry)
        end

        val = other
      end

      @table[key.to_s.underscore.to_sym] = check_hash.yield(val)
      @hash_table[key.to_s.underscore.to_sym] = val
      new_ostruct_member(key)
    end
  end

  def to_h
    @hash_table
  end

  # Create a collections of DeepStruct from an array of hashes
  # @param [Array<Hash>|Hash] array
  # @return [Array<DeepStruct>]
  def self.collection(array)
    [array].flatten.map { |element| new(element) }
  end
end
