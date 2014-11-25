class Score

	attr_accessor :correct, :error, :misses
	
	def initialize
		@correct = 0
		@error = 0
		@misses = -1
		@consecutive_correct = 0
	end
end