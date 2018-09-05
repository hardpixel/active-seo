module ActiveSeo
  module Meta
    extend ActiveSupport::Concern

    included do
      # Include modules
      include ActiveDelegate

      # Set class attributes
      class_attribute :seo_config, instance_predicate: false
      class_attribute :seo_context, instance_predicate: false

      # Set class attibute defaults
      self.seo_config = ActiveSeo.config

      # Has associations
      has_one :seo_metum, as: :seoable, class_name: seo_class_name, autosave: true, dependent: :destroy

      # Delegate attributes
      delegate_attributes to: :seo_metum, prefix: 'seo', allow_nil: true, localized: seo_locale_accessors?

      # Add validations
      define_seo_validations

      # Action callbacks
      before_validation do
        ActiveSeo::Helpers.sanitize_keywords(seo_keywords) if seo_keywords?
      end

      before_save do
        seo_foreign = self.class.seo_meta_attribute_names.map(&:to_s)
        seo_current = seo_foreign.map { |n| send(n) }
        seo_foreign = seo_foreign.map { |a| a.sub('seo_', '') }
        seo_default = ActiveSeo::SeoMetum.column_defaults.select { |n, _d| seo_foreign.include?(n) }.values
        seo_changes = (seo_current - seo_default).reject { |v| (v.is_a?(String) && v.blank?) || v.nil? }

        if seo_changes.empty?
          self.seo_metum = nil
        end
      end
    end

    class_methods do
      # Get seo meta model class name
      def seo_class_name
        @seo_class_name ||= ActiveSeo.config.class_name
      end

      # Check if seo meta has locale accessors
      def seo_locale_accessors?
        @seo_class_name ||= ActiveSeo.config.locale_accessors
      end

      # Setup seo
      def seo_setup(options={})
        self.seo_config = ActiveSeo::Config.new(options.reverse_merge(seo_config))
        define_seo_validations
      end

      # Set meta contextualizer
      def seo_contextualizer(name)
        self.seo_context = name
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
