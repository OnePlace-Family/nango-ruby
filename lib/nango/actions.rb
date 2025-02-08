module Nango
  class Actions
    def initialize(client:)
      @client = client
    end

    def trigger(
      connection_id:,
      integration_id:,
      action_name:,
      input:
    )
      client = client_for_connection(connection_id: connection_id, integration_id: integration_id)
      client.json_post(
        path: "/action/trigger",
        parameters: {
          action_name: action_name,
          input: input
        }
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
