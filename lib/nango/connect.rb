module Nango
  class Connect
    def initialize(client:)
      @client = client
    end

    def create_session(parameters: {})
      @client.json_post(
        path: "/connect/sessions",
        parameters: parameters
      )
    end

    def reconnect(connection_id:, integration_id:)
      @client.json_post(
        path: "/connect/sessions/reconnect",
        parameters: {
          connection_id: connection_id,
          integration_id: integration_id
        }
      )
    end
  end
end
