import { Parser } from 'expr-eval'
import { nanoid } from 'nanoid/non-secure'

let expression = ""
let result = ""
let ans = ""
let originalExpression
let history = []

tag history-adder
	prop expressionH
	prop resultH
	prop idH

	def delItem id
		history = history.filter do(h) h.id !== idH

	def insertExp id
		expression = (history.find do(h) h.id === idH)?.expression ?? expression
		result = (history.find do(h) h.id === idH)?.result ?? result

	<self>
		<input value="{expressionH} = {resultH}" readOnly [border:none outline:none w:100% 
		border-bottom:1px solid p:10px cursor:pointer bg:transparent]
		@click.alt=delItem(id)
		@click=insertExp(id)>


export default tag Calculator
	css * box-sizing:border-box
	css div button fs:20px
	css pos:absolute left:50% top:50% translate:-50% -50%

	def clear
		expression = ""
		result = ""

	def append val
		expression += val

	def calculate
		try
			originalExpression = expression.replaceAll("Ans",ans)
			result = Parser.evaluate(originalExpression).toString()
			history.unshift({expression: originalExpression, result, id:nanoid!})
			ans = result
		catch e
			result = e.message

	def render
		<self>
			<div [w:380px p:20px bg:#444 rd:14px box-shadow:0 4px 18px rgba(0,0,0,0.5)]>
				<input bind=expression [fs:22px mb:2px c:#333 ff:monospace h:50px bg:#f1f8e9 
				p:0px 10px w:100% border:none outline:none]>
				<input value=result readOnly [fs:22px c:#000 mb:16px ff:monospace fw:bold w:100%
				ta:right h:50px bg:#f1f8e9 border:none outline:none p:0px 10px]>
				
				<div [d:grid g:10px grid-template-columns:repeat(4, 1fr)]>
					<button @click=clear [p:12px bg:red4 rd:8px cursor:pointer] > "C"
					<button @click=append("(") [p:12px bg:white rd:8px cursor:pointer] > "("
					<button @click=append(")") [p:12px bg:white rd:8px cursor:pointer] > ")"
					<button @click=append("/") [p:12px bg:white rd:8px cursor:pointer] > "÷"

					<button @click=append("7") [p:12px bg:white rd:8px cursor:pointer] > "7"
					<button @click=append("8") [p:12px bg:white rd:8px cursor:pointer] > "8"
					<button @click=append("9") [p:12px bg:white rd:8px cursor:pointer] > "9"
					<button @click=append("*") [p:12px bg:white rd:8px cursor:pointer] > "×"

					<button @click=append("4") [p:12px bg:white rd:8px cursor:pointer] > "4"
					<button @click=append("5") [p:12px bg:white rd:8px cursor:pointer] > "5"
					<button @click=append("6") [p:12px bg:white rd:8px cursor:pointer] > "6"
					<button @click=append("-") [p:12px bg:white rd:8px cursor:pointer] > "−"

					<button @click=append("1") [p:12px bg:white rd:8px cursor:pointer] > "1"
					<button @click=append("2") [p:12px bg:white rd:8px cursor:pointer] > "2"
					<button @click=append("3") [p:12px bg:white rd:8px cursor:pointer] > "3"
					<button @click=append("+") [p:12px bg:white rd:8px cursor:pointer] > "+"

					<button @click=append("0") [p:12px bg:white rd:8px cursor:pointer] > "0"
					<button @click=append(".") [p:12px bg:white rd:8px cursor:pointer] > "."
					<button @click=append('Ans') [p:12px bg:white rd:8px cursor:pointer] > "Ans"
					<button @click=calculate [p:12px bg:#4CAF50 c:white rd:8px cursor:pointer bg@hover:#388E3C] > "="

				<div [d:flex jc:space-between mt:20px mb:8px p:0px 10px c:white]>
					<div [fs:16px fw:bold] > "History:"
					<div [fs:16px fw:bold cursor:pointer d:{history.length ? 'block' : 'none'}]  @click=(history = [])> "Clear"
				<div [h:120px of:auto bg:#f1f8e9 rd:8px p:10px fs:13px ff:monospace]>
					for entry in history
						<history-adder expressionH=entry.expression resultH=entry.result idH=entry.id>

