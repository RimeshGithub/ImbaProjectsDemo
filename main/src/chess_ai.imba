import * as ChessEngine from 'js-chess-engine'

let currentFEN = null
let selected = null
let legalTargets = []
let lastMove = null
let difficulty = 2
let engine = new ChessEngine.Game()
let whiteCaptured = []
let blackCaptured = []

const initialCounts = {
	P: 8, R: 2, N: 2, B: 2, Q: 1, K: 1,
	p: 8, r: 2, n: 2, b: 2, q: 1, k: 1
}

const pieceEmojis = {
	p: "♟", r: "♜", n: "♞", b: "♝", q: "♛", k: "♚",
	P: "♙", R: "♖", N: "♘", B: "♗", Q: "♕", K: "♔"
}

def updateBoard
	currentFEN = engine.exportFEN()
	updateCaptured!

def countPieces fen
	let counts = {}
	for own k of initialCounts
		counts[k] = 0
	let board = toBoard(fen)
	for row in board
		for piece in row
			if piece
				counts[piece] = counts[piece] + 1
	return counts

def updateCaptured
	let current = countPieces(currentFEN)
	whiteCaptured = []
	blackCaptured = []

	for own piece of initialCounts
		let missing = initialCounts[piece] - current[piece]
		if missing > 0
			for i in [0...missing]
				if piece.toUpperCase! == piece
					whiteCaptured.push piece
				else
					blackCaptured.push piece

def toBoard fen
	let parts = fen.split(" ")[0].split("/")
	let board = []
	for row in parts
		let r = []
		for c in row
			if isNaN(c)
				r.push c
			else
				for i in [0...parseInt(c)]
					r.push null
		board.push(r)
	return board

def toSquare row, col
	return 'abcdefgh'[col] + (8 - row)

def fromSquare square
	let file = square.charCodeAt(0) - 'a'.charCodeAt(0)
	let rank = 8 - parseInt(square[1])
	return [rank, file]

def isWhiteTurn
	return currentFEN.split(" ")[1] == "w"

def isKingInCheck(color)
	let json = engine.exportJson()
	let kingSymbol = color == 'white' ? 'K' : 'k'
	let kingPos = null

	# Find king's position
	for own square, piece of json.pieces
		if piece == kingSymbol
			kingPos = square
			break

	if not kingPos
		return false

	# Temporarily create a cloned engine with opposite turn
	let clone = new ChessEngine.Game(engine.exportFEN())
	let opponentTurn = color == 'white' ? 'black' : 'white'
	let fenParts = clone.exportFEN().split(' ')
	fenParts[1] = opponentTurn[0]  # 'w' or 'b'
	clone = new ChessEngine.Game(fenParts.join(' '))

	# Now get the opponent's moves
	let oppMoves = clone.exportJson().moves

	for own fromSquare, moves of oppMoves
		for toSquare in moves
			if toSquare == kingPos
				return true

	return false

tag captured-pieces-ai
	prop pieces
	prop color

	def render
		<self>
			<div [rd:15px w:200px h:230px border:2px solid d:vflex ai:center]>
				<h3> "{color} pieces lost:"
				<div [d:grid gtc:repeat(4, 1fr) g:6px fs:24px column-gap:15px]>
					for piece in pieces
						<span> pieceEmojis[piece]

tag render-square-ai
	prop row
	prop col

	def handleClick row, col
		if not isWhiteTurn or engine.exportJson().isFinished
			return

		let square = toSquare(row, col)
		let piece = toBoard(currentFEN)[row][col]

		if selected
			let possibleMoves = engine.moves(selected) or []
			if Array.isArray(possibleMoves) and possibleMoves.includes(square.toUpperCase!)
				engine.move(selected, square)
				lastMove = [selected, square]
				selected = null
				legalTargets = []
				updateBoard()
				setTimeout(&, 1500) do
					let compMove = engine.aiMove(difficulty)
					lastMove = [Object.keys(compMove)[0], Object.values(compMove)[0]]
					imba.commit!
					updateBoard()
				return
			else
				legalTargets = []
				selected = null

		if piece and piece.toUpperCase() == piece and isWhiteTurn
			selected = square
			legalTargets = engine.moves(square)


	def render
		let boardArr = toBoard(currentFEN)
		let square = toSquare(row, col)
		let piece = boardArr[row][col]
		let isSelected = selected == square
		let isLegalTarget = legalTargets.includes(square.toUpperCase!)
		let isLastFrom = lastMove and lastMove[0].toLowerCase! == square
		let isLastTo = lastMove and lastMove[1].toLowerCase! == square
		let baseColor = (row + col) % 2 == 0 ? "#f0d9b5" : "#b58863"
		let bg = isLastFrom or isLastTo ? "blue1" : (isSelected ? "gold" : baseColor)
		let content = piece ? pieceEmojis[piece] or "" : ""

		<self>
			<div @click=handleClick(row, col) [
				pos:relative w:52px h:52px d:flex ai:center jc:center 
				fs:42px rd:6px bg:{bg} border:1px solid cursor:pointer
				transition:background 0.3s
			]>
				if isLegalTarget and not piece
					<div [pos:absolute w:14px h:14px rd:50% bg:rgba(0,0,0,0.5)]>
				if isLegalTarget and piece
					<div [pos:absolute w:100% h:100% rd:5px bg:rgba(255,0,0,0.9)]>
				<div [zi:1]> content

export default tag ChessboardAI
	css self * us:none

	def render
		if not currentFEN
			updateBoard()

		let json = engine.exportJson()

		<self>
			<div [pos:absolute top:50% left:50% translate:-50% -50% d:vflex g:20px ja:center mt:-1%]>

				<div [fs:25px c:#333 ff:monospace w:100% ta:center h:50px]> 
					json.isFinished ? (isWhiteTurn! ? "Checkmate! Computer wins" : "Checkmate! You win") : (isKingInCheck("white") ? "♔ Your King is in Check!" : (isKingInCheck("black") ? "♚ Computer's King is in Check!" : (isWhiteTurn! ? "♕ Your turn" : "♛ Computer's turn")))


				<div [d:flex g:30px ja:center]>

					<div [d:vflex ja:center g:20px w:200px border:2px solid h:400px rd:15px]>
						<h1> "Chess AI"
						<div [d:flex ja:center g:5px]>
							<span [fs:16px c:#333 mt:2px]> "Difficulty: "
							<select @change=(do(e) difficulty = parseInt(e.target.value)) [
								p:6px fs:14px rd:4px border:1px solid #aaa
							]>
								<option value="1"> "Easy"
								<option value="2" selected> "Medium"
								<option value="3"> "Hard"
								<option value="4"> "Extreme"

					<div [
						p:18px d:grid grid-template-columns:repeat(8, 1fr) rd:15px align-self:center
						g:2px bg:brown box-shadow:0 0px 16px rgba(0,0,0,0.25)
					]>
						for row in [0 ... 8]
							for col in [0 ... 8]
								<render-square-ai row=row col=col>

					<div [d:vflex ja:center g:20px]>
						<captured-pieces-ai pieces=blackCaptured color="Black">
						<captured-pieces-ai pieces=whiteCaptured color="White">

