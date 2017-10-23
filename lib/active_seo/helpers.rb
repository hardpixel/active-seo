module ActiveSeo
  module Helpers
    include ActionView::Helpers::SanitizeHelper

    class << self
      # Generate an array of keywords
      def generate_keywords(text)
        return [] unless text

        keywords = text.to_s.scan(/\w+/)
        keywords = keywords.group_by { |item| item }
        keywords = Hash[keywords.sort_by { |_k, v| -v.size }]
        keywords = keywords.keys.select { |item| item.size > 3 }

        keywords.map(&:downcase)
      end

      def sanitize_keywords(text)
        text = strip_tags(text)
        text.scan(/\w+/).join(' ').downcase
      end

      # Strip tags
      def strip_tags(html)
        full_sanitizer.sanitize(html)
      end
    end
  end
end