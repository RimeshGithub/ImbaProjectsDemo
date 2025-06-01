let canvas
let ctx

export default tag PaintApp
	prop color = "#000000"
	prop size = 5
	prop brushMode = true
	prop brushDown = false

	css self * us:none
	css .selector div border:2px solid black rd:5px cursor:pointer p:5px 10px
	css .selector .selected border:2px solid red

	def draw e
		if !brushDown
			return
		const rect = $canvas.getBoundingClientRect!
		const x = e.clientX - rect.left
		const y = e.clientY - rect.top

		ctx.lineWidth = size
		ctx.lineCap = "round"
		ctx.strokeStyle = brushMode ? color : "white"

		ctx.lineTo(x, y)
		ctx.stroke()
		ctx.beginPath()
		ctx.moveTo(x, y)
	
	def endDraw
		ctx.beginPath()

	def clearCanvas
		ctx.clearRect(0, 0, $canvas.width, $canvas.height)

	def setup
		const dpr = window.devicePixelRatio or 1
		$canvas.width = 600 * dpr
		$canvas.height = 400 * dpr
		$canvas.style.width = "600px"
		$canvas.style.height = "400px"
		ctx = $canvas.getContext("2d")
		ctx.scale(dpr, dpr)
		document.addEventListener("mousedown", do brushDown = true)
		document.addEventListener("mouseup", do brushDown = false)

	def render
		<self>
			<div [p:20px bg:#ebedee rd:10px w:700px d:vflex ja:center 
			pos:absolute left:50% top:50% translate:-50% -50%]>
				<div [mb:10px d:flex g:20px ja:center]>
					<label [d:flex ja:center g:5px]> "Brush Color: "
						<input type="color" bind=color [w:40px h:40px p:0 border:none cursor:pointer]>
					<label [d:flex ja:center g:5px w:240px]> "{brushMode ? 'Brush' : 'Eraser'} Size: "
						<input type="range" min=1 max=30 bind=size [w:150px]>
					
					<div .selector [d:flex g:10px]>
						<div .selected=brushMode @click=(brushMode = true)> "Brush"
						<div .selected=!brushMode @click=(brushMode = false)> "Eraser"

					<button @click=clearCanvas [p:10px 20px bg:#e74c3c c:white rd:6px cursor:pointer fs:14px]> "Clear Canvas"

				<canvas$canvas
					@mousedown=draw
					@mouseup=endDraw
					@mouseleave=endDraw
					@mousemove=draw
					[w:600px h:400px bg:white rd:8px box-shadow:inset 0 0 5px rgba(0,0,0,0.1) cursor:crosshair]>
			