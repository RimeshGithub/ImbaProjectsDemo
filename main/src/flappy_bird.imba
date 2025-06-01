let gameOver = false
let birdY = 200
let birdVY = 0
let gravity = 0.4
let jumpStrength = -6
let pipes = [{x:400,y:350},{x:600,y:250},{x:800,y:350},{x:1000,y:300},{x:1200,y:250}]
let score = 0
let gameStarted = false
let wingrotate = 0

def jump
	if !gameOver
		birdVY = jumpStrength
		wingrotate = 40
		setTimeout(&, 100) do
			wingrotate = -20

def reset
	birdY = 200
	birdVY = 0
	score = 0
	gameOver = false
	gameStarted = false
	pipes = [{x:400,y:350},{x:600,y:250},{x:800,y:350},{x:1000,y:300},{x:1200,y:250}]

def tick
	if gameOver
		return

	birdVY += gravity
	birdY += birdVY

	for pipe in pipes
		pipe.x -= 2

	if pipes[0].x < -60
		pipes.shift!
		let newY = 100 + Math.random! * 200
		pipes.push({x: pipes[-1].x + 200, y: newY})
		score += 1

	for pipe in pipes
		if pipe.x < 80 and pipe.x > 0
			if birdY < pipe.y - 150 or birdY > pipe.y - 40
				gameOver = true

	if birdY > 460 or birdY < 0
		gameOver = true

	imba.commit()
	window.requestAnimationFrame(tick)

export default tag FlappyBird
	def setup
		document.addEventListener("keyup", do(e)
			if e.code == "Space"
				if !gameStarted and !gameOver
					gameStarted = true
					tick()
				jump()
		)


	def render
		let birdAngle = Math.max(Math.min(birdVY * 4, 90), -30)

		<self>
			<div [w:400px h:500px bg:linear-gradient(to bottom,#87ceeb,#fff) of:hidden pos:absolute top:50% left:50% transform:translate(-50%,-50%) rd:15px box-shadow:0 0 20px rgba(0,0,0,0.2)]>
				<div [pos:absolute left:50px top:{birdY}px w:40px h:40px bg:yellow rd:15% box-shadow:0 0 5px rgba(0,0,0,0.3) 
				rotate:{birdAngle}deg transition:transform 0.2s]> 
					<div [transform:scaleX(-1.5) rotate({wingrotate}deg) fs:30px translate:-15px -5px tween:transform 0.2s]> "🪽"

				for pipe in pipes
					<div [pos:absolute left:{pipe.x}px top:0 w:60px h:{pipe.y - 150}px bg:green rd:8px box-shadow:inset 0 0 10px rgba(0,0,0,0.2)]>
					<div [pos:absolute left:{pipe.x}px top:{pipe.y}px w:60px h:500px bg:green rd:8px box-shadow:inset 0 0 10px rgba(0,0,0,0.2)]>

				<div [pos:absolute top:10px left:10px fs:18px fw:bold c:#333]> "Score: {score}"

				if gameOver
					<div [pos:absolute top:50% left:50% transform:translate(-50%,-50%) fs:22px fw:bold c:#fff d:vflex ja:center bg:rgba(0,0,0,0.3) w:80% g:10px p:20px]>
						<p> "Game Over!"
						<p> "Your final score was: {score}"
						<button @click=reset [p:10px bg:#eee rd:8px box-shadow:0 2px 5px rgba(0,0,0,0.2) cursor:pointer bg@active:#fff fs:16px fw:bold c:#333] > "Restart"

