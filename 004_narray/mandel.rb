require 'numo/narray'
require 'gdk_pixbuf2'
include Numo

def mandel(w, h, w2, h2, zoom)
  z = (SComplex.new(1, w).seq / w - w2) * zoom +
      (SComplex.new(h, 1).seq / h - h2) * zoom * Complex(0, 1)
  c = z.dup
  a = UInt8.zeros(w, h)
  index = Int32.new(w, h).seq

  (1..100).each do |i|
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

data = mandel(600, 600, 0.8, 0.5, 2)
# Grayscale to RGB
graphic_data = UInt8.zeros(600, 600, 3)
graphic_data[true, true, 1] = (SFloat.cast(data) / 100 * 255)
pixbuf = GdkPixbuf::Pixbuf.new(data: graphic_data.to_string, width: 600, height: 600)
pixbuf.save('tmp/mandel.png')
