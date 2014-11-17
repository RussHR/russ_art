# Gulp
gulp = require('gulp')

# Plugins
jade = require('gulp-jade')
sass = require('gulp-sass')
plumber = require('gulp-plumber')
prefix = require('gulp-autoprefixer')
minifycss = require('gulp-minify-css')
uglify = require('gulp-uglify')
imagemin = require('gulp-imagemin')
livereload = require('gulp-livereload')
lr = require('tiny-lr')
server = lr()

# Paths
paths =
  scripts: ['assets/js/*.js']
  images: ['assets/img/**']
  fonts: ['assets/fonts/**']


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
    .pipe(prefix("last 1 version", "> 1%", "ie 8", "ie 7"))
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

# Compress images
gulp.task 'imagemin', ->
  gulp.src(paths.images)
    .pipe(plumber())
    .pipe(imagemin())
    .pipe(gulp.dest('Build/assets/img'))

# Copy all static assets
gulp.task 'copyFonts', ->
  gulp.src(paths.fonts)
    .pipe(gulp.dest('Build/assets/fonts'))

# Livereload
gulp.task 'listen', ->
  server.listen 35729, (err) ->
    return console.log if err?

# Watch files
gulp.task 'watch', (event) ->
  gulp.watch('**/*.jade', ['jade'])
  gulp.watch('assets/scss/*.scss', ['sass'])
  gulp.watch(paths.images, ['imagemin'])
  gulp.watch(paths.fonts, ['copyFonts'])
  gulp.watch(paths.scripts, ['uglify'])

gulp.task('default', ['listen', 'watch'])