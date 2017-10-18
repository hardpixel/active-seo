module ActiveSeo
  module Meta
    extend ActiveSupport::Concern

    included do
      # Include modules
      include ActiveDelegate

      # Set class attributes
      class_attribute :seo_config

      # Set class attibute defaults
      self.seo_config = ActiveSeo.config

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

      # Set validations
      def define_seo_validations
        validates :seo_title, length: { maximum: seo_config.title_limit }, allow_blank: true
        validates :seo_description, length: { maximum: seo_config.description_limit }, allow_blank: true
        validates :seo_keywords, length: { maximum: seo_config.keywords_limit }, allow_blank: true
      end
    end

    def seo_meta

    end
  end
end
