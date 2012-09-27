#!
for size in 16 32 128 256 512; do
	f=icon_"$size"x"$size".png
	cp "$1" "$f"
	sips -z $size $size "$f"
done

for size in 16 32 128 256 512; do
	f=icon_"$size"x"$size"@2x.png
	cp "$1" "$f"
	rsize=`expr $size "*" 2`
	sips -z $rsize $rsize "$f"
done