class Butterfly
	attr_reader :x, :y, :start, :journey_frame, :end, :score, :journey_at, :journey_num

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

	def respond

		if @state == State::SIT and @user_responded == false
			@score.correct += 1
			@user_responded = true
		elsif @state == State::FLY
			@score.error += 1
		end
	end

	def new_journey(start)

		@journey_num = rand(2..5)
		@journey = [start]
		(1..@journey_num-1).each do |position|
			if rand <= 1.0 / (@journey_num - position)
				@journey += (@flowers - @journey).sample(1)
			else
				@journey += (@leaves - @journey).sample(1)
			end
		end
		@sit_time = 1 * 60
		#@fly_time = 60 * Gosu::distance(@start.x, @start.y, @end.x, @end.y).round / 100.0
		@fly_time = [3,4,6].sample * 60
		@journey_at = 0
		new_leap
		@state = State::FLY

		if not @user_responded
			@score.misses += 1
		end
	end

	def new_leap
		@start, @end = @journey[@journey_at], @journey[@journey_at+1]
		@journey_frame = 1
		@journey_at += 1
	end

	def new_sit
		@sit_frame = 1
		@state = State::SIT
		@user_responded = false
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
				if @journey_at + 1 < @journey.length
					new_leap
				else
					new_sit
				end
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