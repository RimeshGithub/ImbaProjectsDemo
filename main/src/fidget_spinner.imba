export default tag FidgetSpinner
	prop angle = 0
	prop accelaration = 0
	prop spinCount = 0
	prop lastSpin = 0

	def setup
		setInterval((do animateSpin!),1)
		document.addEventListener("keydown",(do(e)
			if e.code == "Space"
				increaseSpeed!
			elif e.code == "ShiftLeft"
				decreaseSpeed!))

	def increaseSpeed
		accelaration += 0.2
	
	def decreaseSpeed
		if accelaration > 0
			accelaration -= 0.2
		else 
			accelaration = 0

	def animateSpin
		angle += accelaration
		if angle - lastSpin >= 360
			spinCount += 1
			lastSpin += 360
		$ref.style.transform = "rotate({angle}deg)"
		$ref.style.transition = "transform 0.3s linear"
		imba.commit!
		if accelaration > 0
			accelaration -= 0.005
		else
			accelaration = 0

	def render
		<self [d:flex jc:center ai:center inset:0 bg:radial-gradient(circle, #000, #333)]>
			<div$ref [cursor:none mt:-150px pos:relative]>
				<div [w:50px h:180px bg:red box-shadow:0 0 20px red pos:absolute rotate:0deg top:50% left:50% transform-origin:bottom translate:-50% -100%]>
				<div [w:50px h:180px bg:blue box-shadow:0 0 20px blue pos:absolute rotate:120deg top:50% left:50% transform-origin:bottom translate:-50% -100%]>
				<div [w:50px h:180px bg:green box-shadow:0 0 20px green pos:absolute rotate:240deg top:50% left:50% transform-origin:bottom translate:-50% -100%]>
				<div [w:40px h:40px rd:50% border:15px solid #eee box-shadow:0 0 10px white pos:absolute top:50% left:50% translate:-50% -50% bg:white]>
			<div [pos:absolute bottom:20% fs:30px c:white ff:monospace]> "Speed: {accelaration.toFixed(2)}"
			<div [pos:absolute bottom:10% fs:26px c:#f0f0f0 ff:monospace]> "Spins: {spinCount}"

