module ActiveSeo
  class SeoMeta
    include ActionView::Helpers::SanitizeHelper
    include ActiveSeo::Helpers

    attr_accessor :record, :config

    # Initializer method
    def initialize(record, config)
      @record = record
      @config = config
    end

    # Set base seo meta
    def result
      data = methods.select { |m| m.to_s.starts_with? 'seo_' }
      data = data.map { |i| [i.to_s.sub('seo_', '').to_sym, send(i)] }

      Hash[data]
    end

    def seo_title
      attribute = :seo_title
      defaults  = [:title, :name]

      attribute_fallbacks_for(attribute, defaults, config.title_fallback)
    end

    def seo_description
      attribute = :seo_description
      defaults  = [:content, :description, :excerpt, :body]

      description = attribute_fallbacks_for(attribute, defaults, config.description_fallback)
      strip_tags(description)
    end

    def seo_keywords
      text = record.seo_keywords

      if text.blank? and config.generate_keywords
        text = seo_description
      end

      generate_keywords(text)
    end

    def attribute_fallbacks_for(attribute, defaults, fallback)
      candidates = [attribute]

      case fallback
      when TrueClass
        candidates.concat(defaults)
      when Array
        candidates.concat(fallback)
      end

      attribute_fallbacks(candidates)
    end

    def attribute_fallbacks(candidates)
      method = candidates.find { |item| record.try(item).present? }
      record.try method
    end
  end
end
