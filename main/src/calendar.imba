export default tag Calendar
	prop current = new Date()
	prop eventData = null
	prop selectedDay = null
	prop allEvents = {}
	prop eventbtnselect = true

	css us:none bg:radial-gradient(ellipse, brown, brown5) inset:0
	css self * ff:monospace box-sizing:border-box
	css .day rd:6px fw:bold d:flex ja:center h:35px cursor:pointer bg@hover:gray c@hover:white c:#333 bg:white fs:18px
	css .today border:3px solid gray border@hover:3px solid #aaa
	css .event bg:repeating-linear-gradient(45deg, #ccc 0px, #ccc 10px, #fff 10px, #fff 20px) c:#333
	css .active bg:gray4 c:white
	css .sat c:red6

	def setup
		let stored = window.localStorage.getItem("calendar-events")
		if stored
			allEvents = JSON.parse(stored)

	def prevMonth
		current = new Date(current.getFullYear(), current.getMonth() - 1, 1)
		selectedDay = null
		eventData = null

	def nextMonth
		current = new Date(current.getFullYear(), current.getMonth() + 1, 1)
		selectedDay = null
		eventData = null

	def formatKey day
		return "{day.year}-{day.month + 1}-{day.day}"

	def daysInMonth
		let year = current.getFullYear()
		let month = current.getMonth()
		let firstDay = new Date(year, month, 1)
		let lastDay = new Date(year, month + 1, 0)
		let startWeekday = firstDay.getDay()
		let totalDays = lastDay.getDate()
		let days = []
		for i in [0 ... startWeekday]
			days.push null
		for d in [1 .. totalDays]
			let weekday = new Date(year, month, d).getDay()
			let key = "{year}-{month+1}-{d}"
			days.push {day: d, weekday, month, year, event: allEvents[key] or ""}
		return days

	def monthName m=null
		let months = ['January','February','March','April','May','June','July','August','September','October','November','December']
		return months[m ?? current.getMonth()]

	def showEvent day
		selectedDay = day
		eventData = day.event
		eventbtnselect = true

	def updateEvent e
		let newEvent = e.target.value
		eventData = newEvent
		if selectedDay
			let key = formatKey(selectedDay)
			allEvents[key] = newEvent
			window.localStorage.setItem("calendar-events", JSON.stringify(allEvents))
	
	def removeEvent date
		delete allEvents[date]
		window.localStorage.setItem("calendar-events", JSON.stringify(allEvents))

	def render
		let weekdays = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']

		<self>
			<div [pos:absolute top:50% left:50% translate:-50% -50% d:flex ja:center g:40px]>
				<div [w:320px p:20px bg:linear-gradient(135deg,#e0f7fa,#fce4ec) rd:12px h:350px
				box-shadow:0 4px 20px rgba(255,255,255,0.5)]>
					<div [d:flex jc:space-between ai:center mb:15px fs:18px fw:bold c:#333 ff:sans-serif]>
						<button @click=prevMonth [bg:transparent rd:50% fs:20px c:#333 cursor:pointer border:3px solid gray c:gray]> "←"
						<span> "{monthName()} {current.getFullYear!}"
						<button @click=nextMonth [bg:transparent rd:50% fs:20px c:#333 cursor:pointer border:3px solid gray c:gray]> "→"

					<div [d:grid grid-template-columns:repeat(7,1fr) g:5px mb:10px fs:14px c:#444 ff:sans-serif ta:center]>
						for day in weekdays
							<div [fw:bold]> day

					<div [d:grid grid-template-columns:repeat(7,1fr) g:5px ta:center]>
						for day in daysInMonth()
							if day
								<div .day .event=(day.event) .sat=(day.weekday == 6)
								.today=(day.day == new Date!.getDate! and current.getMonth! == new Date!.getMonth!)
								.active=(selectedDay and selectedDay.day == day.day and selectedDay.month == day.month and selectedDay.year == day.year)
								@click=showEvent(day)> day.day
							else
								<div>

				<div [w:320px p:0px 20px bg:linear-gradient(135deg,#e0f7fa,#fce4ec) rd:12px h:350px
				box-shadow:0 4px 20px rgba(255,255,255,0.5) d:vflex ai:center]>
					<div [d:flex ja:center g:10px w:100% mt:20px]>
						<button .selected=eventbtnselect [border:2px solid gray border.selected:4px solid white border-bottom:none border-bottom.selected:none 
						bg.selected:linear-gradient(180deg,white,transparent) cursor:pointer outline:none bg:transparent w:45% p:10px rd:16px]
						@click=(eventbtnselect = true)> "Event"
						<button .selected=!eventbtnselect [border:2px solid gray border.selected:4px solid white border-bottom:none border-bottom.selected:none 
						bg.selected:linear-gradient(180deg,white,transparent) cursor:pointer outline:none bg:transparent w:45% p:10px rd:16px]
						@click=(eventbtnselect = false)> "Event List"

					if eventbtnselect
						<div [w:100% h:100% d:vflex ai:center]>
							if eventData isnt null and selectedDay
								<p [fs:16px ta:center mt:25px]> "{monthName(selectedDay.month)} {selectedDay.day}, {selectedDay.year}"
								<textarea spellcheck=false placeholder="Add Event" value=eventData @input=updateEvent
								[resize:none h:65% w:90% border:none outline:none fs:16px p:10px rd:16px]>
							else
								<p [fs:16px ta:center mt:50px]> "Click on a day to view or add event"
					else
						<div [w:100% h:70% border:2px solid white of:auto mt:20px]>
							for data in Object.entries(allEvents).sort(do(a, b) new Date(a[0]).getTime! - new Date(b[0]).getTime!)
								if data[1]    # data[0] is date and data[1] is event
									<div [d:vflex ja:center border-bottom:2px solid white p:10px] @dblclick=removeEvent(data[0])>
										<p> "{monthName(data[0].split("-")[1] - 1)} {data[0].split("-")[2]}, {data[0].split("-")[0]}"
										<pre> data[1]

