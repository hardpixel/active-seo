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


  # Set attr accessors
  mattr_accessor :config

  # Set config options
  @@config = Config.new

  # Setup module config
  def self.setup
    yield config
  end
end
