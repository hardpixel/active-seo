require 'active_support'
require 'hashie'
require 'active_delegate'
require 'active_seo/meta'
require 'active_seo/models/seo_metum'
require 'active_seo/seo_meta'
require 'active_seo/version'

module ActiveSeo
  # Config class
  class Config < Hashie::Dash
    property :title_limit,          default: 70
    property :description_limit,    default: 160
    property :keywords_limit,       default: 255
    property :title_fallback,       default: true
    property :description_fallback, default: true
    property :generate_keywords,    default: true
  end

  # Set attr accessors
  mattr_accessor :config, :opengraph_config, :twitter_config

  # Set config options
  @@config           = Config.new
  @@opengraph_config = Hashie::Mash.new
  @@twitter_config   = Hashie::Mash.new

  # Setup module config
  def self.setup
    yield config
  end

  # Setup module opengraph config
  def self.opengraph_setup
    yield opengraph_config
  end

  # Setup module opengraph config
  def self.twitter_setup
    yield twitter_config
  end
end
