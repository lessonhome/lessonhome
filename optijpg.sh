for i in `find . -regex ".*\.\(jpg\|jpeg\)"`
  do jpegoptim "$i" -s -m70 --all-progressive &
done
for i in `find . -regex ".*\.\(gif\|png\)"`
  do optipng "$i" -o5 -strip all &
done
