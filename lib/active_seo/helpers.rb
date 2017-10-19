module ActiveSeo
  module Helpers
    # Generate an array of keywords
    def generate_keywords(text)
      text     = strip_tags(text)
      keywords = text.scan(/\w+/)
      keywords = keywords.group_by { |item| item }
      keywords = Hash[keywords.sort_by { |_k, v| -v.size }]
      keywords = keywords.keys.select { |item| item.size > 3 }
      keywords.map(&:downcase)
    end
  end
end
