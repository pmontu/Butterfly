class Butterfly
	attr_reader :x, :y, :start, :journey_frame, :end, :score, :journey_at, :journey_num

	module Color
		BLUE = 1
		BROWN = 2
	end

	module State
		FLY = 1
		SIT = 2
	end

	def initialize(window, flowers, leaves, color = Color::BLUE)
		@flowers = flowers
		@leaves = leaves
		@color = color
		@score = Score.new
		@highlight = false
		new_journey @flowers.first
		if @color == Color::BLUE
			@animation = Gosu::Image::load_tiles(window, "media/npc_butterfly__x1_fly-side_png_1354829525.png", -14, -6, false)
			@animation_sit = Gosu::Image::load_tiles(window, "media/npc_butterfly__x1_fly-top_png_1354829528.png", -13, -7, false)
		elsif @color = Color::BROWN
			@animation = Gosu::Image::load_tiles(window, "media/B-martin87_butterfly.png", -7, -1, false)
			@animation_sit = Gosu::Image::load_tiles(window, "media/B-martin87_butterfly.png", -7, -1, false)
		end
		@highlight_img = Gosu::Image.new(window, "media/glowing_circle_png_by_curemarinesunshine-d43156k.png", true)

	end

	def switch_highlight
		@highlight = !@highlight
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

		@journey_num = rand(2..4)
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
		@fly_time = [3,6].sample * 60
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

		if @highlight
			@highlight_img.draw_rot(@x,@y,0,Gosu::milliseconds / 10 % 360,0.5,0.5,0.2,0.2)
		end

		if @state == State::FLY
			img = @animation[Gosu::milliseconds / 100 % @animation.size];
		elsif @state == State::SIT
			img = @animation_sit[Gosu::milliseconds / 10 % @animation.size];
		end

		if @color == Color::BLUE and @state == State::SIT
			fx = fy = 0.8
			img.draw(@x - (fx * img.width) / 2 - 6, @y - (fy * img.height) / 2, 0, fx, fy)
		elsif @color == Color::BLUE and @state == State::FLY
			img.draw(@x - img.width / 2 -10, @y - img.height / 2 - 10, 0)
		elsif @color == Color::BROWN
			fx = fy = 0.15
			img.draw(@x - (fx * img.width) / 2, @y - (fy * img.height) / 2 + 10, 0, fx, fy)
		end
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