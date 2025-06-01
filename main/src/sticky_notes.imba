import { nanoid } from 'nanoid/non-secure'

export default tag StickyNotes
	prop notes = JSON.parse(window.localStorage.getItem("imba_notes")) || []
	prop newNote = ""

	css self * box-sizing:border-box ff:cursive
	css .container textarea::-webkit-scrollbar d:none

	def addNote
		if newNote.trim!.length > 0
			notes.push({ id: nanoid(), content: newNote })
			saveLocal!
			newNote = ""
			imba.commit!

	def deleteNote id
		notes = notes.filter do(n) n.id !== id
		saveLocal!

	def saveLocal
		window.localStorage.setItem("imba_notes",JSON.stringify(notes))

	def render
		<self>
			<div [p:20px d:vflex g:20px]>
				<div [bg:orange4 rd:10px d:flex ai:center jc:space-evenly p:20px g:50px]>
					<h2 [fs:44px c:white]> "Sticky Notes"
					<div [d:flex g:10px ja:center]>
						<textarea bind=newNote spellcheck=false
						[p:10px fs:16px rd:6px w:200px outline:none border:1px solid #ccc w:250px h:100px]>
						<button @click=addNote [p:10px  rd:6px bg:#ffca28 cursor:pointer bg@active:#ffb300 h:50px]> "ADD NOTE"
				<div .container [d:flex flex-wrap:wrap g:25px jc:center]>
					for note in notes
						<div [bg:yellow2 p:15px w:250px h:250px rd:10px box-shadow:2px 2px 6px rgba(0,0,0,0.1) pos:relative]>
							<textarea bind=note.content @input=saveLocal spellcheck=false 
							[fs:14px c:#444 lh:1.4 resize:none bg:transparent h:100% w:100% outline:none border:none mt:10px]> 
							<button @click=deleteNote(note.id) [pos:absolute top:5px right:5px bg:transparent c:red fs:14px cursor:pointer border:none]> "✕"

