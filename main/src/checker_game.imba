export default tag CheckerGame
	prop board = []
	prop selected = null
	prop currentPlayer = 1
	prop moves = []
	prop eatable = []
	prop winner = null
	prop rotate = false
	prop hold = false

	css bg:linear-gradient(135deg,#fce4ec,#e0f7fa) us:none inset:0 of:hidden

	def setup
		board = []
		for y in [0 ... 8]
			let row = []
			for x in [0 ... 8]
				if y < 3 and (x + y) % 2 == 1
					row.push(-1)
				elif y > 4 and (x + y) % 2 == 1
					row.push(1)
				else
					row.push(0)
			board.push(row)

	def isKing v
		v == 2 or v == -2

	def isPlayer v
		v == currentPlayer or v == 2 * currentPlayer

	def valid-moves x, y
		let result = []
		let v = board[y][x]
		let dirs = isKing(v) ? [[1, -1], [-1, -1], [1, 1], [-1, 1]] : v == 1 ? [[1, -1], [-1, -1]] : [[1, 1], [-1, 1]]
		for dir in dirs
			let dx = dir[0]
			let dy = dir[1]
			let nx = x + dx
			let ny = y + dy
			if nx >= 0 and ny >= 0 and nx < 8 and ny < 8 and board[ny][nx] == 0
				result.push({x:nx, y:ny})
			else if nx + dx >= 0 and ny + dy >= 0 and nx + dx < 8 and ny + dy < 8
				if board[ny][nx] * currentPlayer < 0 and board[ny + dy][nx + dx] == 0
					result.push({x: nx + dx, y: ny + dy})
		return result

	def isEatable x, y
		eatable = []
		let v = board[y][x]
		let dirs = isKing(v) ? [[1, -1], [-1, -1], [1, 1], [-1, 1]] : v == 1 ? [[1, -1], [-1, -1]] : [[1, 1], [-1, 1]]
		for dir in dirs
			let dx = dir[0]
			let dy = dir[1]
			let nx = x + dx
			let ny = y + dy
			let ex = x + 2 * dx
			let ey = y + 2 * dy
			if nx >= 0 and ny >= 0 and ex >= 0 and ey >= 0 and nx < 8 and ny < 8 and ex < 8 and ey < 8
				if board[ny][nx] * currentPlayer < 0 and board[ey][ex] == 0
					eatable.push({x: nx, y: ny})

	def isEatableBySelected x, y
		eatable.find(do(e) e.x == x and e.y == y)

	def select x, y
		if winner
			return
		if selected
			move x, y
		else if isPlayer(board[y][x])
			selected = {x, y}
			moves = valid-moves x, y
			isEatable x, y
		else
			selected = null
			moves = []
			eatable = []

	def move x, y
		let sx = selected.x
		let sy = selected.y
		let dx = x - sx
		let dy = y - sy
		let piece = board[sy][sx]

		if Math.abs(dx) == 1 and Math.abs(dy) == 1 and ((isKing(piece) or dy == -currentPlayer) and board[y][x] == 0)
			board[y][x] = piece
			board[sy][sx] = 0
			check-king x, y
			selected = null
			moves = []
			eatable = []
			currentPlayer *= -1
			hold = true
			setTimeout(&, 800) do
				rotate = !rotate
				hold = false
				imba.commit!
			checkwin!
		else if Math.abs(dx) == 2 and Math.abs(dy) == 2
			let mx = sx + dx / 2
			let my = sy + dy / 2
			if board[my][mx] * currentPlayer < 0 and board[y][x] == 0
				board[y][x] = piece
				board[sy][sx] = 0
				board[my][mx] = 0
				check-king x, y
				selected = null
				moves = []
				eatable = []
				checkwin!
		else
			selected = null
			moves = []
			eatable = []

	def check-king x, y
		if currentPlayer == 1 and y == 0 and board[y][x] == 1
			board[y][x] = 2
		else if currentPlayer == -1 and y == 7 and board[y][x] == -1
			board[y][x] = -2

	def isSelected x, y
		selected and selected.x == x and selected.y == y

	def isPossibleMove x, y
		moves.find(do(m) m.x == x and m.y == y)

	def checkwin
		let opponent = -currentPlayer
		let hasMoves = false
		for y in [0 ... 8]
			for x in [0 ... 8]
				let piece = board[y][x]
				if piece * opponent > 0
					let dirs = isKing(piece) ? [[1,-1],[-1,-1],[1,1],[-1,1]] : piece == 1 ? [[1,-1],[-1,-1]] : [[1,1],[-1,1]]
					for dir in dirs
						let nx = x + dir[0]
						let ny = y + dir[1]
						let ex = x + 2 * dir[0]
						let ey = y + 2 * dir[1]

						if nx >= 0 and ny >= 0 and nx < 8 and ny < 8 and board[ny][nx] == 0
							hasMoves = true
						else if ex >= 0 and ey >= 0 and ex < 8 and ey < 8
							if board[ny][nx] * opponent < 0 and board[ey][ex] == 0
								hasMoves = true

		if not hasMoves
			winner = currentPlayer

	def render
		<self>
			<div [pos:absolute top:50% left:50% translate:-50% -50% d:vflex ja:center g:20px]>
				<div [ff:monospace fs:30px mt:-25px h:40px]>
					hold ? "  " : (winner ? (winner == 1 ? "White Wins!" : "Black Wins!") : currentPlayer == 1 ? "White's Turn" : "Black's Turn")
				<div .rotate=rotate [p:20px bg:brown rd:12px box-shadow:0 0px 20px rgba(0,0,0,0.2) rotate.rotate:180deg tween:transform .5s]>
					<div [d:grid grid-template-columns:repeat(8,1fr) grid-template-rows:repeat(8,1fr) g:0px border:2px solid #333]>
						for y in [0 ... 8]
							for x in [0 ... 8]
								<div @click=select(x,y) [
									w:50px h:50px
									bg: {isEatableBySelected(x,y) ? "#FF0000" : (x + y) % 2 == 1 ? "#8B4513" : "#F5DEB3"}
									cursor:pointer tween:all .3s
									d:flex ai:center jc:center
									border: 2px solid {isSelected(x,y) ? "#FFD700" : isPossibleMove(x,y) ? "#00FF00" : "#333"}
								]>
									if board[y][x] == 1 or board[y][x] == 2
										<div .rotate=rotate [w:30px h:30px rd:50% bg:radial-gradient(circle, #fff, #999) box-shadow:0 0 5px rgba(0,0,0,0.5) 
										d:flex ja:center fs:15px c:#777 rotate.rotate:180deg]>
											if board[y][x] == 2
												"♛"
									elif board[y][x] == -1 or board[y][x] == -2
										<div .rotate=rotate [w:30px h:30px rd:50% bg:radial-gradient(circle, #666, #222) box-shadow:0 0 5px rgba(255,255,255,0.5) 
										d:flex ja:center fs:15px c:#aaa rotate.rotate:180deg]>
											if board[y][x] == -2
												"♛"

