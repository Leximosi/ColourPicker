class MouseHandlerPicker extends MouseHandler
	mouseAction: (e) ->
		ele		= $(@.element)
		offset	= ele.offset()

		xPos = e.pageX - offset.left
		yPos = e.pageY - offset.top

		sat = Math.floor xPos * 100 / ele.width()
		val = Math.floor 100 - yPos * 100 / ele.height()

		if @s < 0 or @s > 100 then (@s = if @s < 0 then 0 else 100)
		if @v < 0 or @v > 100 then (@v = if @v < 0 then 0 else 100)

		@colourPicker._pickerData.selectedHSV[1] = sat
		@colourPicker._pickerData.selectedHSV[2] = val

		@colourPicker.buildPicker()
