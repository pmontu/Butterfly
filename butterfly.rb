class Butterfly
	attr_reader :x, :y, :start_x, :start_y, :journey_frame, :end_x, :end_y

	def initialize(window, dx, dy)
		@destination_x = dx
		@destination_y = dy
		@start_x = @destination_x.first
		@start_y = @destination_y.first
		@end_x = @destination_x.last
		@end_y = @destination_y.last
		new_journey
		@animation = Gosu::Image::load_tiles(window, "media/npc_butterfly__x1_fly-side_png_1354829525.png", -14, -6, false)

	end

	def new_journey
		@x = @start_x
		@y = @start_y
		@fly_time = 60 * Gosu::distance(start_x, start_y, end_x, end_y).round / 100.0
		@fly_time = 6 * 60
		@journey_frame = 1
	end

	def draw
		img = @animation[Gosu::milliseconds / 100 % @animation.size];
		img.draw(@x - img.width / 2 -10, @y - img.height / 2 - 10, 0)
	end

	def move
		if @journey_frame < @fly_time

			@x = @start_x + @journey_frame * (@end_x - @start_x) / @fly_time.to_f
			@y = @start_y + @journey_frame * (@end_y - @start_y) / @fly_time.to_f
			@journey_frame += 1

		else

			@start_x ,@end_x = @end_x, @start_x
			@start_y ,@end_y = @end_y, @start_y
			new_journey
		end

	end
end