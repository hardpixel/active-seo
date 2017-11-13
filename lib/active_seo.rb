require 'active_support'
require 'action_view'
require 'hashie'
require 'active_delegate'
require 'active_seo/version'

module ActiveSeo
  extend ActiveSupport::Concern

  # Autoload modules
  autoload :Config,         'active_seo/config'
  autoload :Helpers,        'active_seo/helpers'
  autoload :Contextualize,  'active_seo/contextualize'
  autoload :Contextualizer, 'active_seo/contextualizer'
  autoload :Meta,           'active_seo/meta'
  autoload :SeoMeta,        'active_seo/seo_meta'
  autoload :SeoMetum,       'active_seo/seo_metum'
  autoload :Loader,         'active_seo/loader'

  # Set attr accessors
  mattr_accessor :config

  # Set config options
  @@config = Config.new

  # Setup module config
  def self.setup
    yield config
  end
end

ActiveSupport.on_load(:active_record) do
  include ActiveSeo::Loader
end
