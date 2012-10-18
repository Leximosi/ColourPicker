class MouseHandlerSpectrum extends MouseHandler
	mouseAction: (e) ->
		ele		= $(@.element)
		offset	= ele.offset()

		yPos = e.pageY - offset.top

		@hue = Math.round yPos * 360 / ele.height()
		if @hue < 0 or @hue > 359 then (@hue = if @hue < 0 then 0 else 359)

		@colourPicker._pickerData.selectedHSV[0] = @hue
		@colourPicker.buildPicker()
		@colourPicker.buildSpectrum()

		# Call the users action
		@colourPicker._plugin.options.callback @ if @colourPicker._plugin.options.callback?
