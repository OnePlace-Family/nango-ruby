require_relative "http_headers"

module Nango
  module HTTP
    include HTTPHeaders

    def get(path:, parameters: nil)
      parse_jsonl(conn.get(uri(path: path), parameters) do |req|
        req.headers = headers
      end&.body)
    end

    def post(path:)
      parse_jsonl(conn.post(uri(path: path)) do |req|
        req.headers = headers
      end&.body)
    end

    def json_post(path:, parameters:, query_parameters: {})
      conn.post(uri(path: path)) do |req|
        configure_json_post_request(req, parameters)
        req.params = req.params.merge(query_parameters)
      end&.body
    end

    def delete(path:)
      conn.delete(uri(path: path)) do |req|
        req.headers = headers
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
