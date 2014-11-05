require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'

class MyWindow < Gosu::Window
  def initialize
		super(640, 480, false)
		self.caption = 'Hello World!'
		@background_image = Gosu::Image.new(self, "media/SkyGround.jpg", true)
		@flowers = Array.new
		(1..4).each do |quadrant|
			@flowers.push(Flower.new(self,quadrant))
		end
		@leaves = Array.new
		(0..10).each do 
			@leaves.push(Leaf.new(self))
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

  	#draw_line(0, 480/2, Gosu::Color.argb(0xff000000), 640, 480/2, Gosu::Color.argb(0xff000000))
  	#draw_line(640/2, 0, Gosu::Color.argb(0xff000000), 640/2, 480, Gosu::Color.argb(0xff000000))
  end
end

class Flower
	def initialize(window, quadrant)
		if quadrant == 1
			@x = 640/4 - 100 + (rand * 100)
			@y = 480/4 - 100 + (rand * 100)
		elsif quadrant ==2
			@x = 640*3/4 - 100 + (rand * 100)
			@y = 480/4 - 100 + (rand * 100)
		elsif quadrant ==3
			@x = 640/4 - 100 + (rand *100)
			@y = 480*3/4 - 100 + (rand * 100)
		elsif quadrant ==4
			@x = 640*3/4 - 100 + (rand *100)
			@y = 480*3/4 - 100 + (rand * 100)
		end
		@img = Gosu::Image.new(window, "media/bagonia.png", true)
	end

	def draw
		
		@img.draw(@x, @y, 0, 0.25, 0.25)
	end
end

class Leaf
	def initialize(window)
		@x = rand * 640
		@y = rand * 480
		@img = Gosu::Image.new(window, "media/autumn_leaves_PNG3611.png", true)
	end

	def draw
		@img.draw(@x, @y, 0, 0.1, 0.1)
	end
end




window = MyWindow.new
window.show