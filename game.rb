require 'gosu'

class MyWindow < Gosu::Window
	def initialize
		super(640, 480, false)
		self.caption = 'Butterfly Game'

		@background_image = Gosu::Image.new(self, "media/SkyGround.jpg", true)

		@locations = []
		(1..5).each do |yi|
			li = []
			(1..7).each do |xi|
				quadrant = 0
				if xi<=3 and yi<=2
					quadrant = 1
				elsif xi>=5 and yi<=2
					quadrant = 2
				elsif xi<=3 and yi>=4
					quadrant = 3
				elsif xi>=5 and yi>=4
					quadrant = 4
				end
				@locations.push({ "x" => 640/8 * xi, "y" => 480/6 * yi, "q" => quadrant})
			end
		end

		@locations.shuffle!

		@flowers = []
		(1..4).each do |quadrant|
			location = @locations.find { |location| location["q"]==quadrant}
			@flowers.push(Flower.new(self,location["x"],location["y"]))
			@locations.delete(location)
		end

		@leaves = []
		@locations[0..19].each do |point|
			@leaves.push(Leaf.new(self,point["x"],point["y"]))
		end

		@butterflys = []
		@flowers.sample(2).each { |leaf| @butterflys.push(Butterfly.new(self, leaf.x, leaf.y))}

		@message = Gosu::Font.new(self, "Times New Roman", 50)

	end
  
	def update
		@butterflys.each { |butterfly| butterfly.move }
	end

	def draw
		fx = 640.0 / @background_image.width
		fy = 480.0 / @background_image.height
	  	@background_image.draw(0, 0, 0, fx, fy)
	  	@leaves.each { |leaf| leaf.draw }
	  	@flowers.each { |flower| flower.draw }
		@butterflys.each { |butterfly| butterfly.draw }

		@message.draw(@test, 0, 0, 0, 1, 1, Gosu::Color.new(0xff000000))
	  	#@locations.each do |l|
	  	#	draw_line(l["x"]-10,l["y"],Gosu::Color.new(0xff000000),l["x"]+10,l["y"],Gosu::Color.new(0xff000000),0)
	  	#	draw_line(l["x"],l["y"]-10,Gosu::Color.new(0xff000000),l["x"],l["y"]+10,Gosu::Color.new(0xff000000),0)
	  	#end
  	end
end

class Flower
	attr_reader :x, :y
	def initialize(window, x, y)
		@x = x
		@y = y
		@img = Gosu::Image.new(window, "media/bagonia.png", true)
	end

	def draw
		scale = 0.15
		@img.draw(@x - (scale * @img.width) / 2, @y - (scale * @img.height) / 2, 0, scale, scale)
	end
end

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

class Butterfly
	def initialize(window, x, y)
		@x = x
		@y = y
		#@animation = Gosu::Image::load_tiles(window, "media/B-martin87_butterfly.png", -7, -1, false)
		@animation = Gosu::Image::load_tiles(window, "media/npc_butterfly__x1_fly-side_png_1354829525.png", -14, -6, false)
	end

	def draw
		img = @animation[Gosu::milliseconds / 100 % @animation.size];
		img.draw(@x - img.width / 2 -10, @y - img.height / 2 - 10, 0)
	end

	def move
		#if Gosu::distance(@x, @y, @flower.x, @flower.y) > 0 then
		#	@x += (@flower.x-@x)/20
		#	@y += (@flower.y-@y)/20
		#end
	end 
end


window = MyWindow.new
window.show