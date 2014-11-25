# Gulp
gulp = require('gulp')

# Plugins
autoprefix = require('gulp-autoprefixer')
concat = require('gulp-concat')
connect = require('gulp-connect')
jade = require('gulp-jade')
minifycss = require('gulp-minify-css')
plumber = require('gulp-plumber')
sass = require('gulp-sass')
uglify = require('gulp-uglify')

# Paths
paths =
  scripts: ['app/scripts/*.js']
  root: 'dist/'

# Jade to HTML
gulp.task 'jade', ->
  gulp.src('app/*.jade')
    .pipe(plumber())
    .pipe(jade({pretty: true}))
    .pipe(gulp.dest('dist/'))
    .pipe(connect.reload())

# Compile Sass
gulp.task 'sass', ->
  gulp.src(['app/styles/*.sass', 'app/styles/*.scss'])
    .pipe(plumber())
    .pipe(sass(
      includePaths: ['app/styles', 'bower_components/foundation/scss']
      sourceComments: 'normal' # this hack allows compilation of sass syntax
    ))
    .pipe(autoprefix())
    .pipe(concat('russ_art_main.css'))
    .pipe(minifycss())
    .pipe(gulp.dest('dist/'))
    .pipe(connect.reload())

# Uglify JS
gulp.task 'uglify', ->
  gulp.src(paths.scripts)
    .pipe(plumber())
    .pipe(uglify({outSourceMap: false}))
    .pipe(gulp.dest('dist/app/js'))

# connect
gulp.task 'connect', ->
  connect.server
    root: paths.root
    port: 8000
    livereload: true

# Watch files
gulp.task 'watch', (event) ->
  gulp.watch('**/*.jade', ['jade'])
  gulp.watch('app/scss/*.scss', ['sass'])
  gulp.watch(paths.scripts, ['uglify'])

gulp.task('default', ['connect', 'watch'])
gulp.task('serve', ['jade', 'sass', 'uglify', 'connect', 'watch'])
