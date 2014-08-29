require 'libusb'
require 'equalizer'
require 'yaml'

require 'cheeky/brightness'
require 'cheeky/row'
require 'cheeky/frame'
require 'cheeky/driver/display'
require 'cheeky/driver/packet'


module Cheeky
  VERSION = '0.0.1'

  def write(text, font: :default, hold: 10)
    display = Driver::Display.new

    rows = Font.new(font).map(text)
    frame = Frame.new(rows: rows)

    display.render(frame, hold: hold)
  end
  module_function :write

  class Font
    include Equalizer.new(:name)
    attr_reader :name, :characters, :source

    def initialize(name = 'default')
      @name = name.to_s
      @source = File.expand_path("../../fonts/#{name}.yml", __FILE__)
      @characters = {}
      load

    end

    def load
      definition = YAML.load_file(source)
      @characters = definition['characters']
    end

    def lookup(char)
      mapping = characters[char.to_s]
      case mapping.length
      when 1 then characters[mapping.first]
      else
        mapping
      end
    end
    alias_method :[], :lookup

    def map(string)
      letters = string.split('')

      output_rows = [
        [],
        [],
        [],
        [],
        [],
        [],
        []
      ]
      letters.each do |letter|
        lookup(letter).each_with_index do |submap, index|
          output_rows[index] << submap
        end
      end

      output_rows.map {|r| r.join(' ')}.map {|r| Row.new(*r.split(''))}
    end
  end
end