require 'libusb'
require 'equalizer'
require 'yaml'

require 'cheeky/brightness'
require 'cheeky/row'
require 'cheeky/frame'
require 'cheeky/font'
require 'cheeky/driver/display'
require 'cheeky/driver/packet'


module Cheeky
  VERSION = '0.0.1'

  def write(text, font: :default, hold: 0.1, scroll: :left)
    display = Driver::Display.new

    rows = Font.new(font).map(text)
    keyframe = Frame.new(rows: rows)

    frames = []

    21.times do |n|
      frames << keyframe.rshift(21-n)
    end

    content_length = rows.first.states.length
    (content_length + 1).times do |n|
      frames << keyframe.lshift(n)
    end

    frames.reverse! if scroll == :right

    display.render(frames, hold: hold)
  end
  module_function :write

end