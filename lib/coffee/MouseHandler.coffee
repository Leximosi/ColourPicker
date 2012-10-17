class MouseHandler
	constructor: (element, @colourPicker) ->
		@element = $(element.canvas)
		@clicked = false
		@bind()

	bind: ->
		@element.mousedown (e) =>
			@clicked = true
			@mouseAction e
		.mouseup (e) =>
			@clicked = false
		.mousemove (e) =>
			@mouseAction e if @clicked is true
