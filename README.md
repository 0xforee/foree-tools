foree-tools  
===========
foree-tools 是一个工具合集,主要提供以下一些功能:

`install.sh` 安装  
`bringup_ssh 机型` 使用ssh登陆指定机型的服务器  
`find_project.sh` 更新所有服务器的project,并在当前目录维护一个可用列表  
`repo_sync` 仅仅同步default.xml中指定的分支代码,并在同步完成之后切换所有库到最新HEAD  
`relunch` 加载android编译环境,并lunch上一次编译的机型  
`update.sh` 更新版本工作区代码到软件配置文件中  
`fadb kill 关键字` 查杀手机上指定关键字所代表的进程  
`fadb push local_file` push local_file 到自动识别的手机指定位置  
`add_color_for_echo 字符串` 为指定的字符串添加颜色  
`yes_or_no` 输出yes/no的判断,yes返回1,no返回0  
`pick_branch.sh` 找出指定的冗余分支  
`fastboot_flash.sh` fastboot方式刷机  

- TODO
    - 自动判断机型,选择不同的刷机方式
    - 指定路径
    - 根据参数指定  

###使用方法:
`./install.sh` 安装软件,然后重启终端即可使用以上功能  
`./update.sh [-a]` 更新代码控制工作区文件到软件配置目录,`-a` 参数可以更新服务器project列表
