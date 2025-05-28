require_relative "http_headers"

module Nango
  module HTTP
    include HTTPHeaders

    def get(path:, parameters: nil, headers: nil)
      parse_jsonl(conn.get(uri(path: path), parameters) do |req|
        req.headers = self.headers

        add_proxy_request_headers(req, headers) if headers
      end&.body)
    end

    def post(path:, headers: nil)
      parse_jsonl(conn.post(uri(path: path)) do |req|
        req.headers = headers

        add_proxy_request_headers(req, headers) if headers
      end&.body)
    end

    def json_post(path:, parameters:, query_parameters: {}, headers: nil)
      conn.post(uri(path: path)) do |req|
        configure_json_post_request(req, parameters)
        req.params = req.params.merge(query_parameters)

        add_proxy_request_headers(req, headers) if headers
      end&.body
    end

    def put(path:, parameters: nil, headers: nil)
      parse_jsonl(conn.put(uri(path: path), parameters) do |req|
        req.headers = self.headers
        add_proxy_request_headers(req, headers) if headers
      end&.body)
    end

    def patch(path:, parameters: nil, headers: nil)
      parse_jsonl(conn.patch(uri(path: path), parameters) do |req|
        req.headers = self.headers
        add_proxy_request_headers(req, headers) if headers
      end&.body)
    end

    def json_put(path:, parameters:, query_parameters: {}, headers: nil)
      conn.put(uri(path: path)) do |req|
        configure_json_post_request(req, parameters)
        req.params = req.params.merge(query_parameters)
        add_proxy_request_headers(req, headers) if headers
      end&.body
    end

    def json_patch(path:, parameters:, query_parameters: {}, headers: nil)
      conn.patch(uri(path: path)) do |req|
        configure_json_post_request(req, parameters)
        req.params = req.params.merge(query_parameters)
        add_proxy_request_headers(req, headers) if headers
      end&.body
    end

    def delete(path:, headers: nil)
      conn.delete(uri(path: path)) do |req|
        add_proxy_request_headers(req, headers) if headers
      end&.body
    end

    private

    def parse_jsonl(response)
      return unless response
      return response unless response.is_a?(String)

      # Convert a multiline string of JSON objects to a JSON array.
      response = response.gsub("}\n{", "},{").prepend("[").concat("]")

      JSON.parse(response)
    end

    def add_proxy_request_headers(req, headers)
      headers.each do |key, value|
        req.headers["nango-proxy-#{key}"] = value
      end
    end

    def conn(multipart: false)
      connection = Faraday.new do |f|
        f.options[:timeout] = @request_timeout
        f.request(:multipart) if multipart
        f.use MiddlewareErrors if @log_errors
        f.response :raise_error
        f.response :json
      end

      @faraday_middleware&.call(connection)

      connection
    end

    def uri(path:)
      File.join(@uri_base, path)
    end

    def configure_json_post_request(req, parameters)
      req_parameters = parameters.dup

      req.headers = headers
      req.body = req_parameters.to_json
    end

    def try_parse_json(maybe_json)
      JSON.parse(maybe_json)
    rescue JSON::ParserError
      maybe_json
    end
  end
end
