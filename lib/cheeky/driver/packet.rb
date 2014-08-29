module Cheeky
  module Driver
    class Packet
      OFFSETS = [0, 2, 4, 6]

      attr_reader :row_one, :row_two, :brightness, :row_number, :offset

      def initialize(brightness: Brightness.new, offset: 0, rows: [])
        @brightness = brightness

        if OFFSETS.include? offset
          @offset = offset
        else
          raise ArgumentError, "'#{offset} is invalid"
        end

        prepare_rows(rows)
      end

      def prepare_rows(rows)
        @row_one = Row.new(rows[0])
        @row_two = Row.new(rows[1])
      end

      def bytes
        bits = []
        bits[0] = brightness.level
        bits[1] = offset
        row_one.segments.each do |segment|
          bits << hexify(segment)
        end
        row_two.segments.each do |segment|
          bits << hexify(segment)
        end

        bits
      end

      def hexify(segment)
        byte = 0

        0.upto(7) do |i|
          s = segment[i] || 0
          byte |= s << i
        end

        0xFF - byte
      end
    end
  end
end