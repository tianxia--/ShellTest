# Get local dir
kernel_name=`uname -s`
IS_MAC_OS=false
if [ $kernel_name = "Darwin" ]; then
    IS_MAC_OS=true
fi

if ! $IS_MAC_OS; then # for Linux only
    alias greadlink="readlink"
fi

CMD_REAL_PATH=`greadlink -e "$0"`
if [ $? -ne 0 ]; then
    CMD_REAL_PATH="$0"
fi

LOCAL_DIR=`dirname "$CMD_REAL_PATH"`

# Extract log files (only available in debug version)
function matrx_extract_log() {
    if [ $# -ne 1 ]; then
        echo "Usage: matrx_extract_log <date, yyMMdd>"
        echo "For example, $ matrx_extract_log 200929"
        return
    fi

    LOG_FILE_NAME=blue_log_$1_main.log
    LOG_FILE_PATH=files/log/$LOG_FILE_NAME
    adb shell run-as io.matrx.platform ls $LOG_FILE_PATH 1> /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "The file $LOG_FILE_PATH doesn't exist!"
        return
    fi

    adb exec-out run-as io.matrx.platform cat $LOG_FILE_PATH > $LOG_FILE_NAME
}

# Dump all memory states
function matrx_dump_state_service() {
    SERVICE_NAME="all"
    if [ $# -ge 1 ]; then
        SERVICE_NAME=$1
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService -a internal.cmd.DSS --es extra.name $SERVICE_NAME
}

# Dump all contacts
function matrx_dump_contacts() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService -a internal.cmd.DC --es extra.spaceId $1
}

# Dump all spaces
function matrx_dump_spaces() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService -a internal.cmd.DS
}

# Dump conversation messages
function matrx_dump_conversation() {
    if [ $# -lt 2 ]; then
        echo "Usage: matrx_dump_conversation <spaceId> <conversation hid> [<max count>]"
        return
    fi

    MAX_COUNT=0
    if [ $# -ge 3 ]; then
        MAX_COUNT=$3
    fi

    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.DC2 --es extra.spaceId $1 --es extra.cid $2 --ei extra.count $MAX_COUNT
}

# Dump message
function matrx_dump_message() {
    if [ $# -ne 3 ]; then
        echo "Usage: matrx_dump_message <spaceId> <conversationId> <message uuid>"
        return
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.DM --es extra.spaceId $1 --es extra.cid $2 --es extra.mid $3
}

# Send test message
function matrx_send_message() {
    if [ $# -ne 2 ]; then
        echo "Usage: matrx_send_message <hid> <timestamp in format yyyyMMdd-HH:mm:ss:SSS>"
        return
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.SM --es extra.hid $1 --es extra.timestr $2
}

# Receive test message
function matrx_receive_message() {
    if [ $# -lt 3 ]; then
        echo "Usage: matrx_receive_message <hidTo> <hidFrom> <timestamp in format yyyyMMdd-HH:mm:ss:SSS> [<count>]"
        return
    fi

    COUNT=1
    if [ $# -ge 4 ]; then
        COUNT=$4
    fi

    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.RM --es extra.hid $1 --es extra.hidFrom $2 --es extra.timestr $3 --ei extra.count $COUNT
}

# Dump message backup DB
function matrx_messagedb_dump() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.MDBD
}

# Test message DB performance
function matrx_messagedb_perf() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.MDBF
}

# Remove conversation and its messages
function matrx_remove_conversation() {
    if [ $# -ne 1 ]; then
        echo "Usage: matrx_remove_conversation <conversation hid>"
        return
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.RC --es extra.cid $1
}

# Start developer mode
function matrx_start_developer() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.SDM
}

# Kill myself
function matrx_kill_myself() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.KM
}

# Check contact or channel
function matrx_check_contact() {
    if [ $# -ne 1 ]; then
        echo "Usage: matrx_check_contact <hid>"
        return
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.CCC --es extra.cid $1
}

# Compute log keys
function matrx_log_key() {
    if [ $# -ne 1 ]; then
        echo "Usage: matrx_log_key <pid>"
        return
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.CLK --el extra.pid $1
}

# Compute all log keys
function matrx_log_all_keys() {
    SPACE_ID="current"
    if [ $# -eq 1 ]; then
        SPACE_ID=$1
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.ALK --es extra.spaceId $SPACE_ID
}

# Decrypt log file
function matrx_log_decrypt() {
    $LOCAL_DIR/log_tools/matrx_log_decrypt.sh $@
}

# Remove chat images
function matrx_remove_chat_images() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.RCT
}

# Enable full profiler
function matrx_profiler_level() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.EFP --es extra.level $1
}

# Dump calendars
function matrx_dump_calendars() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.DC3
}

# Dump latest calendar events
function matrx_dump_calendar_events() {
    if [ $# -ne 1 ]; then
        echo "Usage: matrx_dump_calendar_events <count>"
        return
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.DCE --ei extra.count $1
}

# Search
function matrx_search() {
    if [ $# -ne 1 ]; then
        echo "Usage: matrx_search <key words>"
        return
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.S --es extra.keyWords \"$1\"
}

# Search Dump
function matrx_search_dump() {
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.SD
}


# Pull conversation messages
function matrx_pull_conversation() {
    if [ $# -ne 1 ]; then
        echo "Usage: matrx_pull_conversation <cid>"
        return
    fi
    adb shell am startservice -n io.matrx.platform/com.blue.meeting.application.HelperService \
            -a internal.cmd.PC --es extra.cid $1
 }

read -n 1
