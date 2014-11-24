# Gulp
gulp = require('gulp')

# Plugins
jade = require('gulp-jade')
sass = require('gulp-sass')
plumber = require('gulp-plumber')
autoprefix = require('gulp-autoprefixer')
minifycss = require('gulp-minify-css')
uglify = require('gulp-uglify')
livereload = require('gulp-livereload')
connect = require('connect')
server = connect()

# Paths
paths =
  scripts: ['assets/js/*.js']
  images: ['assets/img/**']

# Jade to HTML
gulp.task 'jade', ->
  gulp.src(['**/*.jade', '!./{node_modules/**, node_modules}'])
    .pipe(plumber())
    .pipe(jade({pretty: true}))
    .pipe(gulp.dest('Build/'))
    .pipe(livereload(server));

# Compile Sass
gulp.task 'sass', ->
  gulp.src(['assets/scss/*.scss', '!assets/scss/_variables.scss'])
    .pipe(plumber())
    .pipe(sass(
      includePaths: ['assets/scss', 'bower_components/foundation/scss']
      outputStyle: 'expanded'
    ))
    .pipe(autoprefix())
    .pipe(gulp.dest('Build/assets/css'))
    .pipe(minifycss())
    .pipe(gulp.dest('Build/assets/css'))
    .pipe(livereload(server))

# Uglify JS
gulp.task 'uglify', ->
  gulp.src(paths.scripts)
    .pipe(plumber())
    .pipe(uglify({outSourceMap: false}))
    .pipe(gulp.dest('Build/assets/js'))

# Livereload
gulp.task 'listen', ->
  server.use(connect.static('Build')).listen(8000, next);

# Watch files
gulp.task 'watch', (event) ->
  gulp.watch('**/*.jade', ['jade'])
  gulp.watch('assets/scss/*.scss', ['sass'])
  gulp.watch(paths.scripts, ['uglify'])

gulp.task('default', ['listen', 'watch'])