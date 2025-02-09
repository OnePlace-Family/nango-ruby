module Nango
  class Proxy
    def initialize(client:)
      @client = client
    end

    def get(connection_id:, integration_id:, path:, parameters: {})
      client = client_for_connection(connection_id: connection_id, integration_id: integration_id)
      client.get(path: "/proxy/#{path}", parameters: parameters)
    end

    def post(connection_id:, integration_id:, path:, parameters: {}, query_parameters: {})
      client = client_for_connection(connection_id: connection_id, integration_id: integration_id)
      client.json_post(
        path: "/proxy/#{path}",
        parameters: parameters,
        query_parameters: query_parameters
      )
    end

    private

    def client_for_connection(connection_id:, integration_id:)
      client = @client.dup
      client.add_headers(
        "Connection-Id" => connection_id,
        "Provider-Config-Key" => integration_id
      )

      client
    end
  end
end
