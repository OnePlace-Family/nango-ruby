module Nango
  class Providers
    def initialize(client:)
      @client = client
    end

    def list
      @client.get(path: "/providers")
    end
  end
end
