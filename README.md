# 糖糖
基于 chartgpt-on-wechat 微调做的项目。
增加了百度文心一言的人设描述字段(baidu_wenxin_character_desc)。

## 二、如何配置百度文心一言

**安装核心依赖 (必选)：**
> 能够使用`itchat`创建机器人，并具有文字交流功能所需的最小依赖集合。
```bash
pip3 install -r requirements.txt
```

**拓展依赖 (可选，建议安装)：**

```bash
pip3 install -r requirements-optional.txt
```
> 如果某项依赖安装失败可注释掉对应的行再继续

** 配置文件 **
配置文件的模板在根目录的`config-template.json`中，需复制该模板创建最终生效的 `config.json` 文件：

```bash
  cp config-template.json config.json
```

在config.json 中配置下面几个字段即可
```
  "model": "wenxin-4",
  "baidu_wenxin_model": "",
  "baidu_wenxin_api_key": "",
  "baidu_wenxin_secret_key": "",
  "baidu_wenxin_character_desc": "你叫糖糖，是一二和布布的女儿。一二是你的妈妈，布布是你的爸爸。你们一家人都是熊，你们的家叫做熊熊家。你妈妈和爸爸都喜欢玩小红书。一二喜欢看各种淘宝直播买衣服，喜欢拍照。布布则喜欢给一二拍照。"
```

⚠️注意，其中，

建议使用baidu_wenxin_model来配置模型名称，model 随便填 wenxin 或者 wenxin-4都可以，最终生效的会是baidu_wenxin_model的值。

`baidu_wenxin_model` 需要配置的是你要调用的模型的真实名称。

可以去 [文心一言API](https://cloud.baidu.com/doc/WENXINWORKSHOP/s/plx2p4w8z#%E8%AF%B7%E6%B1%82%E8%AF%B4%E6%98%8E) 查一下你要使用的模型真实名称。

进去以后，点击到你要使用的模型的 API 文档页，搜索一下 "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat"

比如我用的是ERNIE-4.0-8K-Latest模型，去对应页面（文档中心 > 千帆大模型平台 > 推理服务API > 对话Chat > ERNIE 4.0 > ERNIE-4.0-8K-Latest）搜索后，搜到了 "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/ernie-4.0-8k-latest?access_token"，

这个"ernie-4.0-8k-latest" 就是模型的真实名称。


## 三、运行

### 1.本地运行

如果是开发机 **本地运行**，直接在项目根目录下执行：

```bash
python3 app.py                                    # windows环境下该命令通常为 python app.py
```

终端输出二维码后，进行扫码登录，当输出 "Start auto replying" 时表示自动回复程序已经成功运行了（注意：用于登录的账号需要在支付处已完成实名认证）。扫码登录后你的账号就成为机器人了，可以在手机端通过配置的关键词触发自动回复 (任意好友发送消息给你，或是自己发消息给好友)，参考[#142](https://github.com/zhayujie/chatgpt-on-wechat/issues/142)。

### 2.服务器部署

使用nohup命令在后台运行程序：

```bash
nohup python3 app.py & tail -f nohup.out          # 在后台运行程序并通过日志输出二维码
```
扫码登录后程序即可运行于服务器后台，此时可通过 `ctrl+c` 关闭日志，不会影响后台程序的运行。使用 `ps -ef | grep app.py | grep -v grep` 命令可查看运行于后台的进程，如果想要重新启动程序可以先 `kill` 掉对应的进程。日志关闭后如果想要再次打开只需输入 `tail -f nohup.out`。此外，`scripts` 目录下有一键运行、关闭程序的脚本供使用。

> **多账号支持：** 将项目复制多份，分别启动程序，用不同账号扫码登录即可实现同时运行。

> **特殊指令：** 用户向机器人发送 **#reset** 即可清空该用户的上下文记忆。


### 3.Docker部署

> 使用docker部署无需下载源码和安装依赖，只需要获取 docker-compose.yml 配置文件并启动容器即可。

> 前提是需要安装好 `docker` 及 `docker-compose`，安装成功的表现是执行 `docker -v` 和 `docker-compose version` (或 docker compose version) 可以查看到版本号，可前往 [docker官网](https://docs.docker.com/engine/install/) 进行下载。

**(1) 下载 docker-compose.yml 文件**

```bash
wget https://open-1317903499.cos.ap-guangzhou.myqcloud.com/docker-compose.yml
```

下载完成后打开 `docker-compose.yml` 修改所需配置，如 `OPEN_AI_API_KEY` 和 `GROUP_NAME_WHITE_LIST` 等。

**(2) 启动容器**

在 `docker-compose.yml` 所在目录下执行以下命令启动容器：

```bash
sudo docker compose up -d
```

运行 `sudo docker ps` 能查看到 NAMES 为 chatgpt-on-wechat 的容器即表示运行成功。

注意：

 - 如果 `docker-compose` 是 1.X 版本 则需要执行 `sudo  docker-compose up -d` 来启动容器
 - 该命令会自动去 [docker hub](https://hub.docker.com/r/zhayujie/chatgpt-on-wechat) 拉取 latest 版本的镜像，latest 镜像会在每次项目 release 新的版本时生成

最后运行以下命令可查看容器运行日志，扫描日志中的二维码即可完成登录：

```bash
sudo docker logs -f chatgpt-on-wechat
```

**(3) 插件使用**

如果需要在docker容器中修改插件配置，可通过挂载的方式完成，将 [插件配置文件](https://github.com/zhayujie/chatgpt-on-wechat/blob/master/plugins/config.json.template)
重命名为 `config.json`，放置于 `docker-compose.yml` 相同目录下，并在 `docker-compose.yml` 中的 `chatgpt-on-wechat` 部分下添加 `volumes` 映射:

```
volumes:
  - ./config.json:/app/plugins/config.json
```

### 4. Railway部署

> Railway 每月提供5刀和最多500小时的免费额度。 (07.11更新: 目前大部分账号已无法免费部署)

1. 进入 [Railway](https://railway.app/template/qApznZ?referralCode=RC3znh)
2. 点击 `Deploy Now` 按钮。
3. 设置环境变量来重载程序运行的参数，例如`open_ai_api_key`, `character_desc`。

**一键部署:**
  
  [![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/qApznZ?referralCode=RC3znh)

<br>