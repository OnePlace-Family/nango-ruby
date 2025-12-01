module Nango
  class Proxy
    def initialize(client:)
      @client = client
    end

    def get(
      connection_id:,
      integration_id:,
      path:,
      parameters: {},
      nango_headers: {},
      headers: nil,
      json: true
    )
      client = client_for_connection(connection_id: connection_id, integration_id: integration_id, headers: nango_headers)
      client.get(
        path: "/proxy/#{path}",
        parameters: parameters,
        headers: headers,
        json: json
      )
    end

    def post(
      connection_id:,
      integration_id:,
      path:,
      parameters: {},
      query_parameters: {},
      nango_headers: {},
      headers: nil
    )
      client = client_for_connection(connection_id: connection_id, integration_id: integration_id, headers: nango_headers)
      client.json_post(
        path: "/proxy/#{path}",
        parameters: parameters,
        query_parameters: query_parameters,
        headers: headers
      )
    end

    def put(
      connection_id:,
      integration_id:,
      path:,
      parameters: {},
      query_parameters: {},
      nango_headers: {},
      headers: nil
    )
      client = client_for_connection(connection_id: connection_id, integration_id: integration_id, headers: nango_headers)
      client.json_put(
        path: "/proxy/#{path}",
        parameters: parameters,
        query_parameters: query_parameters,
        headers: headers
      )
    end

    def patch(
      connection_id:,
      integration_id:,
      path:,
      parameters: {},
      query_parameters: {},
      nango_headers: {},
      headers: nil
    )
      client = client_for_connection(connection_id: connection_id, integration_id: integration_id, headers: nango_headers)
      client.json_patch(
        path: "/proxy/#{path}",
        parameters: parameters,
        query_parameters: query_parameters,
        headers: headers
      )
    end

    def delete(
      connection_id:,
      integration_id:,
      path:,
      nango_headers: {},
      headers: nil
    )
      client = client_for_connection(connection_id: connection_id, integration_id: integration_id, headers: nango_headers)
      client.delete(path: "/proxy/#{path}", headers: headers)
    end

    private

    def client_for_connection(connection_id:, integration_id:, headers: nil)
      client = @client.dup
      client.add_headers(
        "Connection-Id" => connection_id,
        "Provider-Config-Key" => integration_id
      )
      client.add_headers(headers) if headers

      client
    end
  end
end
