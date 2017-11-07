require 'active_support'
require 'action_view'
require 'hashie'
require 'active_delegate'
require 'active_seo/helpers'
require 'active_seo/contextualize'
require 'active_seo/contextualizer'
require 'active_seo/meta'
require 'active_seo/seo_metum'
require 'active_seo/seo_meta'
require 'active_seo/version'

module ActiveSeo
  # Config class
  class Config < Hashie::Dash
    # Set properties and defaults
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

  # Set attr accessors
  mattr_accessor :config

  # Set config options
  @@config = Config.new

  # Setup module config
  def self.setup
    yield config
  end
end
