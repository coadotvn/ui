rules = [
		name: 'comment'
		pattern: /\/\/[^\n]+/g
	,
		name: 'entity.name.tag'
		pattern: /(media|charset)/g
	,
		matches:
			1: 'support.function'
		pattern: /(rem-calc|lighten|darken)(?=\()/g
	,
		matches:
			1: 'constant.numeric'
			2: 'keyword.unit'
		pattern: /(\d+)(px|em|cm|s|%|rem)?/g
	,
		name: 'constant.hex-color'
		pattern: /#([a-f0-9]{3}|[a-f0-9]{6})(?=;|\s)/gi
	# ,
	# 	matches:
	# 		1: 'keyword.variable'
	# 	pattern: /[^\/\n=]+/g
]

Rainbow.extend 'stylus', rules, true