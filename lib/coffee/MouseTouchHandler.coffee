#  Project: Leximosi Colour Picker
#  Description: Simple canvas and jQuery based colour picker
#  Author: Erik Frèrejean (http://leximosi.github.com)
#  License: MIT license - http://opensource.org/licenses/mit-license.php
###
Handler class for mouse and touch input
###
class MouseTouchHandler
	constructor: (@colourPicker, element) ->
		@element	= $(@colourPicker._ctxObjects[element].canvas)
		@handle		= false
		@register()

		# The custom events
		return if not @colourPicker._plugin.options.events[element]?
		for bindings, callback of @colourPicker._plugin.options.events[element]
			(@element.on "#{event}.#{@colourPicker._plugin._name}", (e) => callback e, @) for event in bindings.split " "

	###
Register all events
	###
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

	###
Determine the position of the event on the canvas
	###
	_getEventPosition: (e) ->
		offset	= @element.offset()

		if not e.originalEvent.changedTouches
			@eventPosition =
				xPos: e.pageX -= offset.left
				yPos: e.pageY -= offset.top
		else
			@eventPosition =
				xPos: e.originalEvent.changedTouches[0].pageX -= offset.left
				yPos: e.originalEvent.changedTouches[0].pageY -= offset.top
