#!/bin/bash
# quick screen capture with "spectacle"

# dependencies (archlinux packages name):
# spectacle
# zbar
# wl-clipboard

# configs
Capture_Mode="--region"
# 此处扩展名必须有效或者干脆没有听配置文件的，不然写不进去(尝试过 .imge~)(我知道拼错了，就当个笑话放这里吧)
TempFile_Path="/tmp/quick-QR-bash-TEMP"
# 发通知时的应用名称
App_Name="quickParse-QR"

# 执行前删除可能的临时文件，也是因为要检测是否截图了
rm -vf "$TempFile_Path"

# 启动截图，保存至临时文件夹 [--后台 --无通知 --自定义输出路径]
spectacle "$Capture_Mode" --background --nonotify --output "$TempFile_Path"
# 如果没有截图则退出(道理我都懂，但为什么没截图退出码还是 0 为什么啊啊啊w)
[[ -f "$TempFile_Path" ]] || exit 0

# 解析原始信息到 $Parsed_Code [--输出原始信息]
Parsed_Code=$(zbarimg --raw "$TempFile_Path")
# 如果没检测到信息则退出
if [ $? != 0 ]; then
    # 发信息提醒
    notify-send --app-name="$App_Name" "There's no QRcode in image"
    # 清理临时文件，并退出
    rm -vf "$TempFile_Path"
    exit 0
fi
# 终端输出解析后的信息
echo "$Parsed_Code"

# 发送带有复制按钮的通知 [--应用名称:显示在顶栏上的信息 --控件:返回信息=显示名称 --通知信息]
Notify_Action=$(notify-send --app-name="$App_Name" --action _copy=Copy --action _xdg-open=Open "$Parsed_Code")
# 实现通知提示的动作
case $Notify_Action in
# 复制以解析的信息
_copy)
    # 检测正在使用的桌面gui程序，并选择对应的剪贴板工具
    case $XDG_SESSION_TYPE in
    wayland)
        # wl-clipboard 是一个wayland下的剪贴板工具集
        wl-copy "$Parsed_Code"
    ;;
    x11)
        # 那这个就是老古董x11的喽
        # xclip 的实现
        echo "$Parsed_Code" | xclip -selection c
        # xsel 的实现
        # echo "$Parsed_Code" | xsel -ib
    ;;
    esac
;;
_xdg-open)
    # 调用 xdg-open 打开内容，至于打不打开的谁知道呢
    xdg-open "$Parsed_Code"
;;
esac
# 清理临时文件，并退出
rm -vf "$TempFile_Path"
exit 0
