require 'cairo'

size = 1200.0

surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, size, size)
context = Cairo::Context.new(surface)

# 背景
context.set_source_rgb(0.2, 0, 0.2) # dark purple
context.rectangle(0, 0, size, size)
context.fill
context.set_source_rgb(1, 1, 1)

def draw_squares(cairo_surface, cairo_context, base_size, step)
  division_level = 3 ** step
  square_size = base_size / division_level
  return if square_size < 0.1
  points = (0..division_level).select { _1 % 3 == 1 }
  points.each do |index_x|
    points.each do |index_y|
      x = square_size * index_x
      y = square_size * index_y
      cairo_context.rectangle(x, y, square_size, square_size)
      cairo_context.fill
    end
  end
  Dir.mkdir('tmp/carpets') unless Dir.exist?('tmp/carpets')
  file_name_index = format('%04d', step)
  cairo_surface.write_to_png("tmp/carpets/carpet_level_#{file_name_index}.png")
end

# カーペット描画
(1..10).each do |step|
  draw_squares(surface, context, size, step)
end
