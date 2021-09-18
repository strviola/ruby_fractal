require 'cairo'

size = 600.0
margin = 100.0

surface = Cairo::ImageSurface.new(:argb32, size, size)
context = Cairo::Context.new(surface)

# 背景
context.fill do
  context.set_source_color(Cairo::Color::WHITE)
  context.rectangle(0, 0, size, size)
end

context.stroke do
  # 第1段階
  context.set_source_color(Cairo::Color::BLACK)
  top_x = size / 2
  top_y = margin
  context.move_to(top_x, top_y)
  triangle_length = size - (margin * 2)
  rad = Math::PI * Rational('2/3')
  triangle_x1 = top_x - triangle_length * Math.cos(rad)
  triangle_y = margin + triangle_length * Math.sin(rad)
  context.line_to(triangle_x1, triangle_y)
  triangle_x2 = top_x + triangle_length * Math.cos(rad)
  context.line_to(triangle_x2, triangle_y)
  context.line_to(top_x, top_y)
end

Dir.mkdir('tmp/snowflakes') unless Dir.exist?('tmp/snowflakes')
context.target.write_to_png('tmp/snowflakes/snowflake.png')
