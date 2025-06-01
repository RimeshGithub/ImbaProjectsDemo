let difficulty = 46  # medium
let selected
let emptyCells = []
let checktimeout

export default tag SudokuGame
	prop board = generateSudoku(difficulty)
	prop checkcell = false
	prop gameover = false

	css ff:monospace
	css bg:radial-gradient(ellipse,brown,brown5) inset:0

	css .filled-cell fs:25px fw:bold bg:#ddd c:#666
	css .empty-cell fs:23px bg:gray1 c:#555
	css .selected-cell bg:#cce5ff
	css .correct-cell bg:green3 fw:bold
	css .incorrect-cell bg:red3 fw:bold

	def selectCell row, col
		if !isFilledCell(row, col) and !gameover
			if selected.row is row and selected.col is col
				selected = { row: null, col: null }
			else
				selected = { row, col }
	
	def isFilledCell row, col
		!emptyCells.find(do(cell) cell.row is row and cell.col is col)

	def inputNumber num
		num = parseInt(num)
		if selected.row isnt null and selected.col isnt null
			board[selected.row][selected.col] = num
			checkwin!

	def clearCell
		if selected.row isnt null and selected.col isnt null
			board[selected.row][selected.col] = ""

	def reset
		for row in [0 .. 8]
			for col in [0 .. 8]
				if !isFilledCell(row, col)
					board[row][col] = ""
	
	def check
		checkcell = true
		if checktimeout then clearTimeout(checktimeout)
		checktimeout = setTimeout(&, 3000) do
			checkcell = false
			imba.commit!
		
	def hint
		if selected.row isnt null and selected.col isnt null
			let num = emptyCells.find(do(cell) cell.row is selected.row and cell.col is selected.col) ?.value
			board[selected.row][selected.col] = num
			checkwin!

	def isValid row, col, num
		if num == emptyCells.find(do(cell) cell.row is row and cell.col is col) ?.value
			return true 
		else 
			return false

	def emptyOrFilled row, col
		if board[row][col] == "" or isFilledCell(row, col)
			return true
		else 
			return false

	def generateSudoku emptyCount
		selected = { row: null, col: null }
		let fullBoard = Array(9).fill(null).map(do Array(9).fill(""))
		fillBoard(fullBoard)
		let puzzle = JSON.parse(JSON.stringify(fullBoard))
		gameover = false
		emptyCells = []
		removeCells(puzzle, emptyCount)
		return puzzle

	def fillBoard b
		for row in [0 .. 8]
			for col in [0 .. 8]
				if b[row][col] is ""
					let nums = [1,2,3,4,5,6,7,8,9].sort(do Math.random() - 0.5)
					for num in nums
						if isValidFill(b, row, col, num)
							b[row][col] = num
							if fillBoard(b)
								return true
							b[row][col] = ""
					return false
		return true

	def isValidFill b, row, col, num
		for i in [0 .. 8]
			if b[row][i] is num or b[i][col] is num
				return false
		let startRow = Math.floor(row / 3) * 3
		let startCol = Math.floor(col / 3) * 3
		for i in [0 .. 2]
			for j in [0 .. 2]
				if b[startRow + i][startCol + j] is num
					return false
		return true

	def removeCells b, count
		let removed = 0
		while removed < count
			let row = Math.floor(Math.random() * 9)
			let col = Math.floor(Math.random() * 9)
			if b[row][col] isnt ""
				emptyCells.push({row, col, value: b[row][col]})
				b[row][col] = ""
				removed += 1
	
	def checkwin
		for row in [0 .. 8]
			for col in [0 .. 8]
				if !isFilledCell(row, col)
					let correctcell = emptyCells.find(do(cell) cell.row is row and cell.col is col).value
					if board[row][col] isnt correctcell
						return
		selected = { row: null, col: null }
		gameover = true
		setTimeout(&, 1200) do
			window.alert("You win!")

	def setup
		document.addEventListener("keyup",do(e)
			if !isNaN(Number(e.key)) and e.key != "0"
				inputNumber(e.key)
				imba.commit!
		)

	def render
		<self>
			<div [pos:absolute top:50% left:50% translate:-50% -50% w:360px p:20px bg:linear-gradient(135deg,#fff0f5,#e0ffff) rd:12px 
			box-shadow:0 0 12px rgba(255,255,255,0.5) d:vflex ja:center g:20px]>
				<div [d:flex g:20px ja:center]>
					<h1> "Sudoku"
					<div [border:2px solid #ccc d:flex p:5px 10px g:20px rd:10px ja:center]>
						<label [d:flex g:5px]> "Difficulty: "
							<select @change=(do(e) difficulty = parseInt(e.target.value))>
								<option value=40> "Easy"
								<option value=46 selected> "Medium"
								<option value=54> "Hard"
								<option value=64> "Expert"
						<button @click=(do board = generateSudoku(difficulty)) [cursor:pointer rd:6px bg@active:#ddd]> "New Game"
				
				<div [border:2px solid #ccc d:flex p:5px 10px g:20px rd:10px ja:center mt:-20px w:90%]>
					<button disabled=gameover @click=check [rd:6px cursor:pointer bg@active:#ddd fw:bold p:5px w:60px]> "Check"
					<button disabled=gameover @click=hint [rd:6px cursor:pointer bg@active:#ddd fw:bold p:5px w:60px]> "Hint"
					<button disabled=gameover @click=reset [rd:6px cursor:pointer bg@active:#ddd fw:bold p:5px w:60px]> "Reset"

				<div [d:grid grid-template-columns:repeat(9, 1fr) g:2px]>
					for row, i in board
						for cell, j in row
							<div [w:36px h:36px d:flex ja:center rd:6px cursor:pointer border:1px solid #ccc] .filled-cell=isFilledCell(i, j) 
							.empty-cell=!isFilledCell(i, j) .selected-cell=(selected.row is i and selected.col is j) 
							.correct-cell=(isValid(i, j, board[i][j]) and checkcell and !emptyOrFilled(i, j)) 
							.incorrect-cell=(!isValid(i, j, board[i][j]) and checkcell and !emptyOrFilled(i, j))
							@click=selectCell(i, j)> cell

				<div [d:grid grid-template-columns:repeat(5, 1fr) g:10px border:2px solid #ccc p:5px 10px rd:10px w:90%]>
					for n in [1 .. 9]
						<button disabled=gameover @click=inputNumber(n) [p:5px bg:#fff rd:6px cursor:pointer bg@active:#ddd fs:20px fw:bold]> n
					<button disabled=gameover @click=clearCell [p:10px rd:6px cursor:pointer bg@active:#ddd fw:bold]> "Clear"

