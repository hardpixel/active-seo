module ActiveSeo
  class Config < Hashie::Dash
    # Set properties and defaults
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
      self.opengraph = Hashie::Mash.new
      yield self.opengraph
    end

    def twitter_setup(&block)
      self.twitter = Hashie::Mash.new
      yield self.twitter
    end
  end
end
