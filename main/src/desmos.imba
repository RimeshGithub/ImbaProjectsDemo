export default tag DesmosGraph
	def setup
		const script = document.createElement("script")
		script.src = "https://www.desmos.com/api/v1.11/calculator.js?apiKey=dcb31709b452b1cf9dc26972add0fda6"
		script.async = true
		script.onload = do initCalculator()
		document.head.appendChild(script)

	def initCalculator
		let el = document.getElementById("calculator")
		window.calc = Desmos.GraphingCalculator(el, {
			expressions: true,
			expressionsTopbar: true,
			zoomButtons: true,
			settingsMenu: true,
			border: false,
			keypad: true,
			graphpaper: true,
			lockViewport: false,
			showResetButtonOnGraphpaper: true,
			showGrid: true,
			showXAxis: true,
			showYAxis: true,
			xAxisLabel: "",
			yAxisLabel: "",
			xAxisArrowMode: "NONE",
			yAxisArrowMode: "NONE",
			language: "en"
		})


	def render
		<self>
			<div [w:100% h:100% box-sizing:border-box p:30px pt:20px bg:linear-gradient(135deg,#f0f4c3,#e1f5fe) d:vflex ja:center pos:absolute top:50% left:50% 
			transform:translate(-50%,-50%)]>
				<div [fs:28px mb:12px c:#333 ff:monospace fw:bold]> "DESMOS"
				<div#calculator [w:100% h:100% rd:8px overflow:hidden border:2px solid #ccc]>
				
