const apiKey =  import.meta.env.VITE_API_KEY
const apiUrl = 'https://api-inference.huggingface.co/models/mistralai/Mixtral-8x7B-Instruct-v0.1'

export default tag Chatbot
	prop userMessage = ""
	prop chatHistory = []
	prop isLoading = false

	css self * box-sizing:border-box

	css
		@keyframes spin
			0% transform: rotate(0deg)
			100% transform: rotate(360deg)

	def scrollToBottom
		setTimeout(&, 100) do
				const chatbox = document.querySelector('#chatbox')
				chatbox.scrollTo({top: chatbox.scrollHeight, behavior: 'smooth'})
				imba.commit!

	def sendMessage
		if userMessage.trim!.length == 0 or isLoading
			return
		
		chatHistory.push({text: userMessage, from: 'user'})
		isLoading = true
		const msg = userMessage
		userMessage = "" 
		scrollToBottom!
		
		# Format for Mistral's instruction-based model
		const formattedPrompt = "[INST] {msg} [/INST]"
		
		window.fetch(apiUrl,
			method: 'POST',
			headers: {
				'Authorization': "Bearer {apiKey}",
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				inputs: formattedPrompt,
				parameters: {
					# max_new_tokens: 500,       # Increased length for better responses
					temperature: 0.7,         # Slightly higher for creativity
					top_p: 0.9,              # Better response diversity
					repetition_penalty: 1.1,  # Reduce repetition
					return_full_text: false    # Don't repeat the prompt
				}
			})
		).then(do(res)
			if !res.ok
				throw new Error("API request failed")
			res.json()
		).then(do(data)
			if data and data[0]?.generated_text
				# Clean up Mistral's response format
				let response = data[0].generated_text.trim()
				chatHistory.push({
					text: response,
					from: 'bot'
				})
			else
				throw new Error("Invalid response format")
		).catch(do(err)
			console.error("API Error:", err)
			chatHistory.push({
				error: true,
				text: "Sorry, I encountered an error. Please try again."
			})
		).finally do
			isLoading = false
			scrollToBottom!

	def handleKeydown e
		if e.key == "Enter" and !e.shiftKey
			e.preventDefault!
			sendMessage!

	def render
		<self>
			<div [ff:sans-serif d:vflex ja:center g:10px]>
				<div [c:#777 bg:linear-gradient(135deg,#e3f2fd,#f3e5f5) w:100% fs:40px ta:center p:20px pos:abolute top:0px rd:16px]> "Chatbot"
				
				<div#chatbox
					[w:100% max-width:800px h:calc(100vh - 195px) of:auto p:15px d:vflex gap:12px outline:none]
				>
					if chatHistory.length == 0
						<div [ta:center c:#999 mt:auto mb:auto]> "Start a conversation with the AI..."
					else
						for msg in chatHistory
							if msg.error
								<div.message-error
									[rd:8px bg:#ffeeee c:#d32f2f p:12px max-width:80% m:0 auto ta:center border:1px solid #ffcdd2]
								>
									<p [m:0]> "Error communicating with AI"
							else
								if msg.from == 'user'
									<div.message-user
										[rd:8px bg:#6200ee c:white p:12px max-width:75% ml:auto word-break:break-word white-space:pre-wrap]
									>
										<p [m:0]> msg.text
								else
									<div.message-bot
										[rd:8px bg:#f1f1f1 c:#333 p:12px max-width:75% mr:auto word-break:break-word white-space:pre-wrap]
									>
										<p [m:0]> msg.text
					
					if isLoading
						<div.message-loading
							[rd:8px bg:#f1f1f1 c:#666 p:12px max-width:75% mr:auto]
						>
							<div [d:flex ai:center gap:8px]>
								<div.loading-spinner [w:16px h:16px border:2px solid #ddd bdt:2px solid #6200ee rd:50% animation:spin 1s linear infinite]>
								<p [m:0]> "Thinking..."

				<div#input-area [d:flex gap:8px pos:absolute bottom:20px w:80% ja:center]>
					<textarea#userInput
						@keydown=handleKeydown
						bind=userMessage spellcheck=false
						placeholder=(isLoading ? "Please wait..." : "Type your message...")
						[flex:1 min-height:60px p:12px rd:8px border:1px solid #ddd resize:none outline:none fs:16px]
						disabled=isLoading
					>
					<button#sendBtn
						@click=sendMessage
						disabled=(isLoading or userMessage.trim!.length == 0)
						[p:0 20px h:60px bg:#6200ee c:white border:none rd:8px cursor:pointer bg@active:#7c4dff]
					> "Send"
