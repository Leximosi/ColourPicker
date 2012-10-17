#  Project:
#  Description:
#  Author:
#  License:

#  Boilerplate: https://github.com/zenorocha/jquery-boilerplate

# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
(($, window) ->
	# window is passed through as local variable rather than global
	# as this (slightly) quickens the resolution process and can be more efficiently
	# minified (especially when both are regularly referenced in your plugin).

	# Create the defaults once
	pluginName = 'LeximosiColourPicker'
	document = window.document
	defaults = 
		debug: true
		pickerData:
			selectedHSV: [0, 0, 0]
			selectedAlpha: 255
		spectrumData:
			selectorColour: '#333'

	# The actual plugin constructor
	class Plugin
		constructor: (@element, options) ->
			# jQuery has an extend method which merges the contents of two or
			# more objects, storing the result in the first object. The first object
			# is generally empty as we don't want to alter the default options for
			# future instances of the plugin
			@options = $.extend true, {}, defaults, options

			@_defaults = defaults
			@_name = pluginName

			@colourPicker = new ColourPicker @

			@init()

		init: ->
			# Place initialization logic here
			# You already have access to the DOM element and the options via the instance,
			# e.g., @element and @options
			@colourPicker.build()

		getPlugin: ->
			@

		getColourPicker: ->
			@colourPicker

	# A really lightweight plugin wrapper around the constructor,
	# preventing against multiple instantiations
	$.fn[pluginName] = (options) ->
		@each ->
			if !$.data this, "plugin_#{pluginName}"
				$.data @, "plugin_#{pluginName}", new Plugin @, options
)(jQuery, window)
