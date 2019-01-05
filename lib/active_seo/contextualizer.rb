module ActiveSeo
  class Contextualizer
    include ActiveSeo::Contextualize

    def initialize(record)
      @record    = record
      @config    = record.class.seo_config
      @opengraph = config.opengraph.merge(model_og_meta)
      @twitter   = config.twitter.merge(model_twitter_meta)
    end

    def og_meta
      parse_meta(opengraph).deep_symbolize_keys
    end

    def twitter_meta
      parse_meta(twitter).deep_symbolize_keys
    end

    private

    def parse_meta(options)
      meta = {}

      if options.is_a? Hash
        options.each do |key, value|
          meta[key] = parse_values(key, value)
        end
      else
        meta[key] = parse_values(key, value)
      end

      meta
    end

    def parse_values(key, value)
      data = nil

      case value
      when Symbol
        data = get_record_value value
      when Proc
        data = call_record_proc value
      else
        data = value
      end

      data
    end

    def get_record_value(attribute)
      try(attribute) || record.try(attribute)
    end

    def call_record_proc(proc_method)
      proc_method.call record
    end
  end
end
