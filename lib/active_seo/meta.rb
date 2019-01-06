module ActiveSeo
  module Meta
    extend ActiveSupport::Concern

    included do
      include ActiveDelegate

      class_attribute :seo_config, instance_predicate: false
      class_attribute :seo_context, instance_predicate: false

      self.seo_config = ActiveSeo.config

      has_one :seo_metum, as: :seoable, class_name: seo_class_name, autosave: true, dependent: :destroy
      delegate_attributes to: :seo_metum, prefix: 'seo', allow_nil: true, localized: seo_locale_accessors?

      define_seo_validations
      define_seo_locale_accessors

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
      def seo_class_name
        @seo_class_name ||= ActiveSeo.config.class_name
      end

      def seo_locale_accessors?
        @seo_locale_accessors ||= ActiveSeo.config.locale_accessors
      end

      def seo_setup(options={})
        self.seo_config = ActiveSeo::Config.new(options.reverse_merge(seo_config))
        define_seo_validations
      end

      def seo_contextualizer(name)
        self.seo_context = name
      end

      def define_seo_validations
        validates :seo_title, length: { maximum: seo_config.title_limit }, allow_blank: true
        validates :seo_description, length: { maximum: seo_config.description_limit }, allow_blank: true
        validates :seo_keywords, length: { maximum: seo_config.keywords_limit }, allow_blank: true
      end

      def define_seo_locale_accessors
        return unless seo_locale_accessors?

        I18n.available_locales.each do |locale|
          attr_name = "seo_meta_#{locale.to_s.downcase.tr('-', '_')}"

          define_method attr_name do
            instance_variable_get("@#{attr_name}") ||
            instance_variable_set("@#{attr_name}", ActiveSeo::SeoMeta.new(self, locale).result)
          end
        end
      end
    end

    def seo_meta
      @seo_meta ||= ActiveSeo::SeoMeta.new(self).result
    end
  end
end
