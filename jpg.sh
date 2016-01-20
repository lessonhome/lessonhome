find static -type d -exec sh -c '
ls "$0"/*.jpg 2>/dev/null && jpegoptim --strip-all -t "$0"/*.jpg
' {} \;
find static -type d -exec sh -c '
ls "$0"/*.png 2>/dev/null && optipng -o7 "$0"/*.jpg
' {} \;

find static -type d -exec sh -c '
ls "$0"/*.gif 2>/dev/null && optipng -o7 "$0"/*.jpg
' {} \;
