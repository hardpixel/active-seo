require 'active_support'
require 'stringex'
require 'hashie'
require 'active_delegate'
require 'active_seo/version'

module ActiveSeo
  extend ActiveSupport::Concern

  autoload :Config,         'active_seo/config'
  autoload :Helpers,        'active_seo/helpers'
  autoload :Contextualize,  'active_seo/contextualize'
  autoload :Contextualizer, 'active_seo/contextualizer'
  autoload :Meta,           'active_seo/meta'
  autoload :SeoMeta,        'active_seo/seo_meta'
  autoload :SeoMetum,       'active_seo/seo_metum'
  autoload :Loader,         'active_seo/loader'

  mattr_accessor :config

  @@config = Config.new

  def self.setup
    yield config
  end
end

ActiveSupport.on_load(:active_record) do
  include ActiveSeo::Loader
end
