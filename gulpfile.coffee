gulp = require 'gulp'
gutil  = require 'gulp-util'
ghPages = require 'gulp-gh-pages'
rimraf = require 'rimraf'
minimist = require 'minimist'
nib = require 'nib'


fs = require 'fs'
path = require 'path'
db = {}


plugins = require('gulp-load-plugins')({
		pattern: ['gulp-*', 'gulp.*']
		replaceString: /\bgulp[\-.]/
	})

basePaths =

	src: 'src'
	dest: 'www'
	bower: 'src/bower'

paths =

	img:
		src: basePaths.src + '/img/'
		dest: basePaths.dest + '/img/'

	html:
		src: basePaths.src
		dest: basePaths.dest
		jade: [
			"#{basePaths.src}/**/*.jade"
			"!#{basePaths.src}/**/_**/**"
			"!#{basePaths.src}/**/_*"
			"!#{basePaths.bower}/**"
		]

	js:
		src: basePaths.src + '/js/'
		dest: basePaths.dest + '/js/'
		coffee: [
			"#{basePaths.src}/js/**/*.coffee"
			"!#{basePaths.src}/js/**/_**/**"
			"!#{basePaths.src}/js/**/_*"
		]

	css:
		src: basePaths.src + '/css/'
		dest: basePaths.dest + '/css/'
		stylus: [
			"#{basePaths.src}/css/**/*.styl"
			"!#{basePaths.src}/css/**/_**/**"
			"!#{basePaths.src}/css/**/_*"
		]

configs = 

	jade:
		pretty: true

	coffee:
		bare: false

	stylus:
		compress: false
		use: nib()
		import: 'nib'

	size:
		showFiles: true
		gzip: true

	clone:
		src: [
				"#{basePaths.src}/**/*"
				"!#{basePaths.src}/**/*.coffee"
				"!#{basePaths.src}/**/*.styl"
				"!#{basePaths.src}/**/*.jade"
				"!#{basePaths.src}/**/_**/**"
				"!#{basePaths.src}/**/_*"
			]

knowOptions =
	string: 'p',
	default: { p: 8080 }

options = minimist(process.argv.slice(2), knowOptions)

onError = (e) ->
	gutil.log e
	this.emit 'end'

onChange = (e) ->
	gutil.log 'file', gutil.colors.cyan(e.path.replace(new RegExp('/.*(?=/' + basePaths.src + ')/'), '')), 'was', gutil.colors.magenta(e.type)

gulp.task 'jade', [], () ->
	gulp.src paths.html.jade
		# .pipe plugins.changed(paths.html.dest, extension: '.html')
		.pipe plugins.jade(configs.jade).on('error', onError)
		.pipe plugins.size(configs.size)
		.pipe plugins.connect.reload()
		.pipe gulp.dest(paths.html.dest)

gulp.task 'coffee', [], () ->
	gulp.src paths.js.coffee
		.pipe plugins.coffee(configs.coffee).on('error', onError)
		.pipe plugins.size(configs.size)
		.pipe plugins.connect.reload()
		.pipe gulp.dest(paths.js.dest)

gulp.task 'stylus', [], () ->
	gulp.src paths.css.stylus
		.pipe plugins.stylus(configs.stylus).on('error', onError)
		.pipe plugins.size(configs.size)
		.pipe plugins.connect.reload()
		.pipe gulp.dest(paths.css.dest)

gulp.task 'html', ['jade']
gulp.task 'js', ['coffee']
gulp.task 'css', ['stylus']

gulp.task 'clone', () ->
	gulp.src configs.clone.src
		.pipe plugins.size(configs.size)
		.pipe gulp.dest(basePaths.dest)
		.on 'error', (e) ->
			console.log e
			this.emit 'end'

gulp.task 'clean', (cb) ->
	rimraf(basePaths.dest, cb)

gulp.task 'connect', () ->
	plugins.connect.server({
		port: options.p
		root: './www',
		livereload: false
		})

gulp.task 'watch', [], () ->
	gulp.watch paths.html.jade, ['html']
		.on 'change', onChange
	gulp.watch paths.js.coffee, ['js']
		.on 'change', onChange
	gulp.watch paths.css.stylus, ['css']
		.on 'change', onChange
	# gulp.watch configs.clone.src, ['clone']
	#	.on 'change', onChange

gulp.task 'deploy', [], () ->
	gulp.src "#{basePaths.dest}/**/*"
		.pipe ghPages()

gulp.task 'default', () ->
	gutil.log gutil.colors.cyan('gulp build') + ' to rebuild all files.'
	gutil.log gutil.colors.cyan('gulp clean') + ' to clean all built files.'
	gutil.log gutil.colors.cyan('gulp compile') + ' to compile HTML, JS, CSS.'
	gutil.log gutil.colors.cyan('gulp server') + ' to start server on 8080 port.'
	gutil.log gutil.colors.cyan('gulp server -p 8888') + ' to start server on 8888 port.'

gulp.task 'compile', ['html', 'js', 'css', 'clone']
gulp.task 'build', ['clean', 'compile']
gulp.task 'server', ['compile', 'connect', 'watch']
gulp.task 'test', ['analysis', 'connect', 'watch']