module ActiveSeo
  class SeoMetum < ActiveRecord::Base
    # Set table name
    self.table_name = 'seo_meta'

    # Set attributes
    attribute :noindex,  :boolean, default: false
    attribute :nofollow, :boolean, default: false

    # Belongs associations
    belongs_to :seoable, polymorphic: true, optional: true
  end
end
