require 'rubygems' # only necessary in Ruby 1.8
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
				@locations.push([640/8 * xi, 480/6 * yi])
			end
		end

		@locations.shuffle!

		@leaves = []
		@locations[0..19].each do |point|
			@leaves.push(Leaf.new(self,point[0],point[1]))
		end

		@flowers = []
		@locations[20..26].each do |point|
			@flowers.push(Flower.new(self,point[0],point[1]))
		end

	end
  
	def update

	end

	def draw
		fx = 640.0 / @background_image.width
		fy = 480.0 / @background_image.height
	  	@background_image.draw(0, 0, 0, fx, fy)
	  	@leaves.each { |leaf| leaf.draw }
	  	@flowers.each { |flower| flower.draw }

	  	@locations.each do |point|
	  		#draw_line(point[0]-10, point[1]-10, Gosu::Color.argb(0xff000000), point[0]+10, point[1]+10, Gosu::Color.argb(0xff000000))
	  		#draw_line(point[0]-10, point[1]+10, Gosu::Color.argb(0xff000000), point[0]+10, point[1]-10, Gosu::Color.argb(0xff000000))
	  	end
  	end
end

class Flower
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




window = MyWindow.new
window.show