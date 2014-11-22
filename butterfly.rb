class Butterfly
	attr_reader :x, :y, :start, :journey_frame, :end, :score

	module State
		FLY = 1
		SIT = 2
	end

	def initialize(window, flowers, leaves)
		@flowers = flowers
		@leaves = leaves
		@score = Score.new
		new_journey @flowers.first
		@animation = Gosu::Image::load_tiles(window, "media/npc_butterfly__x1_fly-side_png_1354829525.png", -14, -6, false)

	end

	def new_journey(start)
		@start = start
		@x, @y = @start.x, @start.y
		@end = (@flowers - [@start]).sample
		#@fly_time = 60 * Gosu::distance(@start.x, @start.y, @end.x, @end.y).round / 100.0
		@fly_time = 6 * 60
		@sit_time = 1 * 60
		@journey_frame = 1
		@state = State::FLY
	end

	def respond

		if @state == State::SIT
			@score.correct += 1
		else
			@score.error += 1
		end
	end

	def new_sit
		@sit_frame = 1
		@state = State::SIT
	end

	def draw
		img = @animation[Gosu::milliseconds / 100 % @animation.size];
		img.draw(@x - img.width / 2 -10, @y - img.height / 2 - 10, 0)
	end

	def move
		if @state == State::FLY

			if @journey_frame < @fly_time
				@x = @start.x + @journey_frame * (@end.x - @start.x) / @fly_time.to_f
				@y = @start.y + @journey_frame * (@end.y - @start.y) / @fly_time.to_f
				@journey_frame += 1
			else
				new_sit
			end

		elsif @state == State::SIT

			if @sit_frame < @sit_time
				@sit_frame += 1
			else
				new_journey @end
			end
		end

	end
end