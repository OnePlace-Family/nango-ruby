RSpec.describe Nango::Client do
  describe "faraday_middleware" do
    it "defaults to nil" do
      expect(described_class.new.faraday_middleware).to be_nil
    end

    it "falls back to the global configuration" do
      middleware = ->(f) { f }
      Nango.configure { |config| config.faraday_middleware = middleware }

      expect(described_class.new.faraday_middleware).to eq(middleware)
    end

    it "can be set per client" do
      middleware = ->(f) { f }

      client = described_class.new(faraday_middleware: middleware)

      expect(client.faraday_middleware).to eq(middleware)
    end

    it "prefers the block over the global configuration" do
      Nango.configure { |config| config.faraday_middleware = ->(f) { f } }
      block = ->(f) { f }

      client = described_class.new(&block)

      expect(client.faraday_middleware).to eq(block)
    end

    it "applies the middleware to the Faraday connection" do
      received = nil
      Nango.configure do |config|
        config.access_token = "token"
        config.faraday_middleware = ->(f) { received = f }
      end
      stub_request(:get, "https://api.nango.dev/providers").to_return(
        status: 200,
        body: '{"providers": []}',
        headers: { "Content-Type" => "application/json" }
      )

      described_class.new.get(path: "/providers")

      expect(received).to be_a(Faraday::Connection)
    end
  end
end
