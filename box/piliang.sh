#!/bin/bash

export LC_CTYPE=en_US.UTF-8
DDT=$(date +"%Y%m%d %H:%M:%S")
cd  /home/dissipator520/vfm
git pull

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
			echo $lss>>~/vfm/box/log
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
				    mkdir -p $DDT
					you-get -o ~/vfm/box/youtube/$DDT $1 "$line" >>~/vfm/box/log.log
					loged "$NAME下载完成"
					echo "$line" >>box/downed/($DDT).txt
					git add box/downed/($DDT).txt
					sed -i '/$line/d' ~/vfm/box/you-getlist
				done
			else
			 	loged "开始下载$NAME项$lss"
			 	loged "you-get $lss >>~/vfm/box/l.ls"
			 	mkdir -p $DDT
				you-get -o ~/vfm/box/youtube/$DDT $lss >>~/vfm/box/log.log
				loged "$NAME下载完成"
				echo "$line" >>box/downed/$DDT.txt
				git add box/downed/$DDT.txt
				sed -i '/$line/d' ~/vfm/box/you-getlist
			fi
		let I=$I+1
	done
	rm -rf ~/vfm/box/you-getlist
	touch ~/vfm/box/you-getlist
else
	loged "无下载任务！"
fi

cd  /home/dissipator520/vfm

git commit box/you-getlist box/downed/$DDT.txt box/log  -m " $DDT"
git push