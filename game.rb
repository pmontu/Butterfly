require 'gosu'
require_relative 'flower.rb'
require_relative 'leaf.rb'
require_relative 'butterfly.rb'

class MyWindow < Gosu::Window

	@@QUADRANT = {"LEFT_TOP" => 1, "RIGHT_TOP" => 2, "LEFT_BOTTOM" => 3, "RIGHT_BOTTOM" => 4}

	def getLocations(xsteps, ysteps)
		locations = []
		(1..ysteps-1).each do |yi|
			(1..xsteps-1).each do |xi|
				if xi<=xsteps/2 and yi<=ysteps/2
					quadrant = @@QUADRANT["LEFT_TOP"]
				elsif xi>xsteps/2 and yi<=ysteps/2
					quadrant = @@QUADRANT["RIGHT_TOP"]
				elsif xi<=xsteps/2 and yi>ysteps/2
					quadrant = @@QUADRANT["LEFT_BOTTOM"]
				elsif xi>xsteps/2 and yi>ysteps/2
					quadrant = @@QUADRANT["RIGHT_BOTTOM"]
				end
				locations.push({ "x" => self.width.to_f/xsteps * xi, "y" => self.height.to_f/ysteps * yi, "q" => quadrant})
			end
		end
		return locations
	end

	def initialize
		super(1024, 768, false)
		self.caption = 'Butterfly Game'

		@ROWS = 7
		@COLUMNS = 9
		@FLOWERS_PER_QUADRANT = 2
		@PERCENTAGE_OF_LEAVES = 0.5

		@background_image = Gosu::Image.new(self, "media/SkyGround.jpg", true)

		# locations
		@locations = getLocations(@COLUMNS, @ROWS)

		@locations.shuffle!(random: Random.new(1))

		# flowers
		@flowers = []
		(@@QUADRANT.values*2).each do |quadrant|
			location = @locations.find { |location| location["q"]==quadrant}
			@flowers.push(Flower.new(self,location["x"],location["y"]))
			@locations.delete(location)
		end

		# leaves
		@leaves = []
		leaves_number = ((@ROWS-1)*(@COLUMNS-1)*@PERCENTAGE_OF_LEAVES).to_i
		@locations[0..(leaves_number-1)].each do |point|
			@leaves.push(Leaf.new(self,point["x"],point["y"]))
		end

		# butterflys
		@butterflys = []
		@butterflys.push(Butterfly.new(self, @flowers, @leaves))

		# score
		@hud = Gosu::Font.new(self, "media/Bangers.TTF", 35)
		@score = 1024

	end
  
	def update
		@butterflys.each { |butterfly| butterfly.move }
	end

	def draw
	  	@background_image.draw(0, 0, 0, self.width.to_f / @background_image.width, self.height.to_f / @background_image.height)
	  	@leaves.each { |leaf| leaf.draw }
	  	@flowers.each { |flower| flower.draw }
		@butterflys.each { |butterfly| butterfly.draw }
		[@butterflys[0].x.round(0), @butterflys[0].y.round(0), @butterflys[0].journey_frame].each_with_index do |text, i|
			@hud.draw(text, 20, i*@hud.height+10, 0, 1, 1, Gosu::Color.new(0x9f007d00))
		end


	  	#@locations.each do |l|
	  	[[@butterflys[0].start.x, @butterflys[0].start.y], [@butterflys[0].end.x, @butterflys[0].end.y]].each_with_index do |point, i|
	  		l = {}
	  		l["x"], l["y"] = point[0], point[1]
	  		r = (i+1) * 10
	  		draw_line(l["x"]-r,l["y"],Gosu::Color.new(0xff000000),l["x"]+r,l["y"],Gosu::Color.new(0xff000000),0)
	  		draw_line(l["x"],l["y"]-r,Gosu::Color.new(0xff000000),l["x"],l["y"]+r,Gosu::Color.new(0xff000000),0)
	  	end
  	end
end


window = MyWindow.new
window.show