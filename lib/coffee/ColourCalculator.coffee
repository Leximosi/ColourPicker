#  Project: Leximosi Colour Picker
#  Description: Simple canvas and jQuery based colour picker
#  Author: Erik Frèrejean (http://leximosi.github.com)
#  License: MIT license - http://opensource.org/licenses/mit-license.php
###
Class designed to calculate between various colour formats
###
class ColourCalculator
	constructor: ->

	###
Get the HEX value of the current colour
	###
	getHEX: ->
		@_calculateHEX()
		@hex

	###
Get the HSV value of the current colour
	###
	getHSV: (raw) ->
		@_calculateHSV()

		raw = raw || false

		if raw isnt true then [
			Math.round @h * 60
			Math.round @s * 100
			Math.round @v * 100
		] else [
			@h
			@s
			@v
		]

	###
Get the RGB value of the current colour
	###
	getRGB: (raw) ->
		@_calculateRGB()

		raw = raw || false

		if raw isnt true then [
			Math.round @r * 255
			Math.round @g * 255
			Math.round @b * 255
		] else [
			@r
			@g
			@b
		]

	###
Get the RGBA value of the current colour
	###
	getRGBA: ->
		@_calculateRGB()

		raw = raw || false

		if raw isnt true then [
			Math.round @r * 255
			Math.round @g * 255
			Math.round @b * 255
			@alpha
		] else [
			@r
			@g
			@b
			@alpha
		]

	###
Build the HEX string
	###
	_calculateHEX: ->
		rgb = @getRGB()

		@hex = '#'
		for c in rgb
			@hex += ("0" + parseInt(c, 10).toString(16))[-2..]

	###
Transform an RGB colour into its HSV value
	###
	_calculateHSV: ->
		return if typeof @s isnt "undefined"

		min		= Math.min @r, @g, @b
		max		= Math.max @r, @g, @b
		delta	= max - min

		@v = max

		if max is 0
			# r = g = b = 0
			@s = 0

			# Quick 'n dirty hack
			@h = -1 / 60
		else
			@s = delta / max

			if @r is max
				@h = (@g - @b) / delta
			else if @g is max
				@h = 2 + (@b - @r) / delta
			else
				@h = 4 + (@r - @g) /delta

	###
Transform an HSV colour into its RGB value
Per: http://en.wikipedia.org/wiki/HSL_and_HSV#From_HSV
	###
	_calculateRGB: ->
		return if typeof @r isnt "undefined"

		if @s is 0
			@r = @g = @b = @v
		else
			_i = Math.floor(@h)
			_f = @h - _i
			_p = @v * (1 - @s)
			_q = @v * (1 - @s * _f)
			_t = @v * (1 - @s * (1 - _f))

			switch _i
				when 0
					@r = @v
					@g = _t
					@b = _p

				when 1
					@r = _q
					@g = @v
					@b = _p

				when 2
					@r = _p
					@g = @v
					@b = _t

				when 3
					@r = _p
					@g = _q
					@b = @v

				when 4
					@r = _t
					@g = _p
					@b = @v

				when 5
					@r = @v
					@g = _p
					@b = _q
