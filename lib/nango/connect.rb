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

    def reconnect(parameters: {})
      @client.json_post(
        path: "/connect/sessions/reconnect",
        parameters: parameters
      )
    end
  end
end
