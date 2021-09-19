require 'cairo'

class Line
  attr_accessor :x, :y, :length, :angle

  def initialize(x, y, length, angle: nil, angle_str: nil)
    raise ArgumentError if angle.nil? && angle_str.nil?
    @x = x
    @y = y
    @length = length
    @angle = angle || rad_pi(angle_str)
    @angle_str = angle_str
  end

  def rad_pi(string)
    Math::PI * Rational(string)
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
    lines = [Line.new(@x, @y, next_length, angle: @angle)]
    x, y = polar_next_point(@x, @y, next_length, @angle)
    angle1 = @angle + rad_pi('1/3')
    lines << Line.new(x, y, next_length, angle: angle1)
    x, y = polar_next_point(x, y, next_length, angle1)
    angle2 = @angle + rad_pi('-1/3')
    lines << Line.new(x, y, next_length, angle: angle2)
    x, y = polar_next_point(x, y, next_length, angle2)
    lines << Line.new(x, y, next_length, angle: @angle)
    lines
  end
end

class Figure
  THRESHOLD = 0.1
  attr_accessor :lines

  def initialize(*lines)
    @lines = lines
  end

  def add_koch_step!
    raise 'Line length is less than threshold' if @lines.any? { _1.length < THRESHOLD }
    @lines = @lines.map(&:add_line_koch_step).flatten
  end

  def points
    @lines.map(&:end_point)
  end
end

size = 3600.0
margin = 10.0
base_length = (Math.sqrt(3) / 2) * (size - (margin * 2))
top_x = size / 2
top_y = 10

surface = Cairo::ImageSurface.new(:argb32, size, size)

line1 = Line.new(top_x, top_y, base_length, angle_str: '2/3')
line2 = Line.new(*line1.end_point, base_length, angle_str: '0')
line3 = Line.new(*line2.end_point, base_length, angle_str: '-2/3')
figure = Figure.new(line1, line2, line3)
Dir.mkdir('tmp/snowflakes') unless Dir.exist?('tmp/snowflakes')

(0..5).each do |index|
  context = Cairo::Context.new(surface)
  # 背景
  context.fill do
    context.set_source_color(Cairo::Color::WHITE)
    context.rectangle(0, 0, size, size)
  end
  # 図形の描画
  context.set_source_color(Cairo::Color::BLACK)
  context.stroke do
    context.move_to(line1.x, line1.y)
    index.times { figure.add_koch_step! }
    figure.points.each do |point_x, point_y|
      context.line_to(point_x, point_y)
    end
  end
  filename = "tmp/snowflakes/snowflake_#{format('%04d', index)}.png"
  context.target.write_to_png(filename)
rescue => e
  puts e.message
end
