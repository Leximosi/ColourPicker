class MouseHandlerSpectrum extends MouseHandler
	mouseAction: (e) ->
		yPos	= e.pageY - e.currentTarget.offsetTop
		hue		= Math.round yPos * 360/e.currentTarget.height
		if @hue < 0 or @hue > 359 then (@hue = if @hue < 0 then 0 else 359)

		@colourPicker._pickerData.selectedHSV[0] = hue
		@colourPicker.buildPicker()
		@colourPicker.buildSpectrum()
