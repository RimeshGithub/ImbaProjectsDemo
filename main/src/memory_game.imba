import { nanoid } from 'nanoid/non-secure'

export default tag MemoryGame
	prop cards = []
	prop flipped = []
	prop matched = []
	prop level = "easy"
	prop pairCount
	prop moves
	prop score
	prop combo = 1
	prop reset = false

	prop symbols = ["🍎","🍌","🍇","🍉","🍍","🍓","🥝","🍑","🥥","🍋","🍊","🍈","🍏","🥭","🫐","🍅"]

	css bg:linear-gradient(135deg,#e3f2fd,#fce4ec) inset:0
	css
		.card-container
			perspective:1000px w:80px h:80px cursor:pointer

		.card-inner
			w:100% h:100% pos:relative
			transition:transform 0.6s
			transform-style:preserve-3d

		.card-inner.flipped transform:rotateY(180deg)

		.card-front, .card-back
			pos:absolute w:100% h:100%
			d:flex ai:center jc:center
			fs:30px rd:12px
			box-shadow:0 2px 5px rgba(0,0,0,0.3)

		.card-front
			bg:#ccc c:#444 backface-visibility:hidden

		.card-back
			transform:rotateY(180deg) bg:#fff c:#222 backface-visibility:hidden

	def shuffle arr
		let a = arr.slice()
		for i in [1 .. a.length - 1]
			let j = Math.floor(Math.random() * (i + 1))
			let tmp = a[i]
			a[i] = a[j]
			a[j] = tmp
		return a

	def setup
		reset = true
		moves = score = 0
		combo = 1
		pairCount = level == "easy" ? 8 : (level == "medium" ? 12 : 16)
		let pairs = symbols.slice(0, pairCount)
		let deck = shuffle(pairs.concat(pairs)).map do(symbol)
			{id: nanoid(), symbol, flipped: false}
		cards = deck
		flipped = []
		matched = []
		setTimeout(&, 500) do
			reset = false
			imba.commit!

	def flipCard id
		let card = cards.find(do(c) c.id == id)
		return if card.flipped or matched.includes(card.id) or flipped.length == 2

		card.flipped = true
		flipped.push(card)

		if flipped.length == 2
			let [first, second] = flipped
			if first.symbol == second.symbol
				matched.push(first.id)
				matched.push(second.id)
				flipped = []
				score += 10 * combo
				combo += 1
				checkwin!
			else
				combo = 1
				setTimeout(&, 800) do
					first.flipped = false
					second.flipped = false
					flipped = []
					imba.commit()
			moves += 1

	def changeLevel newLevel
		level = newLevel

	def checkwin
		if matched.length == pairCount * 2
			setTimeout(&, 800) do
				window.alert("You won the game in {moves} moves with an score of {score} points!")

	def render
		<self>
			<div [d:vflex ja:center pos:absolute top:50% left:50% translate:-50% -50% ff:sans-serif mt:-25px]>

				<h2 [mb:30px fs:28px c:#333]> "Memory Game"
				<div [d:vflex ja:center]>
					<div [d:flex g:50px fs:20px]>
						<p> "Score: {score}"
						<p> "Moves: {moves}"
					<div [d:flex g:10px mb:10px]>
						<button @click=changeLevel("easy") [w:80px p:8px rd:8px cursor:pointer bg:{level=="easy" ? "#2196F3" : "#90CAF9"} c:white fs:14px]> 
							"Easy"
						<button @click=changeLevel("medium") [w:80px p:8px rd:8px cursor:pointer bg:{level=="medium" ? "#2196F3" : "#90CAF9"} c:white fs:14px]> 
							"Medium"
						<button @click=changeLevel("hard") [w:80px p:8px rd:8px cursor:pointer bg:{level=="hard" ? "#2196F3" : "#90CAF9"} c:white fs:14px]> 
							"Hard"
						<button @click=setup [p:10px rd:10px bg:#4CAF50 c:white cursor:pointer fs:16px 
						bg@active:green5 box-shadow:0 4px 10px rgba(0,0,0,0.2)]> "New Game"

				<div .reset=reset [d:grid g:15px gtc:repeat({pairCount / 2},80px) mt:30px visibility.reset:hidden]>
					for card in cards
						<div .card-container @click=flipCard(card.id)>
							<div .card-inner .flipped=(card.flipped or matched.includes(card.id))>
								<div .card-front> "? "
								<div .card-back> card.symbol

