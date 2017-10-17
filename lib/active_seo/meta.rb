module ActiveSeo
  module Meta
    extend ActiveSupport::Concern

    included do
      # Include modules
      include ActiveDelegate

      # Has associations
      has_one :seo_meta, as: :seoable, class_name: 'SeoMetum', autosave: true, dependent: :destroy

      # Delegate attributes
      delegate_attributes to: :seo_meta, prefix: 'seo', allow_nil: true

      # Validations
      validates :seo_title, length: { maximum: 70 }, allow_blank: true
      validates :seo_description, length: { maximum: 180 }, allow_blank: true
    end
  end
end
