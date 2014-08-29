require 'equalizer'

module Cheeky
  class Row
    include Equalizer.new(:states)
    attr_reader :states

    def initialize(*args)
      args = args.flatten
      case args.first 
      when Row then @states = args.first.states
      else
        @states ||= []
        0.upto(20) do |i|
          @states << convert_to_state(args[i])
        end
      end
      
    end

    def convert_to_state(s)
      case s
      when true then 1
      when false, nil then 0
      when :on then 1
      when :off then 0
      when '.' then 0
      when String, Symbol then convert_to_state(!s.to_s.split.empty?)
      else
        convert_to_state(s.to_i > 0)
      end
    end

    def segments
      states.each_slice(8).to_a.reverse
    end
  end
end