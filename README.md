# Tavern Auto Image（自动文生图扩展）

## 一、装扩展（酒馆里贴链接）

把本仓库 URL 粘进酒馆助手/小白x 的「安装扩展程序」即可安装（Git URL，根目录即扩展本体）：

```
https://github.com/skyyy231/tavern-auto-img-extension
```

> 只需要酒馆 1.12.14+；装完扩展右下角出现 ⚡ 按钮，这就是控制台入口。

## 二、装桥（有了桥才能出图）

桥是"发动机"（连 ComfyUI、生成提示词、出图），必须放进酒馆服务端：

1. 从本仓库下载 `bridge/tavern-auto-img-bridge.mjs`（GitHub 页面 → 打开这个文件 → 右侧 Raw / 下载）
2. 把它放到酒馆目录的 **`plugins/`** 文件夹（没有就新建）
3. 打开酒馆根目录 `config.yaml`，找到 `enableServerPlugins: false` 改成 `true`
4. **重启酒馆** → 桥随酒馆自动运行（监听 8645），右下角 ⚡ 打开控制台即可用

> 要求 Node 22+（酒馆本身自带的运行环境）。无需 Python。

## 三、可选配置

桥的配置自动生成在 `data/default-user/tavern-auto-img/config.json`，一般不用动。
填 ComfyUI 地址（默认 `http://127.0.0.1:8188`）、模型目录等都在控制台里操作。

## 常见问题

- **打开控制台提示"无法连接桥接服务"** → 桥没装/没起，检查上面"二、装桥"步骤
- **出图报错"依赖文件缺失"** → 按报错提示把缺的 CLIP/VAE 文件放进 ComfyUI 的 models/text_encoders 或 models/vae
- **模型列表空** → 确认 ComfyUI 已启动且在 8188 端口，点"刷新"即可

完整说明/源码：https://github.com/skyyy231/tavern-auto-img
