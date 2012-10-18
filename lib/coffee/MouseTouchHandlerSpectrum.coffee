#  Project: Leximosi Colour Picker
#  Description: Simple canvas and jQuery based colour picker
#  Author: Erik Frèrejean (http://leximosi.github.com)
#  License: MIT license - http://opensource.org/licenses/mit-license.php
###
Mouse and Touch handler for the Colour Spectrum canvas
###
class MouseTouchHandlerSpectrum extends MouseTouchHandler
	action: (e) ->
		position = @_getEventPosition e

		@hue = Math.round position.yPos * 360 / @element.height()
		if @hue < 0 or @hue > 359 then (@hue = if @hue < 0 then 0 else 359)

		@colourPicker._pickerData.selectedHSV[0] = @hue

		@colourPicker.buildPicker()
		@colourPicker.buildSpectrum()

		# Call the users action
		@colourPicker._plugin.options.callback @ if @colourPicker._plugin.options.callback?
