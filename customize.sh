#1.Extra file

DEVICECODE=$(getprop ro.product.device)
ui_print "-"
ui_print "- Your device's code is $DEVICECODE."

MOD_TARGET_DIR="$MODPATH/system/product/etc/device_feature"
SRC_FILE="/system/product/etc/device_feature/$DEVICECODE.xml"

if [ -f "$SRC_FILE" ]; then
    ui_print "- Extracting $DEVICECODE.xml"
    mkdir -p "$MOD_TARGET_DIR"
    cp "$SRC_FILE" "$MOD_TARGET_DIR/$DEVICECODE.xml"
else
    abort "! Error: Device feature file not found for $DEVICECODE"
fi
ui_print "- then..."

#2.Change feature bool

TARGET_FILE="$MOD_TARGET_DIR/$DEVICECODE.xml"

change_bool() {
    local feature=$1
    local bool=$2
    local file=$3
    local comment=$4

    if grep -q "name=\"$feature\"" "$file"; then
        ui_print "-"
        ui_print "- Feature $feature exists, changing bool..."
        sed -i "s|<bool name=\"$feature\">.*</bool>|<bool name=\"$feature\">$bool</bool>|g" "$file"
    else
        ui_print "-"
        ui_print "- Feature $feature not found, adding new entry..."
        if [ ! -z "$comment" ]; then
            sed -i "/<\/features>/i \    <!-- $comment -->" "$file"
        fi
        sed -i "/<\/features>/i \    <bool name=\"$feature\">$bool</bool>" "$file"
    fi
}

change_bool "support_aod_fullscreen" "true" "$TARGET_FILE" "whether the device supports aod fullscreen mode"

ui_print "  "
ui_print "- Everything done!"
