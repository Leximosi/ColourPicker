class ColourCalculatorHSV extends ColourCalculator
	constructor: (@h, @s, @v) ->
		@h -= 360 while @h >= 360
		@h += 360 while @h < 0
		@s = 0 if @s < 0
		@s = 100 if @s > 100
		@v = 0 if @v < 0
		@v = 100 if @v > 100

		@h /= 60
		@s /= 100
		@v /= 100
