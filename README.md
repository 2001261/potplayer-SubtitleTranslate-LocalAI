# potplayer-SubtitleTranslate-LocalAI

PotPlayer本地AI字幕翻译插件

## 功能特点

- 实时翻译 PotPlayer 播放的视频字幕
- 支持多种语言之间的互译
- 使用本地部署的 AI 模型，保护用户隐私
- 专业的翻译提示词，提高翻译质量

## 安装要求

- PotPlayer 1.7.21505 或更高版本
- 本地部署的 AI 服务（如 LocalAI、Ollama 等）
- 支持的 AI 模型（如 qwen3-4b-instruct 等）

## 安装步骤

1. 确保已安装并运行本地 AI 服务
2. 将 `SubtitleTranslate - LocalAI.as` 文件复制到 PotPlayer 的插件目录：
   - 通常位于 `C:\Program Files\DAUM\PotPlayer\Extensions\Subtitle`
   - 或者 PotPlayer 安装目录下的相应文件夹
3. 重新启动 PotPlayer
4. 在 PotPlayer 中启用插件：
   - 打开 PotPlayer 设置
   - 转到 "字幕" -> "翻译"
   - 选择 "Local AI translate" 作为翻译引擎

## 配置说明

在首次使用插件时，需要配置以下参数：

1. **Model Name**: AI 模型名称（例如：qwen3-4b-instruct-2507）
2. **API URL**: 本地 AI 服务的 API 地址（例如：http://localhost:12340/v1/chat/completions）
3. **API Key**: 如果本地 AI 服务需要认证，请输入相应的 API 密钥

## 使用方法

1. 在 PotPlayer 中打开带有字幕的视频文件
2. 确保字幕已启用并显示
3. 在字幕设置中选择目标语言进行翻译
4. 字幕将实时翻译并显示在视频上

## 翻译效果示例

### 英语翻译示例

![英语翻译示例1](example_images/English/0w4mqywc.glb.png)
![英语翻译示例2](example_images/English/f2qxeovr.jyc.png)
![英语翻译示例3](example_images/English/n1jjlf5t.kdr.png)
![英语翻译示例4](example_images/English/tvc4mkzb.5az.png)

### 日语翻译示例

#### 千与千寻

![千与千寻翻译示例1](example_images/Japanese/Spirited_Away/swvqzfe4.lvr.png)
![千与千寻翻译示例2](example_images/Japanese/Spirited_Away/2.png)

#### Legal High

![Legal High翻译示例1](example_images/Japanese/Legal_High/00tfd21v.vxk.png)
![Legal High翻译示例2](example_images/Japanese/Legal_High/0s2kfzjt.5ga.png)

### 韩语翻译示例

![韩语翻译示例](example_images/Korean/wwagqs2y.qvd.png)

## 支持的语言

插件支持多种语言的翻译，包括但不限于：

- 中文 (zh-CN, zh-TW)
- 英语 (en)
- 日语 (ja)
- 韩语 (ko)
- 法语 (fr)
- 德语 (de)
- 西班牙语 (es)
- 俄语 (ru)
- 阿拉伯语 (ar)
- 等等...

## 技术细节

### 翻译提示词

插件使用专业的翻译提示词来指导 AI 模型：

```
You are a professional translator. Please translate the following text accurately while preserving the original meaning, tone, and context. Ensure the translation is natural and fluent in the target language.
```

### API 请求格式

插件向本地 AI 服务发送的请求格式如下：

```json
{
  "model": "模型名称",
  "messages": [
    {
      "role": "system",
      "content": "专业翻译提示词"
    },
    {
      "role": "user",
      "content": "翻译请求：Translate from [源语言] to [目标语言]: [文本]"
    }
  ],
  "temperature": 0.5
}
```

## 故障排除

### 常见问题

1. **插件无法加载**
   
   - 确认插件文件放置在正确的目录中
   - 检查 PotPlayer 版本是否符合要求

2. **翻译功能无响应**
   
   - 检查本地 AI 服务是否正在运行
   - 验证 API URL 和模型名称是否正确
   - 确认网络连接正常

3. **翻译质量不佳**
   
   - 尝试更换其他 AI 模型
   - 检查本地 AI 服务的资源配置
   - 确认模型支持所选语言

### 日志查看

如果遇到问题，可以查看 PotPlayer 的日志文件以获取更多信息：

- 日志通常位于 PotPlayer 安装目录或用户配置目录中

## 更新日志

### v1.1

- 添加了专业的翻译提示词，提高翻译质量
- 优化了与本地 AI 服务的通信
- 修复了 JSON 请求格式问题
- 改进了错误处理机制

### v1.0

- 初始版本发布
- 基本的字幕翻译功能
- 支持多种语言

## 模型和API端点

本插件默认配置使用以下模型和API端点：

- 默认模型：`qwen3-4b-instruct-2507`
- 默认API端点：`http://localhost:12340/v1/chat/completions`

使用者可以根据自己搭建的AI模型情况自行更改模型名称和API端点地址。

## 致谢

感谢 [Felix3322/PotPlayer_ChatGPT_Translate](https://github.com/Felix3322/PotPlayer_ChatGPT_Translate) 项目的作者，本插件参考了该项目的源代码实现。

## 许可证

本项目基于 MIT 许可证发布。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个插件。

## 联系方式

如有问题或建议，请通过以下方式联系：

- 提交 GitHub Issue
