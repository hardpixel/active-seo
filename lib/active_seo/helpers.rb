module ActiveSeo
  module Helpers
    include ActionView::Helpers::SanitizeHelper

    class << self
      def generate_keywords(text)
        return [] unless text

        keywords = text.to_s.scan(/\w+/)
        keywords = keywords.group_by { |item| item }
        keywords = Hash[keywords.sort_by { |_k, v| -v.size }]
        keywords = keywords.keys.select { |item| item.size > 1 }

        keywords.map(&:downcase)
      end

      def sanitize_keywords(text)
        text = strip_tags(text)
        text.scan(/\w+/).join(' ').downcase
      end

      def strip_tags(html)
        full_sanitizer.sanitize(html).gsub(/\s+/, ' ').strip
      end
    end
  end
end
