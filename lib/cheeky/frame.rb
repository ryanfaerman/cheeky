module Cheeky
  class Frame
    include Equalizer.new(:brightness, :rows)

    attr_reader :brightness, :rows

    def initialize(brightness: Brightness.new(:high), rows: [])
      @brightness = brightness
      prepare(rows)
    end

    def prepare(input_rows)
      @rows ||= []
      0.upto(6) do |i|
        @rows << Row.new(input_rows[i])
      end
    end

    def packets
      @packets ||= begin
        packets = []
        offset = 0

        rows.each_slice(2) do |row_pair|
          if row_pair.length != 2
            # binding.pry
            row_pair.push Row.new
          end
          packets << Driver::Packet.new(brightness: brightness, offset: offset, rows: row_pair)
          offset += 2
        end

        packets
      end
    end

    def lshift(n)
      new_rows = []
      rows.each do |row|
        new_rows << row.lshift(n)
      end
      self.class.new(brightness: brightness, rows: new_rows)
    end

    def rshift(n)
      new_rows = []
      rows.each do |row|
        new_rows << row.rshift(n)
      end
      self.class.new(brightness: brightness, rows: new_rows)
    end
  end
end