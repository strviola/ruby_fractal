require 'cairo'

format = Cairo::FORMAT_ARGB32
size = 600.0

surface = Cairo::ImageSurface.new(format, size, size)
context = Cairo::Context.new(surface)

# 背景
color_purple = [0.2, 0, 0.2]
context.set_source_rgb(*color_purple)
context.rectangle(0, 0, size, size)
context.fill

# 1段階目
color_white = [1, 1, 1]
context.set_source_rgb(*color_white)
next_size = size / 3
context.rectangle(next_size, next_size, next_size, next_size)
context.fill

# 2段階目
next_size = next_size / 3
[1, 4, 7].each do |index_x|
  [1, 4, 7].each do |index_y|
    x = next_size * index_x
    y = next_size * index_y
    context.rectangle(x, y, next_size, next_size)
    context.fill
  end
end

surface.write_to_png('tmp/sierpinski_carpet.png')
