#!/usr/bin/env bash
set -eo pipefail

#
# Generate WeChat Version file by `peres` tool
#
#   Product Version:                 3.3.0.115
#     -> 3.3.0.115
#
WECHAT_DIR='/home/user/.wine/drive_c/Program Files/Tencent/WeChat'
WINEARCH=win64 WINEPREFIX=/home/user/.wine64 winecfg
mkdir -p '/home/user/.win64/drive_c/Program Files/'
cp -r -p '/home/user/.wine/drive_c/Program Files/Tencent'  '/home/user/.wine64/drive_c/Program Files/'
peres -v "$WECHAT_DIR"/WeChatWin.dll | grep 'File Version: ' | awk '{print $3}' > /home/VERSION.WeChat
echo 'WeChat VERSION generated:'
cat /home/VERSION.WeChat
