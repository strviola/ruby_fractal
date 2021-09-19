require 'numo/narray'
require 'gdk_pixbuf2'
include Numo

def mandel(w, h, w2, h2, zoom, step = 200)
  z = (SComplex.new(1, w).seq / w - w2) * zoom +
      (SComplex.new(h, 1).seq / h - h2) * zoom * Complex(0, 1)
  c = z.dup
  a = UInt8.zeros(w, h)
  index = Int32.new(w, h).seq

  (1..step).each do |i|
    z = z ** 2 + c
    index_t = (z.abs > 2).where
    index_f = (z.abs <= 2).where
    a[index[index_t]] = i
    break if index_f.empty?

    index = index[index_f]
    z = z[index_f]
    c = c[index_f]
  end
  a
end

def pixbuf_writer(size, center_x, center_y, zoom, height = size, step = 200)
  data = mandel(size, height, center_x, center_y, zoom, step)
  # Grayscale to RGB
  graphic_data = UInt8.zeros(size, height, 3)
  graphic_data[true, true, 1] = (SFloat.cast(data) / 100 * 255)
  GdkPixbuf::Pixbuf.new(data: graphic_data.to_string, width: size, height: height)
end

pixbuf = pixbuf_writer(1200, 0.8, 0.5, 2)
pixbuf.save('tmp/mandel.png')
