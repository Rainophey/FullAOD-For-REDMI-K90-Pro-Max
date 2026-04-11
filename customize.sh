DEIVCECODE=$(getprop ro.product.device)
ui_print "- Your device's code is $DEVICECODE."

MOD_TARGET_DIR="$MODPATH/system/product/etc/device_feature"

SRC_FILE="/system/product/etc/device_feature/$CODENAME.xml"

if [ -f "$SRC_FILE" ]; then
    ui_print "- Extracting $DEIVCECODE.xml..."
    mkdir -p "$MOD_TARGET_DIR"
    cp "$SRC_FILE" "$MOD_TARGET_DIR/$DEIVCECODE.xml"
else
    # 如果没找到对应文件，中止安装并报错
    abort "! Error: Device feature file not found for $DEIVCECODE"
fi
