require 'numo/narray'
require 'gdk_pixbuf2'
include Numo

def mandel(width, height, width2, height2, zoom)
  z = (SComplex.new(1, width).seq / width - width2) * zoom +
      (SComplex.new(height, 1).seq / height - height2) * zoom * Complex(0, 1)
end

data = mandel(600, 600, 0.8, 0.5, 2)
pp data
