foree-tools  
===========
foree-tools 是一个工具合集,主要提供以下一些功能:

####bringup_ssh  
```
简介：查询或者登陆指定机型所在的服务器  
Usage: bringup_ssh [options] [Branch_name]  
Options:  
       -s 查询，不加参数表示如有符合直接登陆  
       Branch_name 分支名称，例如M81-l1_base，通过输入的关键字进行匹配  
```

####frepo
```
Usage: frepo [options]
Options:
       init -b Branch_name 同步指定分支的代码，使用Reference参数
       sync 同步代码，并start到'分支名称+时间戳'命名的分支上
       reference 判断所在project是否是reference形式
```

####relunch
```
Usage: relunch
以上一次编译的target为参数执行lunch操作
```

####fadb
```
Usage: fadb [options]
Options:
       kill <keyword> 查杀adb连接机器上指定关键字的进程
       push <localfile> 推送localfile到目标机型，remote路径自动识别
```

####fkill
```
Usage: fkill <keyword>
查杀pc上指定关键字的进程
```

####fmm
```
Usage: fmm
mm 命令的增强版，执行mm，并安装mm产生的文件到目标机器
```

####ftools
```
Usage: ftools [options]
Options:
       -C 卸载ftools
       -u 更新服务器project列表
       -r 解析服务期project重复程度
```

- TODO
    - fflash功能实现：根据机型以及服务器指定刷机路径  
    - 根据配置文件foree-tools.conf自动配置服务器挂载方法
    - 实现zsh与bash的智能补全
    - fastboot刷机实现，与fflash互补
    - 判断依赖软件是否安装(realpath)
    - 函数文档完善

###使用方法:
`sudo ./install.sh` 安装软件,然后重启终端即可使用以上功能  
`ftools [-a|-u|-C|-r]` 对foree-tools软件的操作，详情参看ftools的使用方法
