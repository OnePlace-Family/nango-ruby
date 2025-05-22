module Nango
  class Client
    include Nango::HTTP

    SENSITIVE_ATTRIBUTES = %i[@access_token @extra_headers].freeze
    CONFIG_KEYS = %i[
      api_type
      api_version
      access_token
      log_errors
      organization_id
      uri_base
      request_timeout
      extra_headers
    ].freeze
    attr_reader *CONFIG_KEYS, :faraday_middleware

    def initialize(config = {}, &faraday_middleware)
      CONFIG_KEYS.each do |key|
        # Set instance variables like api_type & access_token. Fall back to global config
        # if not present.
        instance_variable_set(
          "@#{key}",
          config[key].nil? ? Nango.configuration.send(key) : config[key]
        )
      end
      @faraday_middleware = faraday_middleware
    end

    def providers
      @providers ||= Nango::Providers.new(client: self)
    end

    def integrations
      @integrations ||= Nango::Integrations.new(client: self)
    end

    def records
      @records ||= Nango::Records.new(client: self)
    end

    def proxy
      @proxy ||= Nango::Proxy.new(client: self)
    end

    def connections
      @connections ||= Nango::Connections.new(client: self)
    end

    def connect
      @connect ||= Nango::Connect.new(client: self)
    end

    def inspect
      vars = instance_variables.map do |var|
        value = instance_variable_get(var)

        SENSITIVE_ATTRIBUTES.include?(var) ? "#{var}=[REDACTED]" : "#{var}=#{value.inspect}"
      end

      "#<#{self.class}:#{object_id} #{vars.join(', ')}>"
    end
  end
end
