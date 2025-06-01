export default tag PhotoEditor
	prop image = ""
	prop brightness = 100
	prop contrast = 100
	prop saturation = 100
	prop blurness = 0
	prop grayscale = 0
	prop sepia = 0

	css self * box-sizing:border-box
	css bg:linear-gradient(90deg,#777,#333) inset:0 p:20px
	css input cursor:pointer

	def handleImageUpload e
		const file = e.target.files[0]
		if file
			const reader = new FileReader()
			reader.onload = do(ev) 
				image = ev.target.result.toString!
				resetFilters!
				imba.commit!
			reader.readAsDataURL(file)

	def downloadImage
		const canvas = document.createElement("canvas")
		const ctx = canvas.getContext("2d")
		const img = new Image()
		img.src = image
		img.onload = do
			canvas.width = img.width
			canvas.height = img.height
			ctx.filter = "brightness({brightness}%) contrast({contrast}%) saturate({saturation}%) blur({blurness}px) grayscale({grayscale}%) sepia({sepia}%)"
			ctx.drawImage(img, 0, 0)
			const link = document.createElement("a")
			link.download = "edited-image.png"
			link.href = canvas.toDataURL()
			link.click()

	def resetFilters
		brightness = contrast = saturation = 100
		blurness = grayscale = sepia = 0

	def render
		<self>
			<div [d:vflex ja:center g:35px]>
				<div [w:100% d:flex fd:column ja:center p:20px bg:linear-gradient(135deg,#f5f7fa,#c3cfe2) g:30px
				rd:12px box-shadow:0 4px 20px rgba(0,0,0,0.1) flex-wrap:wrap]>
					<h2 [fs:24px c:#333]> "Photo Editor"
					<input type="file" accept="image/*" @change=handleImageUpload [w:15%]>

					<div [w:50% d:grid gtc:repeat(3, 1fr) g:15px]>
						<label>
							<span [fs:14px c:#444]> "Brightness"
							<input type="range" min="0" max="200" bind=brightness [w:100%]>
						<label>
							<span [fs:14px c:#444]> "Contrast"
							<input type="range" min="0" max="200" bind=contrast [w:100%]>
						<label>
							<span [fs:14px c:#444]> "Saturation"
							<input type="range" min="0" max="200" bind=saturation [w:100%]>
						<label>
							<span [fs:14px c:#444]> "Blur"
							<input type="range" min="0" max="10" step="0.1" bind=blurness [w:100%]>
						<label>
							<span [fs:14px c:#444]> "Grayscale"
							<input type="range" min="0" max="100" bind=grayscale [w:100%]>
						<label>
							<span [fs:14px c:#444]> "Sepia"
							<input type="range" min="0" max="100" bind=sepia [w:100%]>

					<div [d:vflex g:10px]>
						<button @click=resetFilters [mt:10px p:10px px:20px bg:#4caf50 c:white rd:8px cursor:pointer bg@hover:#388e3c]> "Reset Filters"
						<button @click=downloadImage [mt:10px p:10px px:20px bg:#4caf50 c:white rd:8px cursor:pointer bg@hover:#388e3c]> "Download Image"

				<div>			
					if image
						<img src=image [h:450px w:auto box-shadow:0 0 10px rgba(255,255,255,0.2)
						filter:brightness({brightness}%) contrast({contrast}%) saturate({saturation}%) blur({blurness}px) grayscale({grayscale}%) sepia({sepia}%)]>
					else
						<div [d:flex ja:center size:450px border:2px solid white c:white fs:30px]> "Image Preview"

