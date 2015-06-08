glob = require 'glob'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'

r =
	jade:
		find: /^[\t\s]*(extends|include) .*$/gmi
		replace: /^[\t\s]*(extends|include) /i
	stylus:
		find: /^[\t\s]*\@import .*$/gmi
		replace: /(^[\t\s]*\@import |\'|\")/gmi

db =
	jade: []
	stylus: []
	links: {}

normalizeExtension = (fileName, defaultExt) ->
	ext = path.extname fileName
	if ext not in ['jade', 'styl']
		"#{fileName}.#{defaultExt}"
	else
		fileName

# jade
files = glob.sync 'src/**/*.jade'
db.jade = files

for fileName in files
	data = fs.readFileSync fileName, 'utf8'
	p = path.normalize fileName
	p = path.dirname p
	re = r.jade
	while (m = re.find.exec(data)) isnt null
		line = m[0]
			.replace re.replace, ''
			.trim()
		rFileName = path.join p, line
		rFileName = normalizeExtension rFileName, 'jade'
		if db.links[rFileName]?
			db.links[rFileName].push fileName
		else
			db.links[rFileName] = [fileName]

# stylus
files = glob.sync 'src/**/*.styl'
db.stylus = files

for fileName in files
	data = fs.readFileSync fileName, 'utf8'
	p = path.normalize fileName
	p = path.dirname p
	re = r.stylus
	while (m = re.find.exec(data)) isnt null
		line = m[0]
			.replace re.replace, ''
			.trim()
		rFileName = path.join p, line
		rFileName = normalizeExtension rFileName, 'styl'
		if db.links[rFileName]?
			if db.links[rFileName].indexOf fileName == -1
				db.links[rFileName].push fileName
		else
			db.links[rFileName] = [fileName]

console.log db
fs.writeFileSync '_linked.json', JSON.stringify(db, null, '    ')
