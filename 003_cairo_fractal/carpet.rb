require 'cairo'

size = 2400.0

surface = Cairo::ImageSurface.new(:argb32, size, size)
context = Cairo::Context.new(surface)

# 背景
context.fill do
  context.set_source_rgb(0.2, 0, 0.2) # dark purple
  context.rectangle(0, 0, size, size)
end

def draw_squares(cairo_context, base_size, step)
  division_level = 3 ** step
  square_size = base_size / division_level
  return if square_size < 0.1
  cairo_context.fill do
    cairo_context.set_source_color(Cairo::Color::WHITE)
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
  filename = "tmp/carpets/carpet_level_#{format('%04d', step)}.png"
  cairo_context.target.write_to_png(filename)
end

Dir.mkdir('tmp/carpets') unless Dir.exist?('tmp/carpets')
# カーペット描画
(1..10).each do |step|
  draw_squares(context, size, step)
end
