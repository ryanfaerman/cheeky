require 'equalizer'

module Cheeky
  class Brightness
    include Equalizer.new(:level)

    attr_reader :level

    LEVELS = {
      low: 2,
      medium:1,
      high: 0
    }

    def initialize(level = :high)
      @level = case level
      when Symbol, String then LEVELS.fetch(level.to_sym, :high)
      else
        if level.to_i > LEVELS.values.max
          3
        else
          level.to_i
        end
      end
    end
  end
end