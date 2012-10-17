class MouseHandlerSpectrum extends MouseHandler
	mouseAction: (e) ->
		yPos	= e.pageY - e.currentTarget.offsetTop
		hue	= Math.round yPos * 360/e.currentTarget.height
		hue	= 0 if hue < 0
		hue = 359 if hue > 359

		@colourPicker._pickerData.selectedHSV[0] = hue
		@colourPicker.buildPicker()
		@colourPicker.buildSpectrum()
