class ColourPicker
	constructor: (@_plugin) ->
		@_ctxObjects	= {}
		@_pickerData	= @_plugin.options.pickerData
		@_spectrumData	= @_plugin.options.spectrumData

	build: ->
		@buildSpectrum()
		@buildPicker()

		new MouseHandlerSpectrum @_ctxObjects.spectrum.canvas, @
		new MouseHandlerPicker @_ctxObjects.picker.canvas, @

	buildPicker: ->
		@_createCTXObject('picker', 'colourpicker') if typeof @_ctxObjects.picker is 'undefined'

		# Prepare the graphics
		ctx = @_ctxObjects.picker
		width = ctx.canvas.width()
		height = ctx.canvas.height()

		# Image data
		picker = @_createImageData(ctx.context, width, height)

		# Colour picker Saturation/Value
		h = @_pickerData.selectedHSV[0]
		s = 0
		v = 100

		# Inverse hue/saturation/value for the crosshair
		_h = h + 180
		_s = 100
		_v = 0

		# Loop
		col = 0
		row = 0
		i = 0

		# Current colour rgb
		rgb = []

		# Clear the current context
		ctx.context.clear()

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
				rgb = @_HSVtoRGB(_h, _s, _v)
			else
				rgb = @_HSVtoRGB(h, s, v)

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

		ctx.context.putImageData(picker, 0, 0);

		@_dumpCurrentData() if @_plugin._defaults.debug is true

	buildSpectrum: ->
		@_createCTXObject('spectrum', 'colourspectrum') if typeof @_ctxObjects.spectrum is 'undefined'

		# Prepare the graphics
		ctx = @_ctxObjects.spectrum
		width = ctx.canvas.width()
		height = ctx.canvas.height()
		gradient = ctx.context.createLinearGradient(0, 0, 0, height)

		# Properly align the spectrum
		spectrumWidth = 25
		spectrumPosLeft = (width - spectrumWidth) / 2

		# Clear the current context
		ctx.context.clear()

		# Draw the Colour stops
		i = 0
		for hue in [0..360] by 60
			rgb = @_HSVtoRGB(hue, 100, 100)
			rgb = 'rgb(' + rgb[0] + ', ' + rgb[1] + ', ' + rgb[2] + ')'
			gradient.addColorStop(i++ * 1/6, rgb)

		# Fill the canvas
		ctx.context.fillStyle = gradient
		ctx.context.fillRect(spectrumPosLeft, 0, spectrumWidth, height)

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

		ctx.context.fillStyle = ctx.context.strokeStyle = @_spectrumData.selectorColour
		ctx.context.beginPath()

		position = positions.shift()
		ctx.context.moveTo position[0], position[1]

		ctx.context.lineTo position[0], position[1] for position in positions

		ctx.context.fill()
		ctx.context.stroke()
		ctx.context.closePath()

	### Helper functions ###

	_createCTXObject: (key, canvasElement) ->
		if typeof @_ctxObjects[key] is 'undefined' then @_ctxObjects[key] = {}
		@_ctxObjects[key]['canvas'] = $ '#' + canvasElement
		@_ctxObjects[key]['context'] = @_ctxObjects[key]['canvas'][0].getContext('2d')

	_createImageData: (context, w, h) ->
		if context.createImageData?
			imgd = context.createImageData(w, h)
		else if context.getImageData?
			imgd = context.getImageData(0, 0, w, h)
		else
			imgd = {'width' : w, 'height' : h, 'data' : []}

	_dumpCurrentData: ->
		_this = @
		rgb = @_currentToRGB()

		# Assure it isn't here
		$('#colourpickerdump').remove()

		$('body').append ->
			$(document.createElement('div')).attr('id', 'colourpickerdump').append ->
				$(document.createElement('p')).text ->
					"Red: #{rgb[0]}"
			.append ->
				$(document.createElement('p')).text ->
					"Green: #{rgb[1]}"
			.append ->
				$(document.createElement('p')).text ->
					"Blue: #{rgb[2]}"
			.append ->
				$(document.createElement('hr'))
			.append ->
				$(document.createElement('p')).text ->
					"Hue: #{_this._pickerData.selectedHSV[0]}"
			.append ->
				$(document.createElement('p')).text ->
					"Saturation: #{_this._pickerData.selectedHSV[1]}"
			.append ->
				$(document.createElement('p')).text ->
					"Value: #{_this._pickerData.selectedHSV[2]}"

	_HSVtoRGB: (h, s, v) ->
		hsv = new ColourCalculatorHSV h, s, v
		hsv.getRGB()

	_RGBtoHSV: (r, g, b) ->
		rgb = new ColourCalculatorRGB r, g, b
		rgb.getHSV()

	_currentToRGB: ->
		hsv = new ColourCalculatorHSV @_pickerData.selectedHSV[0], @_pickerData.selectedHSV[1], @_pickerData.selectedHSV[2]
		hsv.getRGB()
