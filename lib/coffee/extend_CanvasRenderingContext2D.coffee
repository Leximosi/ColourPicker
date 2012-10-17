###
http://stackoverflow.com/a/9722502
###
CanvasRenderingContext2D::clear = (preserveTransform) ->
		if preserveTransform
			this.save()
			this.setTransform 1, 0, 0, 1, 0, 0

		this.clearRect 0, 0, @canvas.width, @canvas.height;

		if preserveTransform
			this.restore()
