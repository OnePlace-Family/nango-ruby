module Nango
  class ListRecords
    def initialize(client:)
      @client = client
    end

    def get(model:, connection_id:, integration_id:)
      client = client_for_connection(connection_id: connection_id, integration_id: integration_id)
      client.get(
        path: "/v1/#{model}"
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