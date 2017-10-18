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
    property :title_limit
    property :description_limit
    property :keywords_limit
    property :keywords_separator
  end

  # Set attr accessors
  mattr_accessor :config

  # Set config options
  @@config = Config.new

  # Setup module
  def self.setup
    yield config
  end
end
