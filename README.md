# Tavern Auto Image —— 酒馆自动文生图（扩展 + 桥）

角色回复 → 提示词工程 → ComfyUI 出图 → 自动发进酒馆。

> 本仓库 = **扩展本体 + 桥 + 安装器**（一键装/卸）。酒馆 1.12.14+ / Node 22+ 即可，无需 Python。

## 一、装扩展（酒馆里贴链接）

酒馆顶部 ⚙ 扩展图标 → **安装扩展** → 粘贴：

```
https://github.com/skyyy231/tavern-auto-img-extension
```

保存后刷新页面，右下角出现 ⚡ 按钮 = 扩展就绪。

## 二、装桥（双击一次，全自动）

安装扩展后，**桥文件 + install.bat 已随仓库下载到扩展目录**。打开：

```
酒馆目录/data/default-user/extensions/tavern-auto-img-extension/install.bat
（若装在全局：酒馆目录/public/scripts/extensions/third-party/tavern-auto-img-extension/install.bat）
```

**双击 install.bat** → 它自动：
1. 向上定位酒馆根目录（在哪双击都行）
2. 从扩展目录里找到桥 → 复制到 `plugins/`
3. 开启 `enableServerPlugins: true`
4. 检测酒馆在运行时：**默认 Y 自动重启整个酒馆**（不是只刷新网页）

完事后刷新酒馆页面 → 控制台红条消失 = 已通车。

> 也支持从 Release 下载一键包：https://github.com/skyyy231/tavern-auto-img/releases （install.bat + 桥 + 教程）

## 三、日常使用

- ⚡ = 控制台：总开关 / 模型 / LoRA / 速度档位 / 提示词规则 / 自定义工作流
- 控制台标题栏：📂 **扩展目录**（一键弹资源管理器到扩展文件夹）、🧹 **卸载桥**（悬停有解释，点击即卸+自动重启）
- 出图失败会：阶段提示 + 失败红框 + 重试 + 「停止任务」急停

## 四、卸载桥

1. 控制台 🧹 一键卸载（推荐），或
2. `install.bat --uninstall`，或
3. 见扩展目录里的 **卸载桥教程.txt**（三种方法+重装说明）

卸载只关"出图引擎"；扩展保留、配置保留；重装 = 再双击 install.bat。

## 五、其它

- 完整包（Python 桥备选 / 文档）：https://github.com/skyyy231/tavern-auto-img
- 换机器：装扩展（链接）→ 双击 install.bat → 完，两个动作
