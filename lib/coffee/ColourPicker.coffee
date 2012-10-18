#  Project: Leximosi Colour Picker
#  Description: Simple canvas and jQuery based colour picker
#  Author: Erik Frèrejean (http://leximosi.github.com)
#  License: MIT license - http://opensource.org/licenses/mit-license.php
###
Main ColourPicker class
###
class ColourPicker
	constructor: (@_plugin) ->
		@_ctxObjects	= {}
		@_pickerData	= @_plugin.options.pickerData
		@_spectrumData	= @_plugin.options.spectrumData

	###
Build the complete colourpicker
	###
	build: ->
		@buildSpectrum()
		@buildPicker()

		new MouseTouchHandlerPicker @_ctxObjects.picker, @
		new MouseTouchHandlerSpectrum @_ctxObjects.spectrum, @

		@_applyStyle()

	###
Create the canvas that is used to select the colour
	###
	buildPicker: ->
		# Prepare the graphics
		ctx		= @_ctxObjects.picker ? @_createCTXObject 'picker', 'colourpicker' 
		width	= ctx.canvas.width
		height	= ctx.canvas.height

		# Image data
		picker = @_createImageData ctx, width, height

		# Colour picker Saturation/Value
		h = @_pickerData.selectedHSV[0]
		s = 0
		v = 100

		# Inverse hue/saturation/value for the crosshair
		_h = h + 180
		_s = 100
		_v = 0

		# Loop
		col	= 0
		row	= 0
		i	= 0

		# Current colour rgb
		rgb = []

		# Clear the current context
		ctx.clear()

		while row < height
			if col is width
				col = 0
				row++

				# Adjust `s` and `v` for the next row
				s = 0
				v = Math.round 100 - row * (100 / height)

				# Adjust `_s` and `_v` for the next row
				_s = 100
				_v = row * (100 / height)

			# Get the rgb value
			if s is @_pickerData.selectedHSV[1] or v is @_pickerData.selectedHSV[2]
				# On the crosshair
				rgb = @_HSVtoRGB _h, _s, _v
			else
				rgb = @_HSVtoRGB h, s, v

			# Set the pixels
			picker.data[i    ] = rgb[0]						# Red
			picker.data[i + 1] = rgb[1]						# Green
			picker.data[i + 2] = rgb[2]						# Blue
			picker.data[i + 3] = @_pickerData.selectedAlpha	# Alpha

			# Counters
			col++
			i += 4

			# Calculate `s` and `_s` for the next column
			s  = Math.round col * (100 / width);
			_s = Math.round 100 - col * (100 / width);

		ctx.putImageData picker, 0, 0

		@_dumpCurrentData() if @_plugin.options.debug is true

	###
Create the spectrum bar
	###
	buildSpectrum: ->
		# Prepare the graphics
		ctx		= @_ctxObjects.spectrum ? @_createCTXObject 'spectrum', 'colourspectrum' 
		width	= ctx.canvas.width
		height	= ctx.canvas.height

		# Properly align the spectrum
		spectrumWidth	= 25
		spectrumPosLeft	= (width - spectrumWidth) / 2

		# Clear the current context
		ctx.clear()

		# Create the gradient
		gradient = ctx.createLinearGradient 0, 0, 0, height

		i = 0
		for hue in [0..360] by 60
			rgb = @_HSVtoRGB hue, 100, 100
			rgb = 'rgb(' + rgb[0] + ', ' + rgb[1] + ', ' + rgb[2] + ')'
			gradient.addColorStop i++ * 1/6, rgb

		# Fill the canvas
		ctx.fillStyle = gradient
		ctx.fillRect spectrumPosLeft, 0, spectrumWidth, height

		# Draw the selector indicator
		currentSpectrumPosition = @_pickerData.selectedHSV[0] / (360 / height)
		positions = [
			[0 , currentSpectrumPosition - 5]
			[10, currentSpectrumPosition]

			[35, currentSpectrumPosition]
			[45, currentSpectrumPosition - 5]
			[45, currentSpectrumPosition + 5]
			[35, currentSpectrumPosition]

			[10, currentSpectrumPosition]
			[0 , currentSpectrumPosition + 5]
			[0 , currentSpectrumPosition - 5]
		]

		# Set fill style
		ctx.fillStyle	= @_currentToHEX()
		ctx.strokeStyle	= @_spectrumData.selectorColour

		ctx.beginPath()
		position = positions.shift()
		ctx.moveTo position[0], position[1]

		ctx.lineTo position[0], position[1] for position in positions

		ctx.fill()
		ctx.stroke()
		ctx.closePath()

	###
Style the picker
	###
	_applyStyle: ->
		return if @_plugin.options.stylecss is true

		picker		= $(@_ctxObjects.picker.canvas)
		spectrum	= $(@_ctxObjects.spectrum.canvas)

		spectrum.css
			'border': 								'1px solid #888'
			'border-right':							'none'
			'-webkit-border-top-left-radius':		'5px'
			'-webkit-border-bottom-left-radius':	'5px'
			'-moz-border-radius-topleft':			'5px'
			'-moz-border-radius-bottomleft':		'5px'
			'border-top-left-radius':				'5px'
			'border-bottom-left-radius':			'5px'
			'cursor':								'move'

		picker.css
			'border': 		'1px solid #888'
			'border-right':	'none'
			'border-left':	'none'
			'cursor':		'crosshair'

		$(@_plugin.element).css
			'width':				picker.outerWidth(true) + spectrum.outerWidth(true) + 'px'
			'height':				if picker.outerHeight(true) > spectrum.outerHeight(true) then picker.outerHeight(true) + 'px' else spectrum.outerHeight(true) + 'px'
			'-moz-box-shadow':		'10px 10px 5px #888'
			'-webkit-box-shadow':	'10px 10px 5px #888'
			'box-shadow':			'10px 10px 5px #888'

	### Helper functions ###

	###
Create the canvas and setup the "context"
	###
	_createCTXObject: (key, canvasElement) ->
		@_ctxObjects[key] = {} if typeof @_ctxObjects[key] is 'undefined'
		canvas = $(@_plugin.element).append =>
			$(document.createElement('canvas')).attr(
				'id':		canvasElement
				'width':	@_plugin.options.elementProperties[canvasElement][0]
				'height':	@_plugin.options.elementProperties[canvasElement][1]
			)

		@_ctxObjects[key] = $("##{canvasElement}")[0].getContext '2d'

	###
Not all browsers implement createImageData. On such browsers we obtain the 
ImageData object using the getImageData method. The worst-case scenario is 
to create an object *similar* to the ImageData object and hope for the best 
luck.
	###
	_createImageData: (context, w, h) ->
		if context.createImageData?
			imgd = context.createImageData w, h
		else if context.getImageData?
			imgd = context.getImageData 0, 0, w, h
		else
			imgd =
				'width': w
				'height': h
				'data' : []

	###
Create a DOM element that displays all internal data
	###
	_dumpCurrentData: ->
		rgb = @_currentToRGB()

		# Assure it isn't here
		$('#colourpickerdump').remove()

		$('body').append =>
			$(document.createElement('div')).attr('id', 'colourpickerdump').append =>
				$(document.createElement('p')).text =>
					"Hex: #{@_currentToHEX()}"
			.append =>
				$(document.createElement('hr'))
			.append =>
				$(document.createElement('p')).text =>
					"Red: #{rgb[0]}"
			.append =>
				$(document.createElement('p')).text =>
					"Green: #{rgb[1]}"
			.append =>
				$(document.createElement('p')).text =>
					"Blue: #{rgb[2]}"
			.append =>
				$(document.createElement('hr'))
			.append =>
				$(document.createElement('p')).text =>
					"Hue: #{@_pickerData.selectedHSV[0]}"
			.append =>
				$(document.createElement('p')).text =>
					"Saturation: #{@_pickerData.selectedHSV[1]}"
			.append =>
				$(document.createElement('p')).text =>
					"Value: #{@_pickerData.selectedHSV[2]}"

	###
HSV to RGB shortcut
	###
	_HSVtoRGB: (h, s, v) ->
		hsv = new ColourCalculatorHSV h, s, v
		hsv.getRGB()

	###
RGB to HSV shortcut
	###
	_RGBtoHSV: (r, g, b) ->
		rgb = new ColourCalculatorRGB r, g, b
		rgb.getHSV()

	###
Current to RGB shortcut
	###
	_currentToRGB: ->
		hsv = new ColourCalculatorHSV @_pickerData.selectedHSV[0], @_pickerData.selectedHSV[1], @_pickerData.selectedHSV[2]
		hsv.getRGB()

	###
Current to HEX shortcut
	###
	_currentToHEX: ->
		hsv = new ColourCalculatorHSV @_pickerData.selectedHSV[0], @_pickerData.selectedHSV[1], @_pickerData.selectedHSV[2]
		hsv.getHEX()
