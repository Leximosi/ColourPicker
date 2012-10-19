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
		@_ctxObjects.spectrum ? @_createCTXObject 'spectrum', 'colourspectrum'
		@_ctxObjects.picker ? @_createCTXObject 'picker', 'colourpicker'

		@mouseTouchHandlers =
			'picker':	new MouseTouchHandlerPicker @, 'picker'
			'spectrum':	new MouseTouchHandlerSpectrum @, 'spectrum'

		@buildSpectrum()
		@buildPicker()

		@_applyStyle()

	###
Create the canvas that is used to select the colour
	###
	buildPicker: (xPos, yPos) ->
		# Prepare the graphics
		ctx		= @_ctxObjects.picker
		width	= ctx.canvas.width
		height	= ctx.canvas.height

		# Image data
		picker = @_createImageData ctx, width, height

		# Colour picker Saturation/Value
		h = @_pickerData.selectedHSV[0]
		s = 0
		v = 100

		# Loop
		col	= 0
		row	= 0
		i	= 0

		# Current colour rgb
		rgb = []

		# Clear the current context
		ctx.clear()

		# Pixels of the crosshair
		crosshair = @_plugin.options.selectors.picker @, picker, xPos, yPos

		while row < height
			if col is width
				col = 0
				row++

				# Adjust `s` and `v` for the next row
				s = 0
				v = Math.round 100 - row * (100 / height)

			[r, g, b] = @_HSVtoRGB h, s, v

			if i in crosshair
				r = 255 - r
				g = 255 - g
				b = 255 - b

			# Set the pixels
			picker.data[i    ] = r							# Red
			picker.data[i + 1] = g							# Green
			picker.data[i + 2] = b							# Blue
			picker.data[i + 3] = @_pickerData.selectedAlpha	# Alpha

			# Counters
			col++
			i += 4

			# Calculate `s` for the next column
			s  = Math.round col * (100 / width);

		ctx.putImageData picker, 0, 0

		@_dumpCurrentData() if @_plugin.options.debug is true

	###
Create the spectrum bar
	###
	buildSpectrum: ->
		# Prepare the graphics
		ctx		= @_ctxObjects.spectrum
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
			[r, g, b] = @_HSVtoRGB hue, 100, 100
			rgb = "rgb(#{r}, #{g}, #{b})"
			gradient.addColorStop i++ * 1/6, rgb

		# Fill the canvas
		ctx.fillStyle = gradient
		ctx.fillRect spectrumPosLeft, 0, spectrumWidth, height

		# Draw the selector
		@_plugin.options.selectors.spectrum @

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

	###
Calculate the pixel positions for the selector
	###
	createDefaultPickerSelectorPixels: (imgData, xPos, yPos) ->
		if typeof xPos is "undefined"
			xPos = Math.floor @_pickerData.selectedHSV[1] * (imgData.width / 100)
			yPos = Math.floor imgData.height - @_pickerData.selectedHSV[2] * (imgData.height / 100)

		col	= row = 0

		pixels = while row++ <= imgData.height
			if row is yPos
				(row * imgData.width * 4) + (col * 4) while col++ <= imgData.width
			else
				(row * imgData.width * 4) + (xPos * 4)

		pixels.flatten()
		

	###
Draw the default Spectrum selector
	###
	createDefaultSpectrumSelector: (yPos) ->
		# Prepare graphics
		ctx		= @_ctxObjects.spectrum
		height	= ctx.canvas.height

		if typeof yPos is "undefined"
			yPos = Math.floor @_pickerData.selectedHSV[0] * (height / 360)

		positions = [
			[0 , yPos - 5]
			[10, yPos]

			[35, yPos]
			[45, yPos - 5]
			[45, yPos + 5]
			[35, yPos]

			[10, yPos]
			[0 , yPos + 5]
			[0 , yPos - 5]
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
		[r, g, b] = @_currentToRGB()

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
					"Red: #{r}"
			.append =>
				$(document.createElement('p')).text =>
					"Green: #{g}"
			.append =>
				$(document.createElement('p')).text =>
					"Blue: #{b}"
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
