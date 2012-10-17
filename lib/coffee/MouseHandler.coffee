class MouseHandler
	constructor: (@element, @colourPicker) ->
	
		console.log @element
		console.log @colourPicker

		@clicked = false
		@bind()

	bind: ->
		@element.mousedown (e) =>
			@clicked = true
			@mouseAction e
		.mouseup (e) =>
			@clicked = false
		.mousemove (e) =>
			@mouseAction e if @clicked
