module Nango
  class Action
    attr_reader :name, :input

    def initialize(
      name:,
      input:
    )
      @name = name
      @input = input
    end
  end
end
