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
        args.each do |arg|
          @states << convert_to_state(arg)
        end

        args.length.upto(20) do |i|
          @states << 0
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

    def displayable
      states.first(21)
    end

    def segments
      segments = displayable.each_slice(8).to_a
      segments.each_with_index do |segment, index|

        padding = 8 - segment.length
        
        padding.times do
          segment << 0
        end

        segments[index] = segment
      end
      # unless segments.map(&:length).all?{|a| a == 8}
      #   binding.pry
      # end
      segments.reverse
    end

    def rshift(n)
      shifted_states = states.dup
      n.times { shifted_states.unshift(0) }
      # n.times { shifted_states.pop }
      self.class.new(shifted_states)
    end

    def lshift(n)
      shifted_states = states.dup
      n.times { shifted_states.shift }
      n.times { shifted_states.push(0) }
      self.class.new(shifted_states)
    end
  end
end