module ActiveSeo
  module Meta
    extend ActiveSupport::Concern

    included do
      # Include modules
      include ActiveDelegate

      # Set class attributes
      class_attribute :seo_config,      instance_predicate: false
      class_attribute :seo_meta_parser, instance_predicate: false

      # Set class attibute defaults
      self.seo_config = ActiveSeo.config

      # Has associations
      has_one :active_seo_metum, as: :seoable, class_name: 'ActiveSeo::Models::SeoMetum', autosave: true, dependent: :destroy

      # Delegate attributes
      delegate_attributes to: :active_seo_metum, prefix: 'seo', allow_nil: true

      # Add validations
      define_seo_validations
      before_validation { ActiveSeo::Helpers.sanitize_keywords(seo_keywords) if seo_keywords? }
    end

    class_methods do
      # Setup seo
      def seo_setup(options={})
        self.seo_config = seo_config.merge ActiveSeo::Config.new(options)
        define_seo_validations
      end

      # Set meta parser
      def seo_parser(parser)
        self.seo_meta_parser = parser
      end

      # Set validations
      def define_seo_validations
        validates :seo_title, length: { maximum: seo_config.title_limit }, allow_blank: true
        validates :seo_description, length: { maximum: seo_config.description_limit }, allow_blank: true
        validates :seo_keywords, length: { maximum: seo_config.keywords_limit }, allow_blank: true
      end
    end

    def seo_meta
      @seo_meta ||= ActiveSeo::SeoMeta.new(self).result
    end
  end
end
