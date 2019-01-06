module ActiveSeo
  class SeoMetum < ActiveRecord::Base
    self.table_name = 'seo_meta'

    attribute :noindex,  :boolean, default: false
    attribute :nofollow, :boolean, default: false

    belongs_to :seoable, polymorphic: true, optional: true
  end
end
