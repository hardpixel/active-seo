ActiveSeo.setup do |config|
  # config.title_limit          = 70
  # config.description_limit    = 160
  # config.keywords_limit       = 255
  # config.keywords_separator   = ', '
  # config.title_fallback       = true
  # config.description_fallback = true
  # config.generate_keywords    = true
end

ActiveSeo.opengraph_setup do |config|
  # config.type      = 'website'
  # config.site_name = 'Site name'
end

ActiveSeo.twitter_setup do |config|
  # config.card    = 'summary'
  # config.site    = 'Site Twitter handle'
  # config.creator = 'Author Twitter handle'
end
