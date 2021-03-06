module ActiveSeo
  class OpenGraphConfig < Hashie::Mash
    self.disable_warnings
  end

  class TwitterCardConfig < Hashie::Mash
    self.disable_warnings
  end

  class Config < Hashie::Dash
    property :class_name,           default: 'ActiveSeo::SeoMetum'
    property :locale_accessors,     default: false
    property :title_limit,          default: 70
    property :description_limit,    default: 160
    property :keywords_limit,       default: 255
    property :title_fallback,       default: true
    property :description_fallback, default: true
    property :generate_keywords,    default: true
    property :opengraph,            default: {}
    property :twitter,              default: {}

    def opengraph_setup(&block)
      self.opengraph = OpenGraphConfig.new
      yield self.opengraph
    end

    def twitter_setup(&block)
      self.twitter = TwitterCardConfig.new
      yield self.twitter
    end
  end
end
