module Nango
  class Connections
    def initialize(client:)
      @client = client
    end

    def list
      @client.get(path: "/connection")
    end

    def get(id:,provider:)
      @client.get(path: "/connection/#{id}?provider_config_key=#{provider}")
    end

    def delete(id:)
      @client.delete(path: "/connection/#{id}")
    end
  end
end
