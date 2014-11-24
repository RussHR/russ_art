# Gulp
gulp = require('gulp')

# Plugins
autoprefix = require('gulp-autoprefixer')
connect = require('gulp-connect')
jade = require('gulp-jade')
livereload = require('gulp-livereload')
minifycss = require('gulp-minify-css')
plumber = require('gulp-plumber')
sass = require('gulp-sass')
uglify = require('gulp-uglify')

# Paths
paths =
  scripts: ['assets/js/*.js']
  root: 'dist'

# Jade to HTML
gulp.task 'jade', ->
  gulp.src(['**/*.jade', '!./{node_modules/**, node_modules}'])
    .pipe(plumber())
    .pipe(jade({pretty: true}))
    .pipe(gulp.dest('dist/'))
    .pipe(connect.reload())

# Compile Sass
gulp.task 'sass', ->
  gulp.src(['assets/scss/*.scss', '!assets/scss/_variables.scss'])
    .pipe(plumber())
    .pipe(sass(
      includePaths: ['assets/scss', 'bower_components/foundation/scss']
      outputStyle: 'expanded'
    ))
    .pipe(autoprefix())
    .pipe(gulp.dest('dist/assets/css'))
    .pipe(minifycss())
    .pipe(gulp.dest('dist/assets/css'))
    .pipe(connect.reload())

# Uglify JS
gulp.task 'uglify', ->
  gulp.src(paths.scripts)
    .pipe(plumber())
    .pipe(uglify({outSourceMap: false}))
    .pipe(gulp.dest('dist/assets/js'))

# connect
gulp.task 'connect', ->
  connect.server
    root: paths.root
    port: 8000
    livereload: true

# Watch files
gulp.task 'watch', (event) ->
  gulp.watch('**/*.jade', ['jade'])
  gulp.watch('assets/scss/*.scss', ['sass'])
  gulp.watch(paths.scripts, ['uglify'])

gulp.task('default', ['connect', 'watch'])
gulp.task('serve', ['jade', 'sass', 'uglify', 'connect', 'watch'])
