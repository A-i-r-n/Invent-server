module ActiveSupport::JSON::Encoding
  class << self
    # def escape(string)
    #   if string.respond_to?(:force_encoding)
    #     string = string.encode(::Encoding::UTF_8, :undef => :replace).force_encoding(::Encoding::BINARY)
    #   end
    #   json = string.gsub(escape_regex) { |s| ESCAPED_CHARS[s] }
    #   json = %("#{json}")
    #   json.force_encoding(::Encoding::UTF_8) if json.respond_to?(:force_encoding)
    #   json
    # end
    def escape(string)
      if string.respond_to?(:force_encoding)
        string = string.encode(::Encoding::UTF_8, :undef => :replace).force_encoding(::Encoding::BINARY)
      end
      json = string.
          gsub(escape_regex) { |s| ESCAPED_CHARS[s] }.
          gsub(/([\xC0-\xDF][\x80-\xBF]|
           [\xE0-\xEF][\x80-\xBF]{2}|
           [\xF0-\xF7][\x80-\xBF]{3})+/nx) { |s|
        s.unpack("U*").pack("n*").unpack("H*")[0].gsub(/.{4}/n, '\\\\u\&')
      }
      json = %("#{json}")
      json.force_encoding(::Encoding::UTF_8) if json.respond_to?(:force_encoding)
      json
    end
  end
end

module ActiveSupport
  class TimeWithZone
    def as_json(options = nil)
      if ActiveSupport::JSON::Encoding.use_standard_json_time_format
        xmlschema
      else
        %(#{time.strftime("%Y-%m-%d %H:%M:%S")}) #{formatted_offset(false)}
      end
    end
  end
end