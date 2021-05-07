kernel_name=`uname -s`
echo "$kernel_name"

IS_MAC_OS=false
if [ $kernel_name = "Darwin" ];then
	IS_MAC_OS = true
fi

echo "current sys config is mac_os: ${IS_MAC_OS}"

if [ !$IS_MAC_OS ];then
	alias greadlink="readlink"
fi

CMD_REAL_PATH=`greadlink -e "$0"`
echo "get current .sh file abslute path: $CMD_REAL_PATH"

if [ $? -ne 0 ];then
	CMD_REAL_PATH="$0"
	echo "last cmd prefrom fail"
fi

CMD_DIR=`dirname "$CMD_REAL_PATH"`
echo "current cmd dir:$CMD_DIR "

KEYS_FILE=$CMD_DIR/UAE-971-0000001_keys_b2afd210-b504-442b-b350-afeb03470c71
SRC_DIR=$CMD_DIR/src
BIN_DIR=$CMD_DIR/bin

mkdir -p $CMD_DIR
javac $SEC_DIR/*.java -d $BIN_DIR && java -classpath $BIN_DIR LogFileDecryptor --keysFilePath=$KEYS_FILE $@
rm -rf $BIN_DIR

