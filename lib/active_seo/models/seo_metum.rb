class SeoMetum < ActiveRecord::Base
  # Belongs associations
  belongs_to :seoable, polymorphic: true, optional: true
end
