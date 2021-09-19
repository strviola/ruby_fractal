require 'cairo'

width = 300
height = 200
radius = height * 3 / 10

surface = Cairo::ImageSurface.new(:argb32, width, height)
context = Cairo::Context.new(surface)

# 背景
context.fill do
  context.set_source_color(Cairo::Color::WHITE)
  context.rectangle(0, 0, width, height)
end

# 赤丸
context.fill do
  context.set_source_color(Cairo::Color::RED)
  context.circle(width / 2, height / 2, radius)
end

surface.write_to_png('tmp/hinomaru.png')
