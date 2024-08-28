#!/bin/bash

API_BASE="https://img.bawcat.wiki/copilot/bin/base/"

echo "1. 激活jetbrain系列/Android Studio"
echo "2. 恢复jetbrain系列/Android Studio"
echo "3. 退出"

# 读取用户输入
read -p "请选择: " choice

crackjetbrain() {
	filepath="$1"
	if [ ! -f "/tmp/$exe_src" ]; then
		echo "正在加载激活插件, 请稍等..."
		wget $API_BASE/$exe_src -O /tmp/$exe_src
	fi
	if [ ! -f "/tmp/$exe_src" ]; then
		echo "激活插件下载失败"
		return
	fi
	# 备份原copilot 客户端
	cp "$filepath" "$filepath.bak"
	cp /tmp/$exe_src "$filepath"
	if [ $? -eq 0 ]; then
		echo "$filepath 激活成功"
	else
		echo "$filepath 激活失败"
	fi
}

recoveryjetbrain() {
	filepath="$1"
	if [ ! -f "$filepath.bak" ]; then
		echo "原始备份客户端不存在，如果异常请删除编辑器插件后重新安装！！"
		return
	fi

	cp "$filepath.bak" "$filepath"
	rm "$filepath.bak"
	if [ $? -eq 0 ]; then
		echo "$filepath 恢复完毕"
	else
		echo "$filepath 恢复失败 请删除编辑器插件后重新安装！！"
	fi	
}

exe_src=copilot-agent-linux
exe_dst=copilot-agent-linux
# 如果是macos
if [ "$(uname)" == "Darwin" ]; then
	exe_src=copilot-agent-macos
	exe_dst=copilot-agent-macos
	# 如果是m1芯片
	if [ "$(uname -m)" == "arm64" ]; then
		exe_dst=copilot-agent-macos-arm64
	fi
fi

case $choice in
	1)
		# 如果 find_dir 为空,则请用户输入
		if [ -z "$find_dir" ]; then
			default_dir=$HOME/.local/share/JetBrains
			if [ "$(uname)" == "Darwin" ]; then
				echo ""
				echo "常见路径: "
				echo "JetBrains系列: $HOME/Library/Application Support/JetBrains"
				echo "Android Studio: $HOME/Library/Application Support/Google"
				echo ""
				echo "可以启动编辑器 ps -ef | grep $exe_dst 查找所在路径路径"
				echo ""
				default_dir="$HOME/Library/Application Support/JetBrains"
			else
				echo ""
				echo "常见路径: "
				echo "JetBrains系列: $HOME/.local/share/JetBrains"
				echo "Android Studio: $HOME/.local/share/Google"
				echo ""
				echo "可以启动编辑器 ps -ef | grep $exe_dst 查找所在路径路径"
				echo ""
			fi
			read -p "请输入$exe_dst 所在目录,默认为$default_dir:" find_dir
		fi
		find_dir=${find_dir:-$default_dir}
		if [ ! -d "$find_dir" ]; then
			echo "文件夹 $find_dir 不存在"
			exit 1
		fi
		IFS=$'\n'
		for file in $(find "$find_dir" -type f -name "$exe_dst"); do
			crackjetbrain "$file"
		done
		unset IFS
		rm -f /tmp/$exe_src
		;;
	2)
		# 如果 find_dir 为空,则请用户输入
		if [ -z "$find_dir" ]; then
			default_dir=$HOME/.local/share/JetBrains
			if [ "$(uname)" == "Darwin" ]; then
				echo ""
				echo "常见路径: "
				echo "JetBrains系列: $HOME/Library/Application Support/JetBrains"
				echo "Android Studio: $HOME/Library/Application Support/Google"
				echo ""
				echo "可以启动编辑器 ps -ef | grep $exe_dst 查找所在路径路径"
				echo ""
				default_dir="$HOME/Library/Application Support/JetBrains"
			else
				echo ""
				echo "常见路径: "
				echo "JetBrains系列: $HOME/.local/share/JetBrains"
				echo "Android Studio: $HOME/.local/share/Google"
				echo ""
				echo "可以启动编辑器 ps -ef | grep $exe_dst 查找所在路径路径"
				echo ""
			fi
			read -p "请输入$exe_dst 所在目录,默认为$default_dir:" find_dir
		fi
		find_dir=${find_dir:-$default_dir}
		if [ ! -d "$find_dir" ]; then
			echo "文件夹 $find_dir 不存在"
			exit 1
		fi
		IFS=$'\n'
		for file in $(find "$find_dir" -type f -name "$exe_dst"); do
			recoveryjetbrain "$file"
		done
		unset IFS
		rm -f /tmp/$exe_src
		;;
	3)
		exit 0
		;;
	*)
		echo "无效输入"
		exit 1
		;;
esac
