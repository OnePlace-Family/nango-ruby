module Nango
  class Connections
    def initialize(client:)
      @client = client
    end

    def list
      @client.get(path: "/connections")
    end

    def get(id:)
      @client.get(path: "/connections/#{id}")
    end

    def delete(id:)
      @client.delete(path: "/connections/#{id}")
    end
  end
end
