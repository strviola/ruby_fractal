require 'cairo'

format = Cairo::FORMAT_ARGB32
width = 600
height = 600

surface = Cairo::ImageSurface.new(format, width, height)
context = Cairo::Context.new(surface)

color_white = [1, 1, 1]
color_purple = [0.5, 0, 0.5]

context.set_source_rgb(*color_white)
context.rectangle(0, 0, width, height)
context.fill

surface.write_to_png('tmp/sierpinski_carpet.png')
