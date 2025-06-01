import { Chess } from 'chess.js'

let game = new Chess()
let selected = null
let board = game.board()
let legalTargets = [] 
let lastMove = null
let capturedWhite = []
let capturedBlack = []
let rotate = false
let hold = false

const pieceEmojis = {
	p: "♟", r: "♜", n: "♞", b: "♝", q: "♛", k: "♚",
	P: "♙", R: "♖", N: "♘", B: "♗", Q: "♕", K: "♔"
}

tag render-square
	prop row
	prop col

	css .rotate rotate:180deg

	def toSquare row, col
		return 'abcdefgh'[col] + (8 - row)

	def handleClick row, col
		const piece = board[row][col]
		const square = toSquare(row, col)

		if selected
			const moves = game.moves({ square: selected, verbose: true })
			const targetMove = moves.find do(m) m.to == square
			if targetMove
				let target = game.get(targetMove.to)
				if target
					if target.color == 'w'
						capturedWhite.push(target)
					else
						capturedBlack.push(target)

				game.move(targetMove)
				lastMove = [targetMove.from, targetMove.to]
				selected = null
				board = game.board()
				legalTargets = []
				hold = true
				setTimeout(&, 800) do
					hold = false
					rotate = !rotate
					imba.commit!
				return
			else
				selected = null
				legalTargets = []

		if piece and piece.color == game.turn()
			let legal = game.moves({ square: selected, verbose: true })
			if legal.length > 0
				selected = square
				legal = game.moves({ square: selected, verbose: true })
				legalTargets = legal.map do(m) m.to

	def render
		let piece = board[row][col]
		let square = toSquare(row, col)
		let isSelected = selected == square
		let isLegalTarget = legalTargets.includes(square)
		let isLastFrom = lastMove and lastMove[0] == square
		let isLastTo = lastMove and lastMove[1] == square
		let baseColor = (row + col) % 2 == 0 ? "#f0d9b5" : "#b58863"
		let bg = isLastFrom or isLastTo ? "blue1" : (isSelected ? "gold" : baseColor)
		let content = piece ? pieceEmojis[(piece.color == "w" ? piece.type.toUpperCase() : piece.type)] : ""

		<self>
			<div @click=handleClick(row, col) [
				pos:relative w:52px h:52px d:flex ai:center jc:center 
				fs:42px rd:6px bg:{bg} border:1px solid cursor:pointer tween:background 0.3s
			]>
				if isLegalTarget and not piece
					<div [pos:absolute w:14px h:14px rd:50% bg:rgba(0,0,0,0.5)]>
				if isLegalTarget and piece
					<div [pos:absolute w:100% h:100% rd:5px bg:rgba(255,0,0,0.9)]>
				<div [zi:1] .rotate=rotate> content

tag lost-pieces
	prop list
	prop piece

	def render
		<self>
			<div [d:vflex g:8px ai:center fs:28px p:6px c:#222 w:200px h:255px border:2px solid rd:15px]>
				<p [fs:25px fw:bold]> "{piece} pieces lost:"
				<div [d:grid gtc:repeat(4, 1fr) g:6px column-gap:15px mt:-10px]>
					for piece in list
						<span> pieceEmojis[piece.color == "w" ? piece.type.toUpperCase() : piece.type]

export default tag Chessboard
	css us:none inset:0 of:hidden
	css .rotate rotate:180deg
		
	def gameinfo
		game.isCheckmate() ? (game.turn() == "w" ? "Checkmate! Black wins" : "Checkmate! White wins") : (game.isCheck() ? "{game.turn() == "w" ? "♔" : "♚"} Check!" : (game.turn() == "w" ? "♕ White's turn" : "♛ Black's turn"))

	def render
		<self>
			<div [pos:absolute top:50% left:50% translate:-50% -50% d:vflex g:12px ai:center]>

				<div [
					fs:25px ta:center c:#333 ff:monospace h:40px mt:-6px
				]> 
					hold ? " " : gameinfo!

				<div [d:flex g:40px ja:center]>
					<lost-pieces list=capturedWhite piece="White">
					
					<div .rotate=rotate [
						p:18px d:grid grid-template-columns:repeat(8, 1fr) rd:15px
						g:2px bg:brown box-shadow:0 0px 16px rgba(0,0,0,0.25) tween:transform 0.5s
					]>
						for row in [0...8]
							for col in [0...8]
								<render-square row=row col=col>

					<lost-pieces list=capturedBlack piece="Black">

