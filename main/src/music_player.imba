import { Howl } from 'howler'

export default tag MusicPlayer
	prop isPlaying = false
	prop currentTrack = 0
	prop tracks = []
	prop sound = null
	prop volume = 1.0
	prop progress = 0
	prop repeat = false
	prop shuffle = false
	prop speed = 1.0
	prop interval = null
	prop searchTerm = ""

	css bg:linear-gradient(90deg,#777,#333) inset:0
	css input,button outline:none
	css .trackname::-webkit-scrollbar d:none

	def setup
		document.addEventListener("keydown", do(e)	
			if sound
				if e.code == "ArrowRight"
					sound.seek(sound.seek! + 10)
				elif e.code == "ArrowLeft"
					sound.seek(sound.seek! < 10 ? 0 : (sound.seek! - 10))
		)

	def handleFiles e
		tracks = []
		for file in e.target.files
			tracks.push { title: file.name, src: URL.createObjectURL(file) }
		if tracks.length > 0
			playTrack(0)

	def playTrack index
		if sound
			sound.unload()
			clearInterval(interval)
		currentTrack = index
		sound = new Howl({ src: tracks[index].src, html5: true, volume: volume, rate: speed, onend: do onEnd() })
		sound.play()
		isPlaying = true
		updateProgress()
		document.getElementById(index).scrollIntoView({behavior: 'smooth', block: 'start'})

	def togglePlay
		if not sound and tracks.length > 0
			playTrack(currentTrack)
		else if isPlaying
			sound.pause()
			clearInterval(interval)
			isPlaying = false
		else
			sound.play()
			updateProgress()
			isPlaying = true

	def nextTrack
		if shuffle
			let next = Math.floor(Math.random() * tracks.length)
			playTrack(next)
		else
			let next = (currentTrack + 1) % tracks.length
			playTrack(next)

	def prevTrack
		let prev = (currentTrack - 1 + tracks.length) % tracks.length
		playTrack(prev)

	def updateProgress
		clearInterval(interval)
		interval = setInterval(&, 100) do
			if sound
				progress = (sound.seek() or 0) / sound.duration() * 100
			imba.commit!

	def seek e
		if sound
			let percent = e.target.value / 100
			sound.seek(sound.duration() * percent)

	def setVolume e
		volume = e.target.value
		if sound
			sound.volume(volume)

	def setSpeed e
		speed = e.target.value
		if sound
			sound.rate(speed)

	def toggleRepeat
		if sound
			repeat = !repeat

	def toggleShuffle
		if sound
			shuffle = !shuffle

	def onEnd
		if repeat
			playTrack(currentTrack)
		else
			nextTrack()

	def secondsToMinutes secs
		let minutes = Math.floor(secs / 60)
		let seconds = Math.floor(secs % 60)
		return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)

	def render
		<self>
			<div [p:20px bg:linear-gradient(135deg,#fff7f7,#e0f7fa) rd:16px box-shadow:0 6px 18px rgba(0,0,0,0.15) 
			pos:absolute top:50% left:50% translate:-50% -50% ff:sans-serif d:flex g:20px h:580px]>

				<div [d:vflex g:20px ja:center w:400px]>
					<h1 [fs:40px]> "Music Player"
					<div .trackname [ta:center fs:16px fw:500 mb:10px c:#333 h:60px of:auto w:100%]> tracks.length > 0 ? tracks[currentTrack].title : "No Track Selected"

					<div [d:vflex w:100% ja:center mt:-30px]>
						<p> sound ? "{secondsToMinutes(sound.seek! or 0)} / {secondsToMinutes(sound.duration!)}" : "0:00 / 0:00"
						<input type="range" min="0" max=100 step="0.1" value=(progress or 0) disabled=!sound @input=seek
						[w:80% cursor:pointer]>

					<div [d:flex jc:center g:10px mt:10px]>
						<button @click=prevTrack [d:flex ja:center size:50px fs:25px rd:50% bg:white box-shadow:0 2px 8px rgba(0,0,0,0.2) cursor:pointer]> "⏮"
						<button @click=togglePlay [d:flex ja:center size:50px fs:25px rd:50% bg:#4CAF50 c:white box-shadow:0 2px 8px rgba(0,0,0,0.2) cursor:pointer]> isPlaying ? "⏸" : "▶"
						<button @click=nextTrack [d:flex ja:center size:50px fs:25px rd:50% bg:white box-shadow:0 2px 8px rgba(0,0,0,0.2) cursor:pointer]> "⏭"

					<div [d:flex g:10px ai:center mt:10px fs:14px]>
						<button @click=toggleRepeat [bg:transparent border:2px solid {repeat ? 'lime' : 'gray'} rd:16px cursor:pointer p:8px]> "🔁 Repeat"
						<button @click=toggleShuffle [bg:transparent border:2px solid {shuffle ? 'lime' : 'gray'} rd:16px cursor:pointer p:8px]> "🔀 Shuffle"

					<div [d:flex ai:center jc:space-between]>
						<div [d:flex g:10px ja:center fs:14px]>
							<label> "Volume"
							<input$vol type="range" min="0" max="1" step="0.01" value=volume @input=setVolume [cursor:pointer w:40%]>
							<p [w:10px]> Math.round(Number($vol.value) * 100)

						<div [d:flex g:10px ja:center fs:14px]>
							<label> "Speed"
							<input$sp type="range" min="0.5" max="2" step="0.1" value=speed @input=setSpeed [cursor:pointer w:40%]>
							<p [w:10px]> $sp.value

				<div [w:350px h:100%]>
					if tracks.length > 0
						<div [d:vflex ja:center w:100% h:100%]>
							<h2> "Music List"
							<input type="text" placeholder="Search..." bind=searchTerm
							[w:80% p:8px mb:10px rd:6px fs:14px border:1px solid #ccc box-shadow:inset 0 1px 3px rgba(0,0,0,0.1)]>

							<div [fs:14px c:#444 of:auto w:100% h:75% p:5px]>
								for track, i in tracks
									if track.title.toLowerCase!.includes(searchTerm)
										<div id=i @click=playTrack(i) [p:8px rd:6px bg:{currentTrack == i ? '#d1f2eb' : '#fff'} of:hidden
										c:{currentTrack == i ? '#2e7d32' : '#333'} cursor:pointer mb:5px box-shadow:0 1px 3px rgba(0,0,0,0.1)]>
											track.title
					else
						<div [d:vflex g:20px ja:center h:100%]>
							<div [mt:20px fs:13px c:#666 ta:center]> "Upload multiple audio files to start the playlist 🎶"
							<input type="file" multiple accept="audio/*" @change=handleFiles [mb:15px fs:14px]>
