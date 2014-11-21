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

		@locations.shuffle!

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
		(1..1).each do
			destination_x = []
			destination_y = []
			@flowers.sample(2).each do |flower|
				destination_x.push(flower.x)
				destination_y.push(flower.y)
			end
			@butterflys.push(Butterfly.new(self, destination_x, destination_y))
		end

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
		@hud.draw(@score, 20, 10, 0, 1, 1, Gosu::Color.new(0x9f007d00))
	  	#@locations.each do |l|
	  	#	draw_line(l["x"]-10,l["y"],Gosu::Color.new(0xff000000),l["x"]+10,l["y"],Gosu::Color.new(0xff000000),0)
	  	#	draw_line(l["x"],l["y"]-10,Gosu::Color.new(0xff000000),l["x"],l["y"]+10,Gosu::Color.new(0xff000000),0)
	  	#end
  	end
end




window = MyWindow.new
window.show