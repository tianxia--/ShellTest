myping(){
	ping -c 2 -i 0.3 -W 1 $1 &>/dev/null
	if [ $? -eq 0 ];then
		echo "$1 is up"
	else
		echo "$1 is down"
	fi
}

#使用 & 符号让函数在后台执行
for i in {1..254}
do
	myping 192.168.197.$i &
done
