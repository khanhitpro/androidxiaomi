#!/bin/bash

# =================== TOOL CÀI TIVI XIAOMI TEMUX 25 T6 2026 ===================
# Thư mục nguồn chuẩn trên Termux
SOURCE_DIR="$HOME/androidxiaomi"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'

BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BBLUE='\033[1;34m'
BMAGENTA='\033[1;35m'
BCYAN='\033[1;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'

RESET='\033[0m'
NC='\033[0m'

trap 'adb disconnect >/dev/null 2>&1; exit' INT TERM

# =================== HÀM DÙNG CHUNG ===================
print_header() {
    clear
    echo
    echo -e "${CYAN}🚀 TOOL CÀI TIẾNG VIỆT CHO TIVI XIAOMI NỘI ĐỊA${RESET}"
    echo -e "${GREEN}📞  Hotline: 0967.341.608 BY KHÁNH IT${RESET}"
    echo -e "${WHITE}⚠️  Bản Cập Nhật: 25-06-2026 Phiên bản: 4.70${RESET}"
    echo
}

check_adb() {
    if ! adb version >/dev/null 2>&1; then
        echo -e "${RED}❌ adb chưa sẵn sàng. Hãy chạy:${RESET}"
        echo "apk add android-tools bash"
        exit 1
    fi
}

install_apk() {
    local apk_name="$1"
    local full_path="$SOURCE_DIR/$apk_name"
    if [ -f "$full_path" ]; then
        echo -e "  → Đang cài đặt ứng dụng: ${GREEN}$apk_name${RESET}"
        adb install -r -g "$full_path" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "    ${GREEN}✓ Đã cài thành công${RESET}"
        else
            echo -e "    ${RED}✗ Lỗi: Cài đặt thất bại${RESET}"
        fi
    else
        echo -e "    ${RED}⚠ Không tìm thấy file $apk_name tại thư mục $SOURCE_DIR${RESET}"
    fi
}

# =================== KIỂM TRA MÔI TRƯỜNG ===================
check_adb

# =================== MENU 1: KẾT NỐI TV ===================
menu1() {
    while true; do
        print_header
        echo -e "${BLUE}📡 MENU KẾT NỐI TIVI XIAOMI PRO${RESET}"
        echo -e "${BLUE}────────────────────────────${RESET}"
        echo ""
        echo -e "${MAGENTA}📺 HƯỚNG DẪN KẾT NỐI TIVI${RESET}\n"
        echo -e "${CYAN}🎮 Điều khiển:${RESET} ${YELLOW}↑ lên trên cùng${RESET} → ${WHITE}Cài đặt ⚙${RESET}"
        echo -e "${CYAN}🌐 Ngôn ngữ :${RESET} ${YELLOW}↓ 4 lần${RESET} → ${WHITE}Language${RESET} → ${GREEN}English${RESET}"
        echo -e "${CYAN}🔓 Developer:${RESET} ${WHITE}About${RESET} → ${YELLOW}Model${RESET} → ${GREEN}OK 9 lần${RESET}"
        echo -e "${CYAN}⚙️  Quyền    :${RESET} ${GREEN}ADB Debugging${RESET} + ${GREEN}Unknown Sources${RESET}"
        echo -e "${CYAN}⛔ Lưu ý    :${RESET} ${RED}Tắt Update tự động${RESET}"
        echo ""
        echo -e "${BLUE}────────────────────────────${RESET}"
        read -p "$(echo -e "${GREEN}📶 Nhập IP Tivi:${RESET} ")" RAW_IP
        [ -z "$RAW_IP" ] && continue

        [[ "$RAW_IP" != *":5555" ]] && DEVICE_IP="${RAW_IP}:5555" || DEVICE_IP="$RAW_IP"

        local retry_count=0
        local max_retries=5
        local connected=false

        while [ $retry_count -le $max_retries ]; do
            echo -e "\n→ ${CYAN}Đang thử kết nối (Lần $((retry_count + 1)))...${RESET}"
            
            adb disconnect >/dev/null 2>&1
            adb connect "$DEVICE_IP" >/dev/null 2>&1
            
            sleep 3 

            if adb devices | grep -q "$DEVICE_IP.*device"; then
                connected=true
                break
            else
                echo -e "${RED}✗ Bấm OK trên điều khiển để tích vào ô đồng ý...${RESET}"
                echo -e "${RED}✗ Sau đó bấm phím xuống -> Sang phải -> Allow/OK${RESET}"
                retry_count=$((retry_count + 1))
            fi
        done

        if [ "$connected" = true ]; then
            echo -e "${GREEN}✓ Kết nối thành công đến tivi !${RESET}"
            echo -e "${GREEN}✓ Chào mừng bạn đến với MENU CÀI ĐẶT !${RESET}"
            echo -e "📱 TV đang kết nối tại: ${GREEN}$DEVICE_IP${RESET}"
            export DEVICE_IP
            sleep 1
            menu2
            break 
        else
            echo -e "${RED}⛔ Đã thử 6 lần thất bại. KIỂM TRA lại IP hoặc ADB Debugging trên TV ĐÃ BẬT CHƯA.${RESET}"
            echo -e "${RED}⛔ Vui lòng kiểm tra lại IP hoặc BẤM ĐỒNG Ý CHO PHÉP ĐIỆN THOẠI KẾT NỐI ĐẾN TIVI.${RESET}"
            sleep 5
        fi
    done
}

# =================== MENU 2 ===================
menu2() {
    while true; do
        print_header
        echo -e "📱 TV đang kết nối tại: ${GREEN}$DEVICE_IP${RESET}"
        echo
        
        MODEL=$(adb shell getprop ro.product.model | tr -d '\r')
        BRAND=$(adb shell getprop ro.product.brand | tr -d '\r')
        PANEL=$(adb shell getprop ro.boot.mi.panel_size 2>/dev/null | tr -d '\r')
        ANDROID=$(adb shell getprop ro.build.version.release | tr -d '\r')
        PATCH=$(adb shell getprop ro.build.version.security_patch | tr -d '\r')
        BUILD_SHOW=$(adb shell getprop ro.build.version.incremental | tr -d '\r')
        DATE=$(adb shell getprop ro.build.date | tr -d '\r')
        SERIAL=$(adb shell getprop ro.serialno | tr -d '\r')
        SDK=$(adb shell getprop ro.build.version.sdk | tr -d '\r')
        DEVICE=$(adb shell getprop ro.product.device | tr -d '\r')
        
        [ -z "$PANEL" ] && PANEL="?"
        
        echo -e "${YELLOW}────────────────────────────────────────${RESET}"
        echo -e "${CYAN}📺${RESET} $MODEL ${GRAY}|${RESET} ${YELLOW}$BRAND${RESET} ${GRAY}|${RESET} ${GREEN}Tivi (${PANEL} Inch)${RESET}"
        echo -e "${CYAN}🤖${RESET} Android $ANDROID ${GRAY}|${RESET} ${BLUE}$BUILD_SHOW${RESET}"
        echo -e "${CYAN}🆔${RESET} $SERIAL${GRAY}|${RESET}${BLUE}SDK $SDK${RESET}${GRAY}|${RESET} $DEVICE"
        echo -e "${CYAN}📅${RESET} $DATE ${GRAY}|${RESET} ${RED}$PATCH${RESET}"
        echo -e "${YELLOW}────────────────────────────────────────${RESET}"
        echo
        echo -e "${MAGENTA}📋 MENU CÀI ĐẶT GIAO DIỆN TIVI${RESET}"
        echo
        echo -e "${CYAN}[1]${RESET} 🚀 Cài Launcher ${GREEN}PROJECTIVY TIVI NỘI ĐỊA${RESET}"
        echo -e "${CYAN}[2]${RESET} 🚀 Cài Giao Diện ${GREEN}PROJECTIVY cho Box${RESET}"
        echo -e "${CYAN}[3]${RESET} 📦 Cài Giao Diện và ${YELLOW}App Cho${RESET} GOOGLE TV"
        echo -e "${CYAN}[4]${RESET} 🖼️ Gửi Picture ${YELLOW}và Backup${RESET} vào TV"
        echo -e "${CYAN}[5]${RESET} 🔄 Khởi động lại TV"
        echo -e "${CYAN}[6]${RESET} ⚠️ ${RED}Khởi động vào XOÁ SẠCH DỮ LIỆU TIVI${RESET}"
        echo -e "${CYAN}[7]${RESET} ↩️ Quay lại menu kết nối"
        echo -e "${CYAN}[8]${RESET} 🔓 Cài Launcher ${GREEN}PROJECTIVY 14 2026${RESET}"
        echo -e "${CYAN}[9]${RESET} 🔓 Cập Nhật App ${GREEN}Cho NỘI ĐỊA + Google TV + Box${RESET}"
        echo -e "${CYAN}[0]${RESET} ❌ Thoát"
        echo
        read -p "🔄 → Nhập tùy chọn của bạn [0-9]: " CHOICE

        case $CHOICE in
            1) install_projectivy ;;
            2) install_box ;;
            3) install_googletv ;;
            4) backup_picture ;;
            5) reboot_tv "normal" ;;
            6) reboot_tv "recovery" ;;
            7) menu1 ;;
            8) install_projectivy14 ;;
            9) allappxiaomi ;; 
            0) echo "👋 Tạm biệt!"; exit 0 ;;
            *) echo -e "${RED}⚠️  Lựa chọn không hợp lệ! Vui lòng chọn lại từ 0 đến 9.${RESET}"; sleep 2 ;;
        esac
    done
}

# =================== CHỨC NĂNG ===================

install_projectivy() {
    print_header
    echo -e "${GREEN}===========================================================${RESET}"
    echo -e "${YELLOW}    BẮT ĐẦU QUÁ TRÌNH VIỆT HÓA VÀ TỐI ƯU HỆ THỐNG TV...    ${RESET}"
    echo -e "${GREEN}===========================================================${RESET}"
    echo

    echo -e "${CYAN}[10%]${RESET} ⚙️  ${GREEN}Đang cấu hình múi giờ, ngôn ngữ và tối ưu hiệu ứng hệ thống...${RESET}"
    adb shell service call alarm 3 s16 Asia/Bangkok >/dev/null 2>&1
    adb shell settings put global device_locales vi-VN >/dev/null 2>&1
    adb shell settings put global sys_locale vi-VN >/dev/null 2>&1
    adb shell settings put system system_locales vi-VN >/dev/null 2>&1
    adb shell settings put global heads_up_notifications_enabled 0 >/dev/null 2>&1
    adb shell settings put global stay_on_while_plugged_in 3 >/dev/null 2>&1
    adb shell settings put global window_animation_scale 1 >/dev/null 2>&1
    adb shell settings put global transition_animation_scale 1 >/dev/null 2>&1
    adb shell settings put global animator_duration_scale 1 >/dev/null 2>&1

    echo -e "${CYAN}[25%]${RESET} 📦 Đang cài đặt ${GREEN}Projectivy Launcher${RESET} cho Android ${WHITE}9-11${RESET}..."
    install_apk "p.apk"

    adb shell monkey -p com.spocky.projengmenu -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
    adb shell am start -n com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1
    adb shell cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1

    echo -e "${CYAN}[30%]${RESET} 🗑️  ${RED}Đang dọn dẹp các dịch vụ quảng cáo China Trung Quốc...${RESET}"
    adb shell pm disable-user --user 0 com.mitv.tvhome >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.tvqs >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.mitv.gallery >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.tv.gallery >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.tweather >/dev/null 2>&1
    
    adb shell pm disable-user --user 0 com.mitv.screensaver >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.hyper.screensaver >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.aod.screensaver >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.shop >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.duokan.videodaily >/dev/null 2>&1
    
    adb shell pm disable-user --user 0 com.mitv.cloudcontrol >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.miui.tv.analytics >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.smarthome.tv >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.voicecontrol >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.upgrade >/dev/null 2>&1
    
    adb shell pm disable-user --user 0 com.xiaomi.mitv.appstore >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.calendar >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.handbook >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.health >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.mitv.alarmcenter >/dev/null 2>&1
    
    adb shell pm disable-user --user 0 com.xiaomi.wakeupservice >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.screenrecorder >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.sohu.inputmethod.sogou.tv >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.karaoke.service >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.tvpush.tvpushservice >/dev/null 2>&1

    echo -e "${CYAN}[35%]${RESET} 📦 ${GREEN}Đang cài đặt các gói ứng dụng...${RESET}"
    local apks_to_install="keyboard.apk katniss_2.2.0.apk file.apk allapp.apk youtobe.apk storetv.apk mitv.apk getout.apk phim4k.apk"
    for apk in $apks_to_install; do
        install_apk "$apk"
    done

    backup_picture

    echo -e "${CYAN}[80%]${RESET} 🔑 ${GREEN}Đang cấp quyền truy cập bộ nhớ và ghi cài đặt bảo mật...${RESET}"
    adb shell appops set com.spocky.projengmenu REQUEST_INSTALL_PACKAGES allow >/dev/null 2>&1
    adb shell appops set com.spocky.projengmenu WRITE_SETTINGS allow >/dev/null 2>&1
    adb shell appops set com.spocky.projengmenu MANAGE_EXTERNAL_STORAGE allow >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.READ_EXTERNAL_STORAGE >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.WRITE_EXTERNAL_STORAGE >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.READ_MEDIA_IMAGES >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.READ_MEDIA_VIDEO >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.READ_MEDIA_AUDIO >/dev/null 2>&1
    adb shell am force-stop com.spocky.projengmenu >/dev/null 2>&1
    adb shell cmd package clear-app-profiles com.mitv.tvhome >/dev/null 2>&1

    echo -e "${CYAN}[90%]${RESET} ⚡ ${GREEN}Đang kích hoạt dịch vụ bàn phím và biên dịch tăng tốc ứng dụng...${RESET}"
    adb shell pm grant com.mitv.shareds android.permission.WRITE_SECURE_SETTINGS >/dev/null 2>&1
    adb shell pm grant com.mitv.shareds android.permission.CHANGE_CONFIGURATION >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.WRITE_SECURE_SETTINGS >/dev/null 2>&1
    adb shell appops set com.google.android.katniss SYSTEM_ALERT_WINDOW allow >/dev/null 2>&1
    adb shell cmd appops set com.spocky.projengmenu WRITE_EXTERNAL_STORAGE allow >/dev/null 2>&1
    adb shell cmd appops set com.spocky.projengmenu READ_EXTERNAL_STORAGE allow >/dev/null 2>&1
    adb shell ime enable com.liskovsoft.leankeyboard/.ime.LeanbackImeService >/dev/null 2>&1

    echo -e "${CYAN}[95%]${RESET} 🔒 ${GREEN}Đang cố định launcher mặc định và đồng bộ bộ nhớ đệm...${RESET}"
    adb shell settings put secure default_input_method com.liskovsoft.leankeyboard/.ime.LeanbackImeService >/dev/null 2>&1
    adb shell settings put secure enabled_accessibility_services com.mitv.shareds/com.mitv.shareds.HomeService >/dev/null 2>&1
    adb shell settings put secure accessibility_enabled 1 >/dev/null 2>&1
    adb shell cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1
    adb shell cmd package compile -m speed -f com.spocky.projectivylauncher >/dev/null 2>&1
    adb shell cmd package compile -m speed -f com.spocky.projengmenu >/dev/null 2>&1
    adb shell settings put global install_non_market_apps 1 >/dev/null 2>&1
    adb shell settings list secure >/dev/null 2>&1
    adb shell sync >/dev/null 2>&1

    sleep 2
    echo -e "${YELLOW}🔄 Đang gửi lệnh khởi động lại TV...${RESET}"
    adb reboot >/dev/null 2>&1 &
    
    PID=$!
    sleep 1
    kill $PID >/dev/null 2>&1

    echo
    echo -e "${GREEN}===========================================================${RESET}"
    echo -e "${YELLOW}      🎉 QUÁ TRÌNH CÀI ĐẶT HOÀN TẤT THÀNH CÔNG ! 🎉      ${RESET}"
    echo -e "${GREEN}===========================================================${RESET}"
    sleep 2
    menu1
}


install_projectivy14() {
    print_header
    echo -e "${GREEN}===========================================================${RESET}"
    echo -e "${YELLOW}    BẮT ĐẦU QUÁ TRÌNH VIỆT HÓA VÀ TỐI ƯU HỆ THỐNG TV...    ${RESET}"
    echo -e "${GREEN}===========================================================${RESET}"
    echo

    echo -e "${CYAN}[10%]${RESET} ⚙️  ${GREEN}Đang cấu hình múi giờ, ngôn ngữ và tối ưu hiệu ứng hệ thống...${RESET}"
    adb shell service call alarm 3 s16 Asia/Bangkok >/dev/null 2>&1
    adb shell settings put global device_locales vi-VN >/dev/null 2>&1
    adb shell settings put global sys_locale vi-VN >/dev/null 2>&1
    adb shell settings put system system_locales vi-VN >/dev/null 2>&1
    adb shell settings put global heads_up_notifications_enabled 0 >/dev/null 2>&1
    adb shell settings put global stay_on_while_plugged_in 3 >/dev/null 2>&1
    adb shell settings put global window_animation_scale 0.5 >/dev/null 2>&1
    adb shell settings put global transition_animation_scale 0.5 >/dev/null 2>&1
    adb shell settings put global animator_duration_scale 0.5 >/dev/null 2>&1
    adb shell appops set com.xiaomi.voicecontrol SYSTEM_ALERT_WINDOW deny >/dev/null 2>&1

    echo -e "${CYAN}[25%]${RESET} 📦 Đang cài đặt ${GREEN}Projectivy Launcher${RESET} cho Android ${WHITE}14${RESET}..."
    install_apk "p.apk"

    adb shell monkey -p com.spocky.projengmenu -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
    adb shell am start -n com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1
    adb shell cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1

    echo -e "${CYAN}[30%]${RESET} 🗑️  ${RED}Đang dọn dẹp các dịch vụ quảng cáo China Trung Quốc...${RESET}"
    adb shell pm disable-user --user 0 com.mitv.tvhome >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.tvqs >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.mitv.gallery >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.tv.gallery >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.tweather >/dev/null 2>&1
    
    adb shell pm disable-user --user 0 com.mitv.screensaver >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.hyper.screensaver >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.aod.screensaver >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.shop >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.duokan.videodaily >/dev/null 2>&1
    
    adb shell pm disable-user --user 0 com.mitv.cloudcontrol >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.miui.tv.analytics >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.smarthome.tv >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.voicecontrol >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.upgrade >/dev/null 2>&1
    
    adb shell pm disable-user --user 0 com.xiaomi.mitv.appstore >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.calendar >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.handbook >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.health >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.mitv.alarmcenter >/dev/null 2>&1
    
    adb shell pm disable-user --user 0 com.xiaomi.wakeupservice >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.screenrecorder >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.sohu.inputmethod.sogou.tv >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.karaoke.service >/dev/null 2>&1
    adb shell pm disable-user --user 0 com.xiaomi.mitv.tvpush.tvpushservice >/dev/null 2>&1

    echo -e "${CYAN}[35%]${RESET} 📦 ${GREEN}Đang cài đặt các gói ứng dụng...${RESET}"
    local apks_to_install="keyboard.apk katniss_2.2.0.apk file.apk allapp.apk youtobe.apk storetv.apk mitv.apk getout.apk phim4k.apk"
    for apk in $apks_to_install; do
        install_apk "$apk"
    done

    backup_picture

    echo -e "${CYAN}[80%]${RESET} 🔑 ${GREEN}Đang cấp quyền truy cập bộ nhớ và ghi cài đặt bảo mật...${RESET}"
    adb shell appops set com.spocky.projengmenu REQUEST_INSTALL_PACKAGES allow >/dev/null 2>&1
    adb shell appops set com.spocky.projengmenu WRITE_SETTINGS allow >/dev/null 2>&1
    adb shell appops set com.spocky.projengmenu MANAGE_EXTERNAL_STORAGE allow >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.READ_EXTERNAL_STORAGE >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.WRITE_EXTERNAL_STORAGE >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.READ_MEDIA_IMAGES >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.READ_MEDIA_VIDEO >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.READ_MEDIA_AUDIO >/dev/null 2>&1
    adb shell am force-stop com.spocky.projengmenu >/dev/null 2>&1
    adb shell cmd package clear-app-profiles com.mitv.tvhome >/dev/null 2>&1

    echo -e "${CYAN}[90%]${RESET} ⚡ ${GREEN}Đang kích hoạt dịch vụ bàn phím và biên dịch tăng tốc ứng dụng...${RESET}"
    adb shell pm grant com.mitv.shareds android.permission.WRITE_SECURE_SETTINGS >/dev/null 2>&1
    adb shell pm grant com.mitv.shareds android.permission.CHANGE_CONFIGURATION >/dev/null 2>&1
    adb shell pm grant com.spocky.projengmenu android.permission.WRITE_SECURE_SETTINGS >/dev/null 2>&1
    adb shell appops set com.google.android.katniss SYSTEM_ALERT_WINDOW allow >/dev/null 2>&1
    adb shell cmd appops set com.spocky.projengmenu WRITE_EXTERNAL_STORAGE allow >/dev/null 2>&1
    adb shell cmd appops set com.spocky.projengmenu READ_EXTERNAL_STORAGE allow >/dev/null 2>&1
    adb shell ime enable com.liskovsoft.leankeyboard/.ime.LeanbackImeService >/dev/null 2>&1

    echo -e "${CYAN}[95%]${RESET} 🔒 ${GREEN}Đang cố định launcher mặc định và đồng bộ bộ nhớ đệm...${RESET}"
    adb shell settings put secure default_input_method com.liskovsoft.leankeyboard/.ime.LeanbackImeService >/dev/null 2>&1
    adb shell settings put secure enabled_accessibility_services com.mitv.shareds/com.mitv.shareds.HomeService >/dev/null 2>&1
    adb shell settings put secure accessibility_enabled 1 >/dev/null 2>&1
    adb shell cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity >/dev/null 2>&1
    adb shell cmd package compile -m speed -f com.spocky.projectivylauncher >/dev/null 2>&1
    adb shell cmd package compile -m speed -f com.spocky.projengmenu >/dev/null 2>&1
    adb shell settings put global install_non_market_apps 1 >/dev/null 2>&1
    adb shell settings list secure >/dev/null 2>&1
    adb shell sync >/dev/null 2>&1

    sleep 2
    echo -e "${YELLOW}🔄 Đang gửi lệnh khởi động lại TV...${RESET}"
    adb reboot >/dev/null 2>&1 &
    
    PID=$!
    sleep 1
    kill $PID >/dev/null 2>&1

    echo
    echo -e "${GREEN}===========================================================${RESET}"
    echo -e "${YELLOW}      🎉 QUÁ TRÌNH CÀI ĐẶT HOÀN TẤT THÀNH CÔNG ! 🎉      ${RESET}"
    echo -e "${GREEN}===========================================================${RESET}"
    sleep 2
    menu1
}


install_box() {
    print_header
    echo -e "${GREEN}🔧 Bắt đầu cài đặt giao diện cho BOX ANDROID tự động...${RESET}"
    
    install_apk "p.apk"
    
    echo -e "${CYAN}🔄 Đang kích hoạt Launcher và tối ưu hóa hệ thống box...${RESET}"
    for cmd in \
        "settings put global stay_on_while_plugged_in 3" \
        "monkey -p com.spocky.projengmenu -c android.intent.category.LAUNCHER 1" \
        "am start -n com.spocky.projengmenu/.ui.home.MainActivity" \
        "cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity" \
        "settings put global install_non_market_apps 1"
    do
        adb shell "$cmd" >/dev/null 2>&1
    done

    echo -e "${CYAN}🔑 Đang cấp quyền ghi cài đặt bảo mật cho Launcher...${RESET}"
    adb shell appops set com.spocky.projengmenu REQUEST_INSTALL_PACKAGES allow >/dev/null 2>&1
    adb shell appops set com.spocky.projengmenu WRITE_SETTINGS allow >/dev/null 2>&1
    adb shell appops set com.spocky.projengmenu MANAGE_EXTERNAL_STORAGE allow >/dev/null 2>&1

    backup_picture

    adb shell sync >/dev/null 2>&1

    echo -e "${GREEN}✅ Đã xử lý hoàn tất cấu hình BOX ANDROID.${RESET}"
    sleep 3
    menu2
}

install_googletv() {
    print_header
    echo -e "${GREEN}🔧 Bắt đầu cài đặt tất cả các file .apk tự động...${RESET}"
    local count=0
    
    for file in "$SOURCE_DIR"/*.apk; do
        if [ -f "$file" ]; then
            local apk_name=$(basename "$file")
            install_apk "$apk_name"
            count=$((count + 1))
        fi
    done
    
    if [ "$count" -eq 0 ]; then
        echo -e "    ${YELLOW}⚠️  Không tìm thấy file .apk nào trong thư mục $SOURCE_DIR.${RESET}"
        sleep 3
        return
    fi

    echo -e "${CYAN}🔄 Đang kích hoạt Launcher và tối ưu hóa hệ thống TV...${RESET}"
    for cmd in \
        "settings put global stay_on_while_plugged_in 3" \
        "monkey -p com.spocky.projengmenu -c android.intent.category.LAUNCHER 1" \
        "am start -n com.spocky.projengmenu/.ui.home.MainActivity" \
        "cmd package set-home-activity com.spocky.projengmenu/.ui.home.MainActivity"
    do
        adb shell "$cmd" >/dev/null 2>&1
    done

    backup_picture

    echo -e "${GREEN}✅ Đã xử lý hoàn tất toàn bộ $count file .apk và cấu hình hệ thống.${RESET}"
    sleep 3
    menu2
}


allappxiaomi() {
    echo -e "${GREEN}📦 Bắt đầu cài app lên TV...${RESET}"
    echo -e "${CYAN}[35%]${RESET} 📦 ${GREEN}Đang cài đặt các gói ứng dụng...${RESET}"
    local apks_to_install="allapp.apk youtobe.apk storetv.apk mitv.apk getout.apk phim4k.apk"
    for apk in $apks_to_install; do
        install_apk "$apk"
    done
    echo -e "${GREEN}✅ Đã xử lý hoàn tất toàn bộ app hệ thống.${RESET}"
    sleep 3
    menu2
}



backup_picture() {
    echo -e "${GREEN}📦 Bắt đầu đồng bộ ảnh và file cấu hình lên TV...${RESET}"
    local count_img=0
    local count_bak=0
    
    for file in *; do
        [ -f "$file" ] || continue
        case "$file" in
            *.jpg|*.jpeg|*.png|*.JPG|*.JPEG|*.PNG)
                echo -e "    ${CYAN}-> Đang tải ảnh: $file...${RESET}"
                adb push "$file" "/sdcard/DCIM/$file" >/dev/null 2>&1
                count_img=$((count_img + 1))
                ;;
            *.plbackup)
                echo -e "    ${CYAN}-> Đang tải cấu hình: $file...${RESET}"
                adb push "$file" "/sdcard/Download/$file" >/dev/null 2>&1
                count_bak=$((count_bak + 1))
                ;;
        esac
    done
    
    if [ $count_img -eq 0 ] && [ $count_bak -eq 0 ]; then
        echo -e "    ${YELLOW}⚠️  Không tìm thấy bất kỳ file ảnh hoặc cấu hình (.plbackup) nào.${RESET}"
    else
        [ $count_img -gt 0 ] && echo -e "${GREEN}✅ Đã tải thành công $count_img ảnh gốc vào /sdcard/DCIM/${RESET}"
        [ $count_bak -gt 0 ] && echo -e "${GREEN}✅ Đã tải thành công $count_bak cấu hình gốc vào /sdcard/Download/${RESET}"
    fi
    sleep 3
}

reboot_tv() {
    local mode="$1"
    print_header
    echo -e "${CYAN}→ Khởi động lại TV ($mode)...${RESET}"
    if [ "$mode" = "recovery" ]; then
        adb reboot recovery >/dev/null 2>&1 &
    else
        adb reboot >/dev/null 2>&1 &
    fi
    echo -e "  ${GREEN}✓ Đã gửi lệnh reboot (không chờ phản hồi)${RESET}"
    sleep 1
    echo -e "${YELLOW}→ Đang ngắt kết nối ADB...${RESET}"
    adb disconnect >/dev/null 2>&1
    echo -e "${CYAN}→ Chờ TV khởi động lại (Vui lòng đợi trong giây lát)...${RESET}"
    sleep 35

    echo -e "${GREEN}→ Quay về Menu kết nối...${RESET}"
    sleep 1
    menu1
}

# =================== START ===================
menu1