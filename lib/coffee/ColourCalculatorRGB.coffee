#  Project: Leximosi Colour Picker
#  Description: Simple canvas and jQuery based colour picker
#  Author: Erik Frèrejean (http://leximosi.github.com)
#  License: MIT license - http://opensource.org/licenses/mit-license.php
###
Create a ColourCalculate object which is initialised by a
RGB value.
###
class ColourCalculatorRGB extends ColourCalculator
	constructor: (@r, @g, @b, @alpha) ->
		@r /= 255
		@g /= 255
		@b /= 255
		@alpha = @alpha ? 255
