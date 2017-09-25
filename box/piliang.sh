#!/bin/bash

export LC_CTYPE=en_US.UTF-8

loged () {
	logs="$1"
	DT=$(date +"%Y%m%d %H:%M:%S")
 	echo "$DT:  $logs" >>~/vfm/box/log
}
loged "开始批量任务"
N=$(awk 'END{print NR}' ~/vfm/box/you-getlist)
I=1
echo ''>~/vfm/box/l.ls
echo ''>~/vfm/box/log.log
if [[ $N -gt 0 ]]; then
	cat ~/vfm/box/you-getlist | while read lss
	do
			loged "发现第$I下载URL"
			you-get -i $lss >>~/vfm/box/l.ls
			cat ~/vfm/box/l.ls | grep -e url | sed "s/title:/\ /g" | sed "s/[[:space:]]//g"
			NAME=$(cat ~/vfm/box/l.ls | grep -e url | sed "s/title:/\ /g" | sed "s/[[:space:]]//g")
			cat ~/vfm/box/l.ls | grep -e url | sed "s/url:/\ /g" | sed "s/[[:space:]]//g" > ~/vfm/box/List.txt
			#--format=hd2 是优酷下载 720p 的参数
			L=$(awk 'END{print NR}' ~/vfm/box/List.txt)

			if [[ $L -gt 0 ]] ; then
				cat List.txt | while read line
				do
				    loged "开始第$line下载项$NAME"
				    loged "you-get -o ~/vfm/box/youtube/ $1 $line"
					you-get -o ~/vfm/box/youtube/ $1 "$line" >>~/vfm/box/log.log
					loged "$NAME下载完成"
					echo "$line" >>~/vfm/box/downed.ls
					sed -i '/$line/d' ~/vfm/box/you-getlist
				done
			else
			 	loged "开始下载$NAME项$lss"
			 	loged "you-get $lss >>~/vfm/box/l.ls"
				you-get -o ~/vfm/box/youtube/ $lss >>~/vfm/box/log.log
				loged "$NAME下载完成"
				echo "$line" >>~/vfm/box/downed.ls
				sed -i '/$line/d' ~/vfm/box/you-getlist
			fi
		let I=$I+1
	done
	echo ''>~/vfm/box/you-getlist
else
	loged "无下载任务！"
fi
