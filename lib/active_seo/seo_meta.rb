module ActiveSeo
  class SeoMeta
    include ActiveSeo::Helpers

    attr_accessor :record, :config, :opengraph, :twitter

    # Initializer method
    def initialize(record, config)
      @record    = record
      @config    = config
      @opengraph = config.opengraph
      @twitter   = config.twitter
    end

    # Set base seo meta
    def result
      data = [:title, :description, :keywords, :noindex, :nofollow, :og, :twitter]
      Hash[data.map { |i| [i, send(i)] }]
    end

    def title
      attribute = :seo_title
      defaults  = [:title, :name]

      attribute_fallbacks_for(attribute, defaults, config.title_fallback)
    end

    def description
      attribute = :seo_description
      defaults  = [:content, :description, :excerpt, :body]

      attribute_fallbacks_for(attribute, defaults, config.description_fallback)
    end

    def keywords
      text = record.try :seo_keywords
      text = "#{title} #{description}" if generate_keywords?(text)

      helpers.generate_keywords(text)
    end

    def noindex
      record.seo_noindex || false
    end

    def nofollow
      record.seo_noindex || false
    end

    def og
    end

    def twitter
    end

    private

      def helpers
        ActiveSeo::Helpers
      end

      def generate_keywords?(text=nil)
        config.generate_keywords and text.blank?
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
        helpers.strip_tags(record.try(method).to_s) unless method.nil?
      end
  end
end
