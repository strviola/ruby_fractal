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

def rad_pi(string)
  Math::PI * Rational(string)
end

def polar_next_point(base_x, base_y, radius, angle)
  diff_x = radius * Math.cos(angle)
  diff_y = radius * Math.sin(angle)
  [base_x + diff_x, base_y + diff_y]
end

context.stroke do
  # 第1段階
  context.set_source_color(Cairo::Color::BLACK)
  top_x = size / 2
  top_y = margin
  context.move_to(top_x, top_y)
  base_length = size - (margin * 2)
  point_x, point_y = polar_next_point(top_x, top_y, base_length, rad_pi('2/3'))
  context.line_to(point_x, point_y)
  point_x, point_y = polar_next_point(point_x, point_y, base_length, 0)
  context.line_to(point_x, point_y)
  context.line_to(top_x, top_y)
end

Dir.mkdir('tmp/snowflakes') unless Dir.exist?('tmp/snowflakes')
context.target.write_to_png('tmp/snowflakes/snowflake.png')
