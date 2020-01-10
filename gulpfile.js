const gulp = require("gulp");
const imagemin = require("gulp-imagemin");

const config = {
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
};

const s3 = require("gulp-s3-upload")(config);
const { series } = require("gulp");
const { src, dest } = require("gulp");

// TODO: We should decide on either JPG or PNG
function processImages() {
  return gulp
    .src("./src/*/screenshots/*.{jpg,png}")
    .pipe(
      imagemin([
        imagemin.jpegtran({ progressive: true }),
        imagemin.optipng({ optimizationLevel: 5 })
      ])
    )
    .pipe(gulp.dest("dist"));
}

function moveIcons() {
  return src("./src/*/icons/*.{svg,png}").pipe(dest("dist"));
}

function upload() {
  return gulp.src("./dist/**").pipe(
    s3(
      {
        Bucket: "assets.software.pantherx.org",
        ACL: "public-read"
      },
      {
        maxRetries: 5
      }
    )
  );
}

exports.default = series(processImages, moveIcons, upload);
