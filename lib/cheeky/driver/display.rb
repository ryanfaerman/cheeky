module Cheeky
  module Driver
    class Display
      VENDOR_ID = 0x1d34
      PRODUCT_ID = 0x0013

      attr_reader :display

      def display
        @display ||= begin
          usb = LIBUSB::Context.new
          device = usb.devices(idVendor: VENDOR_ID, idProduct: PRODUCT_ID).first
          display = device.open
          display.detach_kernel_driver(0) if display.kernel_driver_active?(0)
          display
        end
      end

      def send(packets)
        packets.each do |packet|
          write(packet.bytes)
        end
      end

      def write(bytes)
        begin
          display.control_transfer(
            bmRequestType: 0x21,
            bRequest:      0x09,
            wValue:        0x0000,
            wIndex:        0x0000,
            dataOut:       bytes.pack('cccccccc')
          )
        rescue ArgumentError => e
          # binding.pry
        end
        
      end

      def render(frame, hold: 10, verbose: false)
        case frame
        when Array then frame.each {|f| render(f, hold: hold)}
        else
          start = Time.now
          if verbose
            render_cli(frame.rows)
            puts "---"
          end
          while ((Time.now - start)*1000).to_i < hold*1000
            @frame = frame

            send(frame.packets)
          end
        end
        nil
      end

      def render_cli(rows)
        output = ''
        rows.each do |row|
          row.states.each_with_index do |s, index|
            output << "|" if index == 21

            output << case s
                      when 1 then 'X'
                      when 0 then '_'
                      end
          end
          output << "\n"
        end
        puts output
      end

    end
  end
end