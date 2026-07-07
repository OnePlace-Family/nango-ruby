require "nango"
require "webmock/rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    original_configuration = Nango.instance_variable_get(:@configuration)
    Nango.configuration = Nango::Configuration.new
    example.run
  ensure
    Nango.instance_variable_set(:@configuration, original_configuration)
  end
end
