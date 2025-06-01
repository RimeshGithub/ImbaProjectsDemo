import {
	Chart,
	LineController,
	LineElement,
	PointElement,
	LinearScale,
	CategoryScale,
	Title,
	Tooltip,
	Legend,
	Filler
} from 'chart.js'

Chart.register(
	LineController,
	LineElement,
	PointElement,
	LinearScale,
	CategoryScale,
	Title,
	Tooltip,
	Legend,
	Filler,
)

import { Parser } from 'expr-eval'

export default tag GraphCalculator
	prop expression = ""
	prop chart = null
	prop errorMessage = null

	def plot
		try
			const parser = new Parser()
			const expr = parser.parse(expression)
			const labels = []
			const data = []
			for x in [-10 .. 10]
				labels.push(x)
				data.push(expr.evaluate({x}))
			updateChart(labels, data)
			errorMessage = null
		catch e
			errorMessage = e.message
			console.log("Invalid expression", e)

	def updateChart labels, data
		if chart
			chart.data.labels = labels
			chart.data.datasets[0].data = data
			chart.options.plugins.title.text = "f(x) = {expression}"
			chart.update()
		else
			const ctx = $canvas.getContext('2d')
			chart = new Chart(ctx, {
				type: 'line',
				data: {
					labels: labels,
					datasets: [{
						label: "f(x)",
						data: data,
						borderColor: '#4CAF50',
						backgroundColor: 'rgba(76, 175, 80, 0.2)',
						tension: 0.3,
						fill: true,
						pointRadius: 3,
						pointHoverRadius: 6
					}]
				},
				options: {
					responsive: true,
					plugins: {
						title: {
							display: true,
							text: "f(x) = {expression}",
							font: {
								size: 18,
								weight: 'bold'
							},
							color: '#333'
						},
						tooltip: {
							enabled: true,
							callbacks: {
								title: do(tooltipItems) "x = " + tooltipItems[0].label + "\nf(x) = " + tooltipItems[0].formattedValue
								label: do(tooltipItem) ""
							}
						},
						legend: {
							display: false
						},
					},
					interaction: {
						mode: 'nearest',
						axis: 'x',
						intersect: true
					},
					scales: {
						x: {
							title: {
								display: true,
								text: 'x',
								color: '#666',
								font: {
									weight: 'bold'
								}
							},
							grid: {
								color: 'rgba(0,0,0,0.05)'
							}
						},
						y: {
							title: {
								display: true,
								text: 'f(x)',
								color: '#666',
								font: {
									weight: 'bold'
								}
							},
							grid: {
								color: 'rgba(0,0,0,0.05)'
							}
						}
					}
				}
			})

	def render
		<self>
			<div [w:500px p:25px bg:linear-gradient(135deg,#f3e5f5,#e1f5fe) rd:12px box-shadow:0 4px 20px rgba(0,0,0,0.2) d:vflex ja:center
			pos:absolute top:50% left:50% transform:translate(-50%,-50%)]>
				<div [fs:28px mb:12px c:#333 ff:monospace fw:bold ta:center] > "Graph Calculator"
				<div [d:flex ja:center g:10px w:100%]>
					<p [fs:25px]> "f(x) = "
					<input bind=expression placeholder="Enter expression in x" [w:80% p:10px rd:6px border:1px solid #ccc fs:18px outline:none] >
				<button @click=plot [p:10px bg:#4CAF50 c:white rd:6px cursor:pointer fs:16px w:100% mb:20px bg@active:#388E3C] > "Plot"
				if errorMessage
					<div [w:100% h:350px d:flex ja:center fs:20px]> errorMessage
				else
					<div [w:100% h:350px d:flex ja:center bg:white rd:16px]>
						<canvas$canvas>

