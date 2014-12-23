# use process.stdout.write instead of console.log
# Gulp
gulp = require('gulp')

# Plugins
autoprefix = require('gulp-autoprefixer')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
connect = require('gulp-connect')
jade = require('gulp-jade')
minifycss = require('gulp-minify-css')
plumber = require('gulp-plumber')
sass = require('gulp-sass')
uglify = require('gulp-uglify')

# Paths
paths =
  coffee: ['app/scripts/coffee/*.coffee']
  # these must be listed in order
  js: ['app/scripts/js/*.js', 'app/scripts/js/compiled_coffee.js']
  root: 'dist/'

# Images (favicon for now)
gulp.task 'images', ->
  gulp.src('app/favicon.ico')
    .pipe(gulp.dest('dist/'))

# Jade to HTML
gulp.task 'jade', ->
  gulp.src('app/*.jade')
    .pipe(plumber())
    .pipe(jade({pretty: true}))
    .pipe(gulp.dest('dist/'))
    .pipe(connect.reload())

# Compile Sass
gulp.task 'sass', ->
  gulp.src(['app/styles/foundation.scss', 'app/styles/*.sass', 'app/styles/*.scss'])
    .pipe(plumber())
    .pipe(sass(
      includePaths: ['app/styles']
      sourceComments: 'normal' # this hack allows compilation of sass syntax
    ))
    .pipe(autoprefix())
    .pipe(concat('russ_art_main.css'))
    .pipe(minifycss())
    .pipe(gulp.dest('dist/assets/'))
    .pipe(connect.reload())

# Compile JS
gulp.task 'uglify', ['coffee'], ->
  gulp.src(paths.js)
    .pipe(plumber())
    .pipe(concat('russ_art_main.js'))
    .pipe(uglify({outSourceMap: false}))
    .pipe(gulp.dest('dist/assets'))
    .pipe(connect.reload())
# Compile Coffee
gulp.task 'coffee', ->
  gulp.src(paths.coffee)
    .pipe(plumber())
    .pipe(coffee())
    .pipe(concat('compiled_coffee.js'))
    .pipe(gulp.dest('app/scripts/js'))
    .pipe(connect.reload())

# connect
gulp.task 'connect', ->
  connect.server
    root: paths.root
    port: 8000
    livereload: true

# Watch files
gulp.task 'watch', (event) ->
  gulp.watch('**/*.jade', ['jade'])
  gulp.watch(['app/**/*.sass', 'app/**/*.scss'], ['sass'])
  gulp.watch('app/**/*.coffee', ['uglify'])
  # gulp.watch(paths.scripts, ['scripts'])

gulp.task('default', ['connect', 'watch'])
gulp.task('serve', ['jade', 'sass', 'uglify', 'images', 'connect', 'watch'])
