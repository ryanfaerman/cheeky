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
        display.control_transfer(
          bmRequestType: 0x21,
          bRequest:      0x09,
          wValue:        0x0000,
          wIndex:        0x0000,
          dataOut:       bytes.pack('cccccccc')
        )
      end

      def render(frame, hold: 10)
        start = Time.now.to_i
        while (Time.now.to_i - start) < hold
          send(frame.packets)
        end
      end
    end
  end
end