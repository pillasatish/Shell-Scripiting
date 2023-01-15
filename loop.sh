# Loops and Conditions:
# 1)IF 2) CASE

# Syntax
ACTION=$1
case $ACTION in
    start)
        echo "xy"
        exit 0
        ;;
    stop)
        echo "er"
        exit 0
        ;;
esac