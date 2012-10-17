class MouseHandlerPicker extends MouseHandler
	mouseAction: (e) ->
		xPos = e.pageX - e.currentTarget.offsetLeft
		yPos = e.pageY - e.currentTarget.offsetTop

		sat = Math.floor xPos * 100/e.currentTarget.width
		val = Math.floor 100 - yPos * 100 / e.currentTarget.height

		sat =   0 if sat < 0
		sat = 100 if sat > 100

		val =   0 if val < 0
		val = 100 if val > 100

		@colourPicker._pickerData.selectedHSV[1] = sat
		@colourPicker._pickerData.selectedHSV[2] = val

		@colourPicker.buildPicker()
