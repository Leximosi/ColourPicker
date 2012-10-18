#  Project: Leximosi Colour Picker
#  Description: Simple canvas and jQuery based colour picker
#  Author: Erik Frèrejean (http://leximosi.github.com)
#  License: MIT license - http://opensource.org/licenses/mit-license.php
class MouseTouchHandlerPicker extends MouseTouchHandler
	action: (e) ->
		position = @_getEventPosition e

		@sat = Math.floor position.xPos * 100 / @element.width()
		@val = Math.floor 100 - position.yPos * 100 / @element.height()

		if @sat < 0 or @sat > 100 then (@sat = if @sat < 0 then 0 else 100)
		if @val < 0 or @val > 100 then (@val = if @val < 0 then 0 else 100)

		@colourPicker._pickerData.selectedHSV[1] = @sat
		@colourPicker._pickerData.selectedHSV[2] = @val

		@colourPicker.buildPicker()

		# Call the users action
		@colourPicker._plugin.options.callback @ if @colourPicker._plugin.options.callback?
