module Nango
  class Integrations
    def initialize(client:)
      @client = client
    end

    def list
      @client.get(path: "/integrations")
    end

    def get(id:)
      @client.get(path: "/integrations/#{id}")
    end
  end
end
