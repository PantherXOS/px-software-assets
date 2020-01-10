var { gulp, series, src, dest } = require("gulp");
var imagemin = require("gulp-imagemin");

var config = {
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
};

var s3 = require("gulp-s3-upload")(config);

function processImages() {
  return (
    gulp
      // TODO: We should decide on either JPG or PNG
      .src("src/*/screenshots/*.{jpg,png}")
      .pipe(
        imagemin([
          imagemin.jpegtran({ progressive: true }),
          imagemin.optipng({ optimizationLevel: 5 })
        ])
      )
      .pipe(gulp.dest("dist"))
  );
}

function moveIcons() {
  return src("src/*/icons/*.{svg,png}").pipe(dest("dist"));
}

function upload() {
  return gulp.src("./dist").pipe(
    s3(
      {
        Bucket: "assets.software.pantherx.org",
        ACR: "public-read"
      },
      {
        maxRetries: 5
      }
    )
  );
}

exports.default = series(processImages, moveIcons, upload);
