module ActiveSeo
  class SeoMeta
    attr_accessor :record, :config, :context

    # Initializer method
    def initialize(record)
      @record  = record
      @config  = record.class.seo_config
      @context = contextualizer.new(record)
    end

    # Set base seo meta
    def result
      data = [:title, :description, :keywords, :noindex, :nofollow, :og, :twitter]
      Hash[data.map { |i| [i, send(i)] }]
    end

    def title
      attribute = localized_attribute(:seo_title)
      defaults  = localized_attributes(:title, :name)

      attribute_fallbacks_for(attribute, defaults, config.title_fallback)
    end

    def description
      attribute = localized_attribute(:seo_description)
      defaults  = localized_attributes(:content, :description, :excerpt, :body)

      attribute_fallbacks_for(attribute, defaults, config.description_fallback)
    end

    def keywords
      text = record.try localized_attribute(:seo_keywords)
      text = "#{title} #{description}" if generate_keywords?(text)

      helpers.generate_keywords(text)
    end

    def noindex
      record.seo_noindex || false
    end

    def nofollow
      record.seo_nofollow || false
    end

    def og
      @config.opengraph.merge(context.og_meta)
    end

    def twitter
      @config.twitter.merge(context.twitter_meta)
    end

    private

      def contextualizer
        "#{record.class.seo_context}".safe_constantize ||
        "#{record.class.name}Contextualizer".safe_constantize ||
        'ActiveSeo::Contextualizer'.constantize
      end

      def helpers
        ActiveSeo::Helpers
      end

      def localized?
        record.class.seo_locale_accessors?
      end

      def generate_keywords?(text=nil)
        config.generate_keywords and text.blank?
      end

      def localized_attribute(attr_name)
        localized_name = "#{attr_name}_#{I18n.locale}"
        localized? && record.respond_to?(localized_name) ? localized_name : attr_name
      end

      def localized_attributes(*attr_names)
        localized? ? attr_names.map { |a| localized_attribute(a) } : attr_names
      end

      def attribute_fallbacks_for(attribute, defaults, fallback)
        candidates = [attribute]

        case fallback
        when TrueClass
          candidates.concat(defaults)
        when Symbol
          candidates << fallback
        when Array
          candidates.concat(fallback)
        end

        attribute_fallbacks(candidates)
      end

      def attribute_fallbacks(candidates)
        method = candidates.find { |item| record.try(item).present? }
        helpers.strip_tags(record.try(method).to_s) unless method.nil?
      end
  end
end
