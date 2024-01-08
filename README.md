# quickParse-QR-bash

一个快速解析QR码的脚本\
依赖 (均为 archlinux 软件包名称):

```text
spectacle
zbar
wl-clipboard [仅 wayland]
xclip [仅 x11]
```

## 简介

快速**截屏**并**查找**屏幕上的二维码，解析后用通知输出\
没有任何可能不符合你审美的gui干扰心情
> 支持 wayland 与 x11\
> x11 模式并没有经过验证，但应该没什么事情

## 使用

运行 `parse-QR.sh` 即可，建议绑定个快捷键

执行后会通知一次解析结果 (有复制按钮)\
如果识别错误也会发通知提醒
> 逻辑中有还算充足的保护代码，因该不会有错误了还在执行的毛病

## 怪问题

emm 如果`kde plasma`下不能用复制功能的话要不试试更新下桌面环境\
这些是折腾记录: [[SOLVED] "wl-copy" con't write to the clipboard in script with plasma](https://bbs.archlinux.org/viewtopic.php?pid=2142027)

## 实现方式

### 1.截图

用 `spectacle` 的命令行参数获取屏幕截图
> 默认:`--region`(矩形选区)

### 2.识别

这一部分用了`zbarimg`命令获取输出

### 3.输出方式

解析后的信息通过桌面通知发送出来

### 4.最后

整个过程出现的 `临时文件` 的默认位置是 `/tmp/quick-QR-bash-TEMP`\
脚本逻辑的最后，会在检测确定他们是文件后用 `rm -vf $Path` 删除

## 碎碎念

- 经典环节呵
- 所以为什么是英文提示\
  我想弄多语言但是突然就犯懒了，就当是TODO了
- 你就这么讨厌gui?\
  只是懒得找，而且解析二维码和截图都用一套截屏软件，还是kde的项目不是更靠谱嘛

## 最终测试环境

```text
操作系统： Arch Linux 
KDE Plasma 版本： 5.91.0
KDE 程序框架版本： 5.247.0
Qt 版本： 6.7.0
内核版本： 6.6.10-arch1-1 (64 位)
图形平台： Wayland
```
