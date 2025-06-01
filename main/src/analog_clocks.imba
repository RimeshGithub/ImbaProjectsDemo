tag mini-clock
	prop time
	prop unit
	prop factor
    
	css .text d:none pos:relative
	css self@hover scale:1.5 zi:1
		.text d:block
	css self cursor:pointer scale@active:1

	def getRotation
		switch unit
			when 'second' then (time.getSeconds() * 6 + time.getMilliseconds() * 0.006)
			when 'minute' then time.getMinutes() * 6 + time.getSeconds() * 0.1
			when 'hour' then (time.getHours() % 12) * 30 + time.getMinutes() * 0.5

	def getLimit
		unit == 'hour' ? 12 : 60

	<self>
		<div [w:300px h:300px rd:50% bg:#fff box-shadow:0 0 20px rgba(0,0,0,0.15) pos:relative transform:rotate({-getRotation!}deg)]>
			for i in [1 .. getLimit!]
				<div [
					pos:absolute
					top:50%
					left:50%
					transform:translate(-50%,-50%) rotate({i * factor}deg) translateY(-130px) rotate({-i * factor}deg)
					fs:{unit == 'hour' ? 20 : 10}px
					c:#222
					fw:bold
				]> "{i}"
		<div [w:2px h:125px bg:red pos:relative left:50% mt:-275px ml:-1px rd:2px]>
		<div [w:6px h:6px rd:50% bg:#333 pos:relative left:50% mt:-3px ml:-3px]>
		<div .text>
			<div [pos:absolute top:50% left:50% translate:-50%]> "{unit.toUpperCase!}"

export default tag AnalogClocks
	css self d:flex jc:center ai:center bg:#f0f0f0 ff:sans-serif 
		bg:radial-gradient(circle, #fff, #000) us:none inset:0

	prop time = new Date()

	def setup
		setInterval(&, 10) do
			time = new Date()
			imba.commit!

	def render
		<self [d:flex g:30px flex-wrap:wrap ja:center mt:-180px]>
			<mini-clock time=time unit='hour' factor=30>
			<mini-clock time=time unit='minute' factor=6>
			<mini-clock time=time unit='second' factor=6>
		

