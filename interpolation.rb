require 'gosu'

require 'matrix'
 
def regress x, y, degree
	x_data = x.map { |xi| (0..degree).map { |pow| (xi**pow).to_f } }

	mx = Matrix[*x_data]
	my = Matrix.column_vector(y)

	((mx.t * mx).inv * mx.t * my).transpose.to_a[0]
end

class MyWindow < Gosu::Window
	def initialize
		super(1024, 800, false)
		self.caption = 'Butterfly Game Interpolation'
		@background_image = Gosu::Image.new(self, "media/SkyGround.jpg", true)

		@px = [100,200,300,300,300,200,100,100]
		@py = [200,200,200,300,400,400,400,300]
		@betas = regress @px, @py, 2
		@animation = Gosu::Image::load_tiles(self, "media/npc_butterfly__x1_fly-side_png_1354829525.png", -14, -6, false)
		@x = 0
		@y = 0

		@arial = Gosu::Font.new(self, "Arial", 25)

	end

	def update
		@x += 1
		@y =  @betas[2] * @x**2 + @betas[1] * @x + @betas[0]
	end

	def draw
	  	@background_image.draw(0, 0, 0,self.width.to_f/@background_image.width, self.height.to_f/@background_image.height)
	  	img = @animation[Gosu::milliseconds / 100 % @animation.size];
		img.draw(@x - img.width / 2 -10, @y - img.height / 2 - 10, 0)
		8.times do |i|
			draw_line(@px[i]-10,@py[i],Gosu::Color.new(0xff000000),@px[i]+10,@py[i],Gosu::Color.new(0xff000000),0)
	  		draw_line(@px[i],@py[i]-10,Gosu::Color.new(0xff000000),@px[i],@py[i]+10,Gosu::Color.new(0xff000000),0)
	  		@arial.draw(i.to_s, @px[i], @py[i], 0)
	  	end
	end
end

window = MyWindow.new
window.show