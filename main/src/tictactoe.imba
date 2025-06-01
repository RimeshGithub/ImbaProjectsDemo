export default tag Tictactoe
	prop board = Array(9).fill("")
	prop currentPlayer = "X"
	prop winner = ""
	prop gameOver = false
	prop combos
	prop a
	prop b
	prop c

	css .cell bg:white h:80px d:flex ai:center jc:center rd:12px fs:32px fw:bold cursor:pointer bg@hover:#f0f0f0 transition:all 0.3s ease
	css .line bg:#ddd color:red

	def reset
		board = Array(9).fill("")
		currentPlayer = "X"
		winner = ""
		gameOver = false
		for i in [0 ... 9]
			document.getElementById(i.toString!).classList.remove("line")

	def checkWinner
		combos = [
			[0,1,2],[3,4,5],[6,7,8], # rows
			[0,3,6],[1,4,7],[2,5,8], # cols
			[0,4,8],[2,4,6]          # diagonals
		]
		for combo in combos
			[a,b,c] = combo
			if board[a] != "" and board[a] == board[b] and board[b] == board[c]
				winner = board[a]
				for i in combo
					document.getElementById(i).classList.add("line")
				gameOver = true
				return

		if board.every(do(v) v != "")
			winner = "Draw"
			gameOver = true

	def makeMove index
		if board[index] == "" and not gameOver
			board[index] = currentPlayer
			checkWinner()
			currentPlayer = if currentPlayer == "X" then "O" else "X"

	def render
		<self>
			<div [w:300px pos:absolute top:50% left:50% translate:-50% -50% p:20px 
			bg:linear-gradient(135deg,#fff0f5,#e0ffff) rd:16px box-shadow:0 0 20px rgba(0,0,0,0.2)]>
				<div [fs:24px ta:center mb:10px fw:bold c:#333]> winner == "" ? "Current Player: {currentPlayer}" : (winner == "Draw" ? "It's a Draw!" : "Winner: {winner}")
				<div [d:grid grid-template-columns:repeat(3,1fr) g:10px mt:20px mb:20px]>
					for val, i in board
						<div .cell id=i @click=makeMove(i)> val
				<button @click=reset [w:100% p:10px fs:16px bg:#4CAF50 c:white rd:8px cursor:pointer bg@active:#388e3c]> "NEW GAME"

