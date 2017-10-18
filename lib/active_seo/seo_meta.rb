module ActiveSeo
  # Config class
  class SeoMeta < Hashie::Dash
    property :title_field
    property :description_field
  end
  #
  # # Set attr accessors
  # mattr_accessor :model_config
  #
  # # Set config options
  # @@model_config = SeoMeta.new
  #
  # # Setup module
  # def self.model_setup
  #   yield model_config
  # end
end
