module Cheeky
  class Font
    include Equalizer.new(:name)
    attr_reader :name, :characters, :source

    def initialize(name = 'default')
      @name = name.to_s
      @source = File.expand_path("../../../fonts/#{name}.yml", __FILE__)
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