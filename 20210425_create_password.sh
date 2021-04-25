read -p "please input username ："  user

# -z 可以判断一个变量是不是为空
if [ -z $user ];then
	echo "you must input username!"
	exit 2
fi

#使用 stty -echo 关闭 shell 回显功能
#使用 stty echo 打开回显功能
stty -echo
read -p "please input password:"  pass
stty echo 

pass=${pass:-123456}
useradd "$user"
echo "$pass" | passwd --stdin "$user"
