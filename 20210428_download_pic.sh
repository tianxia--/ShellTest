url="https://scpic.chinaz.net/files/pic/pic9/202104/bpic230"
echo "start downloading..."
sleep 2
type=jpg
for i in {40..50}
do
	echo "current download ${url}${i}.${type}"
	curl ${url}${i}.${type} -o /d/ShellTest/temp/${i}.${type}
	sleep 1
done

