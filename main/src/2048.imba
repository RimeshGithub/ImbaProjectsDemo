tag tile
	prop value = 0

	def tileColor val
		switch val
			when 0 then "#ccc"
			when 2 then "#eee4da"
			when 4 then "#ede0c8"
			when 8 then "#f2b179"
			when 16 then "#f59563"
			when 32 then "#f67c5f"
			when 64 then "#f65e3b"
			when 128 then "#edcf72"
			when 256 then "#edcc61"
			when 512 then "#edc850"
			when 1024 then "#edc53f"
			when 2048 then "#edc22e"
			else "#3c3a32"
	def render
		<self>
			<div [d:flex ai:center jc:center fs:24px fw:bold rd:8px h:80px w:80px bg:#eee c:#333 transition:all 0.2s ease-in-out ta:center bg:{tileColor(value)}]>
				if value > 0
					value

export default tag Game2048
	prop size = 4
	prop grid = []
	prop score = 0
	prop gameOver = false

	def setup
		grid = Array(size).fill(0).map do Array(size).fill(0)
		addRandomTile()
		addRandomTile()
		document.addEventListener("keyup", do(e) handleKey e)

	def addRandomTile
		let emptyCells = []
		for y in [0...size]
			for x in [0...size]
				if grid[y][x] == 0
					emptyCells.push([y, x])
		if emptyCells.length == 0
			return
		let [y, x] = emptyCells[Math.floor(Math.random() * emptyCells.length)]
		grid[y][x] = Math.random() < 0.95 ? 2 : 4

	def slide row
		let newRow = row.filter(do(n) n != 0)
		for i in [0...newRow.length - 1]
			if newRow[i] == newRow[i + 1]
				if newRow[i]
					newRow[i] *= 2
					score += newRow[i]
					newRow[i + 1] = 0
		newRow = newRow.filter(do(n) n != 0)
		while newRow.length < size
			newRow.push(0)
		return newRow

	def moveLeft
		let moved = false
		for y in [0...size]
			let newRow = slide(grid[y])
			if JSON.stringify(newRow) != JSON.stringify(grid[y])
				grid[y] = newRow
				moved = true
		if moved
			addRandomTile()
			if isGameOver()
				gameOver = true

	def moveRight
		let moved = false
		for y in [0...size]
			let reversed = grid[y].slice().reverse()
			let newRow = slide(reversed).reverse()
			if JSON.stringify(newRow) != JSON.stringify(grid[y])
				grid[y] = newRow
				moved = true
		if moved
			addRandomTile()
			if isGameOver()
				gameOver = true

	def moveUp
		let moved = false
		for x in [0...size]
			let col = []
			for y in [0...size]
				col.push(grid[y][x])
			let newCol = slide(col)
			for y in [0...size]
				if grid[y][x] != newCol[y]
					grid[y][x] = newCol[y]
					moved = true
		if moved
			addRandomTile()
			if isGameOver()
				gameOver = true

	def moveDown
		let moved = false
		for x in [0...size]
			let col = []
			for y in [0...size]
				col.push(grid[y][x])
			let reversed = col.slice().reverse()
			let newCol = slide(reversed).reverse()
			for y in [0...size]
				if grid[y][x] != newCol[y]
					grid[y][x] = newCol[y]
					moved = true
		if moved
			addRandomTile()
			if isGameOver()
				gameOver = true

	def isGameOver
		for y in [0...size]
			for x in [0...size]
				if grid[y][x] == 0
					return false
				if x < size - 1 and grid[y][x] == grid[y][x + 1]
					return false
				if y < size - 1 and grid[y][x] == grid[y + 1][x]
					return false
		setTimeout(&, 1000) do
			window.alert "Game Over! Your final score is {score}"
		return true

	def handleKey e
		if gameOver
			return
		switch e.key
			when 'ArrowLeft'
				moveLeft()
			when 'ArrowRight'
				moveRight()
			when 'ArrowUp'
				moveUp()
			when 'ArrowDown'
				moveDown()
		imba.commit!

	def render
		<self>
			<div [w:360px p:20px bg:linear-gradient(135deg,#fafafa,#e0e0e0) rd:12px box-shadow:0 4px 20px rgba(0,0,0,0.2) pos:absolute top:50% left:50% transform:translate(-50%,-50%)]>
				<div [fs:24px mb:10px c:#333 fw:bold ta:center]> "2048 Game"
				<div [fs:18px mb:10px c:#555 ta:center]> "Score: {score}"
				<div.grid [display:grid grid-template-columns:repeat(4, 1fr) gap:10px]>
					for y in [0...size]
						for x in [0...size]
							<tile value=grid[y][x]>

