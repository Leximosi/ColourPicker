class MouseTouchHandler
	constructor: (element, @colourPicker) ->
		@element	= $(element.canvas)
		@handle		= false
		@register()

	register: ->
		@element.on "mousedown.#{@colourPicker._plugin._name} touchstart.#{@colourPicker._plugin._name}", (e) =>
			e.preventDefault();
			@handle = true
			@action e
		.on "mouseup.#{@colourPicker._plugin._name} touchend.#{@colourPicker._plugin._name}", (e) =>
			e.preventDefault();
			@handle = false
		.on "mousemove.#{@colourPicker._plugin._name} touchmove.#{@colourPicker._plugin._name}", (e) =>
			e.preventDefault();
			@action e if @handle is true

	_getEventPosition: (e) ->
		offset	= @element.offset()

		if not e.originalEvent.changedTouches
			xPos: e.pageX -= offset.left
			yPos: e.pageY -= offset.top
		else
			xPos: e.originalEvent.changedTouches[0].pageX -= offset.left
			yPos: e.originalEvent.changedTouches[0].pageY -= offset.top