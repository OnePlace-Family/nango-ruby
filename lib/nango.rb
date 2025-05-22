require "faraday"
require "faraday/multipart"

require_relative "nango/http"
require_relative "nango/client"
require_relative "nango/providers"
require_relative "nango/integrations"
require_relative "nango/actions"
require_relative "nango/connections"
require_relative "nango/records"
require_relative "nango/proxy"
require_relative "nango/version"
require_relative "nango/connect"

module Nango
  class Error < StandardError; end
  class ConfigurationError < Error; end

  class MiddlewareErrors < Faraday::Middleware
    def call(env)
      @app.call(env)
    rescue Faraday::Error => e
      raise e unless e.response.is_a?(Hash)

      logger = Logger.new($stdout)
      logger.formatter = proc do |_severity, _datetime, _progname, msg|
        "\033[31mHTTP Error (spotted in nango-ruby #{VERSION}): #{msg}\n\033[0m"
      end
      logger.error(e.response[:body])

      raise e
    end
  end

  class Configuration
    attr_accessor :access_token,
                  :api_type,
                  :api_version,
                  :log_errors,
                  :organization_id,
                  :uri_base,
                  :request_timeout,
                  :extra_headers

    DEFAULT_API_VERSION = "v1".freeze
    DEFAULT_URI_BASE = "https://api.nango.dev/".freeze
    DEFAULT_REQUEST_TIMEOUT = 120
    DEFAULT_LOG_ERRORS = false

    def initialize
      @access_token = nil
      @api_type = nil
      @api_version = DEFAULT_API_VERSION
      @log_errors = DEFAULT_LOG_ERRORS
      @organization_id = nil
      @uri_base = DEFAULT_URI_BASE
      @request_timeout = DEFAULT_REQUEST_TIMEOUT
      @extra_headers = {}
    end
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Nango::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
