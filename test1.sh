name="this is my name";
echo ${name:1:4}

echo ${name::4}

array_name=(hahah hahahaha hahahahahahaha hahahahahahahaha)
array_para[0]="w";
array_para[3]="s"

array_name[0]="zhao"

echo ${array_name[0]}
echo ${array_name[1]}
echo ${array_name[2]}

val=$((2+2));
echo ${val}

a=20;
b=20;

if [ $a -eq $b ];then
  echo "a b相等";
fi

a=10;
if [ $a -ne $b ];then
  echo "a b 不相等";
fi


funWithParam(){
  echo "第一个参数为 $1 "
  echo "第二个参数为 $2 "
  echo "第十个参数为 $10 "
  echo "弟十一个参数 ${11} "

  echo "参数总个数：$# "
  echo "输出所有参数: $* "

}

echo $? 

funWithParam  1 1 2 3 4 5 6 7 8 9 20 11 12 13

function recursive_copy_file(){
  dirlist=$(ls $1 )
  

  for name in ${dirlist[*]}
  
  do 
 	if [ -f $1/$name ]; then 
		if [ ! -f $2/$name ];then
			cp $1/$name $2/$name

		fi
	elif [ -d $1/$name ];then
		if [ ! -d $1/$name ]; then
			mkdir -p $2/$name
		fi
		recurs_copy_file $1/$name $2/$name
	fi

done
}

source_dir="D:\log\apk\debug"
dist_dir="D:\log\apkpath\debug"


recursive_copy_file  $source_dir  $dist_dir

