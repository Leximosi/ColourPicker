###
Based on underscore.js
###
Array::flatten = (_flatten) ->
	_flatten = _flatten || []

	$.each this, (index, value) ->
		if $.isArray value
			value.flatten _flatten
		else
			_flatten.push value

	return _flatten
