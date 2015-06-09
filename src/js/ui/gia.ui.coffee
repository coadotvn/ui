
if typeof FastClick is 'function'
	FastClick.attach document.body

if typeof Rainbow is 'object'
	Rainbow.onHighlight (block, language) ->
		$ block
			.show()