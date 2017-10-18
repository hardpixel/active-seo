module ActiveSeo
  module Meta
    extend ActiveSupport::Concern

    included do
      # Include modules
      include ActiveDelegate

      # Set class attributes
      class_attribute :seo_config, instance_predicate: false
      class_attribute :seo_meta_config, instance_predicate: false

      # Set class attibute defaults
      self.seo_config      = ActiveSeo.config
      self.seo_meta_config = ActiveSeo.model_config

      # Has associations
      has_one :seo_metum, as: :seoable, class_name: 'SeoMetum', autosave: true, dependent: :destroy

      # Delegate attributes
      delegate_attributes to: :seo_metum, prefix: 'seo', allow_nil: true

      # Add validations
      define_seo_validations
    end

    class_methods do
      def seo_setup(options={})
        self.seo_config = seo_config.merge ActiveSeo::Config.new(options)
        define_seo_validations
      end

      def seo_meta_setup(options={})
        ActiveSeo.model_setup do |model_config|
          model_config.title_field       = options[:title_field]
          model_config.description_field = options[:description_field]
        end

        self.seo_meta_config = ActiveSeo.model_config
      end

      # Set validations
      def define_seo_validations
        validates :seo_title, length: { maximum: seo_config.title_limit }, allow_blank: true
        validates :seo_description, length: { maximum: seo_config.description_limit }, allow_blank: true
        validates :seo_keywords, length: { maximum: seo_config.keywords_limit }, allow_blank: true
      end
    end

    # Set base seo meta
    def default_seo_meta
      defaults = Hashie::Mash.new

      defaults.title       = seo_title || self.try(seo_meta_config.title_field)
      defaults.description = seo_description || self.try(seo_meta_config.description_field)
      defaults.keywords    = seo_keywords
      defaults.noindex     = seo_noindex || false
      defaults.nofollow    = seo_nofollow || false
      defaults
    end

    def seo_meta
      default_seo_meta
    end
  end
end
