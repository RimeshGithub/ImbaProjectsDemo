import Algebrite from 'algebrite'

export default tag DifferentiatorIntegrator
	prop expression = ""
	prop result = null
	prop mode = "Differentiator"
	prop variable = null
	prop lowerBound = null
	prop upperBound = null

	css self * ff:monospace

	def clear
		expression = ""
		result = null
		variable = null
		lowerBound = null
		upperBound = null

	def calculate
		try
			if mode == "Differentiator" and expression
				result = Algebrite.derivative(expression).toString()
				if variable
					let substituted = result.replaceAll("x",variable).replaceAll("e{variable}p","exp")
					result = Algebrite.run("eval({substituted})").toString()
			else if mode == "Integrator" and expression
				result = Algebrite.integral(expression).toString() + " + C"
				if lowerBound and upperBound
					let substituted1 = result.replaceAll("x",upperBound).replaceAll("e{upperBound}p","exp")
					let substituted2 = result.replaceAll("x",lowerBound).replaceAll("e{lowerBound}p","exp")
					result = Algebrite.run("eval({substituted1}) - eval({substituted2})").toString()
		catch e
			result = "Error: {e.message}"

	def toggleMode
		mode = mode == "Integrator" ? "Differentiator" : "Integrator"
		result = null

	def render
		<self>
			<div [w:500px p:30px bg:linear-gradient(135deg,#fffbe6,#e6f7ff) rd:12px box-shadow:0 4px 15px rgba(0,0,0,0.1)
			pos:absolute top:50% left:50% transform:translate(-50%,-50%) d:vflex ja:center g:30px]>
				<h3 [mb:10px fs:20px]> "Symbolic {mode}"
				<input bind=expression placeholder="Enter expression (e.g. sin(x) + x^2)" [w:90% p:10px fs:16px rd:6px mb:10px border:1px solid #ccc]>
				
				if mode == "Differentiator"
					<div [mt:-20px]>
						<label [d:flex g:8px ja:center fs:16px]> "Variable: " 
							<input bind=variable placeholder="Enter value of x" [w:250px p:10px fs:16px rd:6px border:1px solid #ccc]>
				elif mode == "Integrator"
					<div [mt:-20px d:flex ja:center g:20px]>
						<label [d:flex g:8px ja:center fs:16px]> "Upper Limit: " 
							<input bind=upperBound placeholder="Enter Upper Limit" [w:150px p:10px fs:16px rd:6px border:1px solid #ccc]>
						<label [d:flex g:8px ja:center fs:16px]> "Lower Limit: " 
							<input bind=lowerBound placeholder="Enter Lower Limit" [w:150px p:10px fs:16px rd:6px border:1px solid #ccc]>
				
				<label [w:100% d:flex g:8px ja:center fs:16px]> "Result: " 
					<div [fs:16px c:#444 w:90% of:auto bg:white p:10px border:1px solid #ccc rd:6px text-wrap:nowrap]> result ?? "Result will appear here"
				
				<div [d:flex g:10px]>
					<button @click=calculate [w:120px p:5px bg:#4CAF50 c:white rd:6px cursor:pointer bg@active:#388E3C]> "Calculate"
					<button @click=clear [w:120px p:5px bg:gray c:white rd:6px cursor:pointer bg@active:#555]> "Clear"
					<button @click=toggleMode [w:250px p:5px bg:#2196F3 c:white rd:6px cursor:pointer bg@active:#1976D2]> "Switch to {mode == 'Integrator' ? 'Differentiator' : 'Integrator'}"

