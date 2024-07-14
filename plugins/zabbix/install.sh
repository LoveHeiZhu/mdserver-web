#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/opt/homebrew/bin
export PATH

# https://www.mongodb.com/try/download/community

# cd /Users/midoks/Desktop/mwdev/server/mdserver-web/plugins/mongodb && /bin/bash install.sh install 7.0
# cd /www/server/mdserver-web/plugins/mongodb && /bin/bash install.sh install 7.0
# cd /www/server/mdserver-web && python3 /www/server/mdserver-web/plugins/mongodb/index.py start



curPath=`pwd`
rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")

install_tmp=${rootPath}/tmp/mw_install.pl
VERSION=$2

sysName=`uname`
echo "use system: ${sysName}"

OSNAME=`bash ${rootPath}/scripts/getos.sh`

if [ "" == "$OSNAME" ];then
	OSNAME=`cat ${rootPath}/data/osname.pl`
fi

if [ "macos" == "$OSNAME" ];then
	echo "不支持Macox"
	exit
fi

if [ -f ${rootPath}/bin/activate ];then
	source ${rootPath}/bin/activate
fi
Install_app()
{
	echo '正在安装脚本文件...'
	mkdir -p $serverPath/source/zabbix
	shell_file=${curPath}/versions/${VERSION}/${OSNAME}.sh

	if [ -f $shell_file ];then
		bash -x $shell_file
	else
		echo '不支持...'
		exit 1
	fi

	if [ "$?" == "0" ];then
		mkdir -p $serverPath/zabbix
		echo "${VERSION}" > $serverPath/zabbix/version.pl

		#初始化 
		cd ${rootPath} && python3 ${rootPath}/plugins/zabbix/index.py start
		cd ${rootPath} && python3 ${rootPath}/plugins/zabbix/index.py initd_install
	fi

	echo 'Zabbix安装完成'
}

Uninstall_app()
{
	rm -rf $serverPath/zabbix
	echo 'Zabbix卸载完成'
}

action=$1
if [ "${1}" == 'install' ];then
	Install_app
else
	Uninstall_app
fi
