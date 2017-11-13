module ActiveSeo
  module Loader
    extend ActiveSupport::Concern

    class_methods do
      # Helper to include ActiveSeo::Meta
      def has_seo(options={})
        include ActiveSeo::Meta

        if options.present?
          seo_setup options.except(:contextualizer)
        end

        if options[:contextualizer].present?
          seo_contextualizer options[:contextualizer]
        end
      end
    end
  end
end
