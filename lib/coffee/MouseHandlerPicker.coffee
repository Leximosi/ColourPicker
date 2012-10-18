class MouseHandlerPicker extends MouseHandler
	mouseAction: (e) ->
		ele		= $(@.element)
		offset	= ele.offset()

		xPos = e.pageX - offset.left
		yPos = e.pageY - offset.top

		@sat = Math.floor xPos * 100 / ele.width()
		@val = Math.floor 100 - yPos * 100 / ele.height()

		if @sat < 0 or @sat > 100 then (@sat = if @sat < 0 then 0 else 100)
		if @val < 0 or @val > 100 then (@val = if @val < 0 then 0 else 100)

		@colourPicker._pickerData.selectedHSV[1] = @sat
		@colourPicker._pickerData.selectedHSV[2] = @val

		@colourPicker.buildPicker()

		# Call the users action
		@colourPicker._plugin.options.callback @ if @colourPicker._plugin.options.callback?
