require 'cairo'

format = Cairo::FORMAT_ARGB32
size = 600.0

surface = Cairo::ImageSurface.new(format, size, size)
context = Cairo::Context.new(surface)

# 背景
context.set_source_rgb(0.2, 0, 0.2) # dark purple
context.rectangle(0, 0, size, size)
context.fill
context.set_source_rgb(1, 1, 1)

def draw_squares(cairo_context, base_size, step)
  division_level = 3 ** step
  square_size = base_size / division_level
  points = (0..division_level).select { _1 % 3 == 1 }
  points.each do |index_x|
    points.each do |index_y|
      x = square_size * index_x
      y = square_size * index_y
      cairo_context.rectangle(x, y, square_size, square_size)
      cairo_context.fill
    end
  end
end

# カーペット描画
draw_squares(context, size, 1)
draw_squares(context, size, 2)
draw_squares(context, size, 3)

surface.write_to_png('tmp/sierpinski_carpet.png')
