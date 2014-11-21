class Butterfly
	def initialize(window, dx, dy)
		@destination_x = dx
		@destination_y = dy
		@x = @destination_x.first
		@y = @destination_y.first
		@animation = Gosu::Image::load_tiles(window, "media/npc_butterfly__x1_fly-side_png_1354829525.png", -14, -6, false)

	end

	def draw
		img = @animation[Gosu::milliseconds / 100 % @animation.size];
		img.draw(@x - img.width / 2 -10, @y - img.height / 2 - 10, 0)
	end

	def move
	end 
end