class Leaf
	attr_reader :x, :y
	def initialize(window, x, y)
		@x = x
		@y = y
		@img = Gosu::Image.new(window, "media/autumn_leaves_PNG3611.png", true)
	end

	def draw
		scale = 0.075
		@img.draw(@x - (scale * @img.width) / 2, @y - (scale * @img.height) / 2, 0, scale, scale)
	end
end