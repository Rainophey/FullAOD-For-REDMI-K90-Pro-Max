DEVICECODE=$(getprop ro.product.device)
MOD_TARGET_DIR="$MODPATH/system/product/etc/device_features"
SRC_FILE="/system/product/etc/device_features/$DEVICECODE.xml"
TARGET_FILE="$MOD_TARGET_DIR/$DEVICECODE.xml"

ui_log() {
    ui_print "- $1"
}

change_bool() {
    local feature=$1
    local bool=$2
    local file=$3
    local comment=$4

    if grep -q "name=\"$feature\"" "$file"; then
        ui_log ""
        ui_log "Feature $feature exists, changing bool..."
        sed -i "s|<bool name=\"$feature\">.*</bool>|<bool name=\"$feature\">$bool</bool>|g" "$file"
    else
        ui_log ""
        ui_log "Feature $feature not found, adding new entry..."
        if [ -n "$comment" ]; then
            sed -i "/<\/features>/i\\
    <!-- $comment -->" "$file"
        fi
        sed -i "/<\/features>/i\\
    <bool name=\"$feature\">$bool</bool>" "$file"
    fi
}

#1.Extract file

ui_log ""
ui_log "Your device's code is $DEVICECODE."

if [ -f "$SRC_FILE" ]; then
    ui_log "- Extracting $DEVICECODE.xml"
    mkdir -p "$MOD_TARGET_DIR"
    cp "$SRC_FILE" "$MOD_TARGET_DIR/$DEVICECODE.xml"
else
    abort "! Error: Device feature file not found for $DEVICECODE"
fi
ui_log "- then..."

#2.Change feature bool

#Add fullaod supported
change_bool "support_aod_fullscreen" "true" "$TARGET_FILE" "whether the device supports aod fullscreen mode"
#Add some gallery feature unknown if effective
change_bool "gallery_support_dolby" "true" "$TARGET_FILE" "gallery setting added"
change_bool "gallery_support_print" "true" "$TARGET_FILE"
