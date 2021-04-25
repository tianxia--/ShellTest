# 脚本生吃一个100 以内的随机数，提示用户猜数字，根据用户的输入，提示猜数字的情况。

# RANDOM 为系统自带的系统变量，值为0-32767

num=$[RANDOM%100+1]
echo $num

while :
do
	read -p "计算机随机生成了一个1-100的数字，你猜：" cai
	if [ $cai -eq $num ];then 
		echo "恭喜,你猜对了!"
		num=$[RANDOM%100+1]
	elif [ $cai -gt $num ];then 
		echo "你猜大了!"
	else 
		echo “你猜小了!”
	fi
done
