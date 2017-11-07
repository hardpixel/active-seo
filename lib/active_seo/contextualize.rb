module ActiveSeo
  module Contextualize
    extend ActiveSupport::Concern

    included do
      attr_accessor :record, :config, :opengraph, :twitter

      # Set class attributes
      class_attribute :model_og_meta
      class_attribute :model_twitter_meta

      self.model_og_meta      = {}
      self.model_twitter_meta = {}
    end

    class_methods do
      def og_meta(key, options)
        self.model_og_meta[key] = options
      end

      def twitter_meta(key, options)
        self.model_twitter_meta[key] = options
      end
    end
  end
end