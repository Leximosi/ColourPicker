class ColourCalculatorRGB extends ColourCalculator
	constructor: (@r, @g, @b, @alpha) ->
		@r /= 255
		@g /= 255
		@b /= 255
