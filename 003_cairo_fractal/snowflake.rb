require 'cairo'

class Line
  attr_accessor :x, :y, :length, :angle

  def initialize(x, y, length, angle)
    @x = x
    @y = y
    @length = length
    @angle = angle
  end

  def polar_next_point(base_x, base_y, radius, angle)
    diff_x = radius * Math.cos(angle)
    diff_y = radius * Math.sin(angle)
    [base_x + diff_x, base_y + diff_y]
  end

  def end_point
    polar_next_point(@x, @y, @length, @angle)
  end

  def add_line_koch_step
    next_length = @length / 3
    lines = [Line.new(@x, @y, next_length, @angle)]
    x, y = polar_next_point(@x, @y, next_length, @angle)
    angle1 = @angle + rad_pi('1/3')
    lines << Line.new(x, y, next_length, angle1)
    x, y = polar_next_point(x, y, next_length, angle1)
    angle2 = @angle + rad_pi('-1/3')
    lines << Line.new(x, y, next_length, angle2)
    x, y = polar_next_point(x, y, next_length, angle2)
    lines << Line.new(x, y, next_length, @angle)
    lines
  end
end

size = 600.0
margin = 50.0
base_length = size - (margin * 2)
top_x = size / 2
top_y = 10

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

context.set_source_color(Cairo::Color::BLACK)
line1 = Line.new(top_x, top_y, base_length, rad_pi('2/3'))
line2 = Line.new(*line1.end_point, base_length, rad_pi(0))
line3 = Line.new(*line2.end_point, base_length, rad_pi('-2/3'))
context.stroke do
  context.move_to(line1.x, line1.y)
  line1.add_line_koch_step.each do |line|
    context.line_to(*line.end_point)
  end
  line2.add_line_koch_step.each do |line|
    context.line_to(*line.end_point)
  end
  line3.add_line_koch_step.each do |line|
    context.line_to(*line.end_point)
  end
end

Dir.mkdir('tmp/snowflakes') unless Dir.exist?('tmp/snowflakes')
context.target.write_to_png('tmp/snowflakes/snowflake.png')
