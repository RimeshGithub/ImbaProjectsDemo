export default tag PythonCompiler
	prop code = "print('Hello from Python!')"
	prop output = "Loading Pyodide..."
	prop pyodide = null
	prop editor = null

	css self * box-sizing:border-box 
	css bg:linear-gradient(120deg,#f9fbe7,#e3f2fd) p:0 30px inset:0

	# Function to load a script dynamically
	def loadScript src
		return new Promise(do(resolve, reject)
			let script = document.createElement("script")
			script.src = src
			script.async = no
			script.onload = resolve
			script.onerror = reject
			document.head.appendChild(script)
		)

	def setup
		# Load CodeMirror CSS
		let styles = [
			"codemirror.min.css",
			"theme/monokai.min.css",
			"addon/selection/active-line.min.css",
			"addon/fold/foldgutter.min.css",
			"addon/hint/show-hint.min.css"
		]

		for s in styles
			let link = document.createElement("link")
			link.rel = "stylesheet"
			link.href = "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.5/{s}"
			document.head.appendChild(link)

		# Load CodeMirror scripts sequentially
		let scripts = [
			"codemirror.min.js",
			"mode/python/python.min.js",
			"addon/edit/matchbrackets.min.js",
			"addon/edit/closebrackets.min.js",
			"addon/selection/active-line.min.js",
			"addon/fold/foldcode.min.js",
			"addon/fold/foldgutter.min.js",
			"addon/fold/brace-fold.min.js",
			"addon/hint/show-hint.min.js"
		]

		for s in scripts
			await loadScript("https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.5/{s}")

		# Initialize CodeMirror
		editor = window.CodeMirror(document.getElementById("editor"), {
			value: code,
			mode: "python",
			theme: "default",
			lineNumbers: true,
			lineWrapping: true,
			styleActiveLine: true,
			matchBrackets: true,
			autoCloseBrackets: true,
			showCursorWhenSelecting: true,
			scrollbarStyle: "native",
			indentUnit: 4,
			tabSize: 4,
			indentWithTabs: false,
			smartIndent: true,
			extraKeys: {
				"Ctrl-Space": "autocomplete",
				"Tab": "indentMore",
				"Shift-Tab": "indentLess"
			},
			gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
			foldGutter: true,
			readOnly: false,
			hintOptions: {
				completeSingle: false
			},
			autofocus: false,
			cursorBlinkRate: 530,
			cursorScrollMargin: 2,
			historyEventDelay: 1250
		})

		editor.on("change", do code = editor.getValue())

		# Load Pyodide
		let pyodideScript = document.createElement("script")
		pyodideScript.src = "https://cdn.jsdelivr.net/pyodide/v0.23.4/full/pyodide.js"
		pyodideScript.onload = do
			globalThis.loadPyodide().then do(pyo)
				pyodide = pyo

				# Register a JS module for Python's input()
				pyodide.registerJsModule("jsinput", {
					prompt: do(text) window.prompt(text)
				})

				output = "Ready to run Python code"
				imba.commit!
		document.head.appendChild(pyodideScript)

	def runCode
		if pyodide
			try
				let fullcode =
					"""
					import sys
					from io import StringIO
					import jsinput

					buffer = StringIO()
					sys.stdout = buffer
					sys.stderr = buffer

					def input(prompt=''):
						return jsinput.prompt(prompt) or ''
					"""
				fullcode += "\ntry:\n"
				for line in code.split("\n")
					fullcode += "  " + line + "\n"
				fullcode += """
					except Exception as e:
						print("Error:", e)
					buffer.getvalue()
					"""
				let result = pyodide.runPython(fullcode)
				output = result.toString()
			catch e
				output = "Error: {e.message}"

	def render
		<self>
			<div [w:100% h:100% d:vflex ja:center g:50px]>
				<div [d:vflex ja:center w:100%]>
					<div [d:flex ai:center jc:space-between w:90% mb:0px]>
						<h2 [c:#333 fs:24px ff:monospace]> "Python Compiler"
						<button @click=runCode [p:5px 10px fs:16px bg:#4caf50 c:white cursor:pointer rd:8px bg@active:#388e3c w:100px]> "Run"
					<div id="editor" [w:100% rd:8px border:1px solid #ccc ofy:auto lh:1.5 fs:14px]>
				<div [d:vflex ja:center w:100% mt:-50px]>
					<div [d:flex ai:center jc:space-between w:90% mb:0px]>
						<h2 [c:#333 fs:24px ff:monospace]> "Output"
						<button @click=(output = "") [p:5px 10px fs:16px bg:#4caf50 c:white cursor:pointer rd:8px bg@active:#388e3c w:100px]> "Clear"
					<div [p:0 30px bg:#212121 c:#f1f1f1 rd:8px of:auto fs:14px w:100% h:200px]>
						<pre> output

