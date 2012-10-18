###
http://stackoverflow.com/a/9722502
###
CanvasRenderingContext2D::clear = (preserveTransform) ->
		if preserveTransform
			@save()
			@setTransform 1, 0, 0, 1, 0, 0

		@clearRect 0, 0, @canvas.width, @canvas.height;

		if preserveTransform
			@restore()
