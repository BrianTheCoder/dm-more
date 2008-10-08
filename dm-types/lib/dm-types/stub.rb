require 'iconv'

module DataMapper
  module Types
    class Stub < DataMapper::Type
      primitive String
      size 65535

      def self.load(value, property)
        value
      end

      def self.dump(value, property)
        if value.nil?
          nil
        elsif value.is_a?(String)
          Iconv.new('UTF-8//TRANSLIT//IGNORE', 'UTF-8').iconv(value.gsub(/[^\w\s\-\—]/,'').gsub(/[^\w]|[\_]/,' ').split.join('-').downcase).to_s
        else
          raise ArgumentError.new("+value+ must be nil or a String")
        end
      end

    end # class Permalink
  end # module Types
end # module DataMapper
