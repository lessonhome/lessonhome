for i in `find . -regex ".*\.\(jpg\|jpeg\)"`
  do jpegoptim "$i" &
done
