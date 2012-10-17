class ColourCalculatorHSV extends ColourCalculator
	constructor: (@h, @s, @v) ->
		@h -= 360 while @h >= 360
		@h += 360 while @h < 0

		if @s < 0 or @s > 100 then (@s = if @s < 0 then 0 else 100)
		if @v < 0 or @v > 100 then (@v = if @v < 0 then 0 else 100)

		@h /= 60
		@s /= 100
		@v /= 100
