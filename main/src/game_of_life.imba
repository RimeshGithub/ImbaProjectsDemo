let size = 25
let running = false
let intervalId = null
let fps = 5
let gridSizePx = 500
let grid = Array(size).fill(null).map do Array(size).fill(0)

def countNeighbors(x, y)
	let dirs = [-1, 0, 1]
	let count = 0
	for dy in dirs
		for dx in dirs
			continue if dx == 0 and dy == 0
			let ny = (y + dy + size) % size
			let nx = (x + dx + size) % size
			count += grid[ny][nx]
	return count

export default tag GameOfLife
	css bg:linear-gradient(135deg,#e3f2fd,#f3e5f5) inset:0

	def toggleCell x, y
		stop!
		grid[y][x] = grid[y][x] == 1 ? 0 : 1

	def clearGrid
		stop!
		grid = Array(size).fill(null).map do Array(size).fill(0)

	def randomizeGrid
		stop!
		grid = Array(size).fill(null).map do
			Array(size).fill(null).map do Math.random() > 0.7 ? 1 : 0

	def start
		running = true
		intervalId = setInterval(runStep, 1000 / fps)

	def stop
		running = false
		clearInterval(intervalId)

	def toggleRun
		running ? stop() : start()

	def runStep
		let next = grid.map(do(row) [...row])
		for y in [0 ... size]
			for x in [0 ... size]
				let neighbors = countNeighbors(x, y)
				if grid[y][x] == 1
					if neighbors > 3 or neighbors < 2
						next[y][x] = 0
					else
						next[y][x] = 1
				else
					next[y][x] = neighbors == 3 ? 1 : 0
		grid = next
		imba.commit!

	def render
		let cellSize = gridSizePx / size
		<self>
			<div [pos:absolute top:50% left:50% translate:-50% -50% d:vflex ja:center g:40px]>
				<div [size:{gridSizePx}px d:grid grid-template-columns:repeat({size}, {cellSize * 0.9}px) gap:{cellSize / 10}px]>
					for y in [0 ... size]
						for x in [0 ... size]
							<div @click=toggleCell(x, y)
							[bg:{grid[y][x] == 1 ? "#4caf50" : "#fff"} size:{cellSize * 0.9 - 2}px rd:4px cursor:pointer border:1px solid #ccc]>

				<div [d:flex gap:20px jc:center]>
					<button @click=toggleRun [w:100px p:10px 0px bg:#2196f3 c:white rd:8px cursor:pointer bg@active:#1976d2]>
						running ? "Pause" : "Play"
					<button @click=randomizeGrid [w:100px p:10px 0px bg:#ff9800 c:white rd:8px cursor:pointer bg@active:#f57c00]> "Random"
					<button @click=clearGrid [w:100px p:10px 0px bg:#f44336 c:white rd:8px cursor:pointer bg@active:#d32f2f]> "Clear"

					<div [d:flex ja:center g:10px]>
						<span> "FPS: "
						<input type="range" min=1 max=30 bind=fps @input=(do stop!; start!)>
						<span [w:10px]> fps

					<div [d:flex ja:center g:10px]>
						<span> "Size: "
						<input type="range" min=10 max=50 step=5 bind=size @input=(do stop!; clearGrid!)>
						<span [w:10px]> size

