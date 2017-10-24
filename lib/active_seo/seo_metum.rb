module ActiveSeo
  class SeoMetum < ActiveRecord::Base
    # Set table name
    self.table_name = 'seo_meta'

    # Belongs associations
    belongs_to :seoable, polymorphic: true, optional: true
  end
end
