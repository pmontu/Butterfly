require 'gosu'

require 'spliner'

class MyWindow < Gosu::Window
	def initialize
		super(1024, 800, false)
		self.caption = 'Butterfly Game Interpolation'
		@background_image = Gosu::Image.new(self, "media/SkyGround.jpg", true)

		@px = [100,200,300]
		@py = [200,300,200]
		@my_spline = Spliner::Spliner.new @px, @py

		@animation = Gosu::Image::load_tiles(self, "media/npc_butterfly__x1_fly-side_png_1354829525.png", -14, -6, false)
		@x = 100
		@y = 200

		@arial = Gosu::Font.new(self, "Arial", 25)

	end

	def update
		if @x < 300 then @x += 0.5 end
		@y =  @my_spline[@x]
	end

	def draw
	  	@background_image.draw(0, 0, 0,self.width.to_f/@background_image.width, self.height.to_f/@background_image.height)
	  	img = @animation[Gosu::milliseconds / 100 % @animation.size];
		img.draw(@x - img.width / 2 -10, @y - img.height / 2 - 10, 0)
		3.times do |i|
			draw_line(@px[i]-10,@py[i],Gosu::Color.new(0xff000000),@px[i]+10,@py[i],Gosu::Color.new(0xff000000),0)
	  		draw_line(@px[i],@py[i]-10,Gosu::Color.new(0xff000000),@px[i],@py[i]+10,Gosu::Color.new(0xff000000),0)
	  		@arial.draw(i.to_s, @px[i], @py[i], 0)
	  	end
	end
end

window = MyWindow.new
window.show