#!/bin/bash
# quick screen capture with "spectacle"

# dependencies (archlinux packages name):
# spectacle
# zbar
# wl-clipboard

# configs
Capture_Mode="--region"
# 此处扩展名必须有效或者干脆没有听配置文件的，不然写不进去(尝试过 .imge~)
TempFile_Path="/tmp/quick-QR-bash-TEMP"
# 发通知时的应用名称
App_Name="quick-QR-bash"

# 启动截图，保存至临时文件夹 [--后台 --无通知 --自定义输出路径]
spectacle $Capture_Mode --background --nonotify --output $TempFile_Path

# 解析原始信息到 $Parsed_Code [--安静输出 --输出原始信息]
Parsed_Code=$(zbarimg --quiet --raw $TempFile_Path)
# 如果没检测到信息则退出
if [ $? != 0 ]; then
    notify-send --app-name=$App_Name "There's no QRcode in imge"
    exit 1
fi

# 发送带有复制按钮的通知 [--应用名称:显示在顶栏上的信息 --控件:返回信息=显示名称 --通知信息]
Notify_Action=$(notify-send --app-name=$App_Name --action Copy=Copy "$Parsed_Code")
# 实现通知提示的动作
case $Notify_Action in
# 复制以解析的信息
Copy)
    # wl-clipboard 是一个wayland下的剪贴板工具
    wl-copy $Parsed_Code
;;
esac

# 如果临时文件存在，就删除图片文件
[[ -f $TempFile_Path ]] || exit 1
rm $TempFile_Path

exit 0
