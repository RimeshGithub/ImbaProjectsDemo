export default tag AnalogClock
	prop time = new Date()

	css inset:0 d:flex jc:center ai:center ff:sans-serif bg:radial-gradient(circle, #fff, #000)

	def setup
		setInterval(&, 10) do
			time = new Date()
			imba.commit!

	def getRotation unit
		switch unit
			when 'second' then (time.getSeconds() * 6 + time.getMilliseconds() * 0.006)
			when 'minute' then time.getMinutes() * 6 + time.getSeconds() * 0.1
			when 'hour' then (time.getHours() % 12) * 30 + time.getMinutes() * 0.5

	def render
		<self>
			<div [w:300px h:300px rd:50% bg:#fff box-shadow:0 0 20px rgba(0,0,0,0.15) pos:relative]>

				<div [w:6px h:6px rd:50% bg:#333 pos:absolute top:50% left:50% mt:-3px ml:-3px]>

				<div [w:4px h:80px bg:#333 pos:absolute top:50% left:50% transform:rotate({getRotation('hour')}deg) transform-origin:bottom mt:-80px ml:-2px rd:2px]>
				<div [w:3px h:100px bg:#555 pos:absolute top:50% left:50% transform:rotate({getRotation('minute')}deg) transform-origin:bottom mt:-100px ml:-1.5px rd:2px]>
				<div [w:2px h:120px bg:red pos:absolute top:50% left:50% transform:rotate({getRotation('second')}deg) transform-origin:bottom mt:-120px ml:-1px rd:2px]>

				for i in [1 .. 12]
					<div [
						pos:absolute
						top:50%
						left:50%
						transform:translate(-50%,-50%) rotate({i * 30}deg) translateY(-130px) rotate({-i * 30}deg)
						fs:16px
						c:#222
						fw:bold
					]> "{i}"

