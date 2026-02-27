<p align="center">
  <img width="1280" alt="cover" src="https://user-images.githubusercontent.com/2206700/189457799-6327bab0-b085-4421-8640-6a18e395d17d.png">
</p>

<h1 align="center">Dialogic 2</h1>

<p align="center">
  在 Godot 中创建<b>对话</b>、<b>视觉小说 (Visual Novels)</b>、<b>RPG</b>框架，以及<b>管理角色</b>，从而打造属于你的游戏！
</p>

<p align="center">
  <a href="https://discord.gg/DjcDgDaTMe" target="_blank" style="text-decoration:none"><img alt="Discord" src="https://img.shields.io/discord/628713677239091231?logo=discord&labelColor=CFC9C8&color=646FA9"></a>
  <a href="https://godotengine.org/download/" target="_blank" style="text-decoration:none"><img alt="Godot v4.3+" src="https://img.shields.io/badge/Godot-v4.3+-%23478cbf?labelColor=CFC9C8&color=49A9B4" /></a>
  <a href="https://docs.dialogic.pro/introduction.html" target="_blank" style="text-decoration:none"><img alt="Dialogic 2 Documentation" src="https://img.shields.io/badge/documention-online-green?labelColor=CFC9C8&color=6BCD69"></a>
  <a href="https://github.com/dialogic-godot/dialogic/actions/workflows/unit_test.yml" target="_blank style="text-decoration:none"><img alt="GitHub Actions Workflow Status" src="https://img.shields.io/github/actions/workflow/status/dialogic-godot/dialogic/unit_test.yml?labelColor=CFC9C8&color=DBDCB8"></a>
  <a href="https://github.com/dialogic-godot/dialogic/releases"  target="_blank" style="text-decoration:none"><img alt="Latest Dialogic Release" src="https://img.shields.io/github/v/release/dialogic-godot/dialogic?include_prereleases&labelColor=CFC9C8&color=CBA18C"></a>
</p>

## 目录 (Table of Contents)
- [支持版本](#支持版本)
- [安装指南](#安装指南)
- [文档说明](#文档说明)
- [关于测试](#关于测试)
- [人员鸣谢](#人员鸣谢)
- [开源协议](#开源协议)

## 支持版本

Dialogic 2 **至少需要 Godot 4.3 版本**。

[如果你想找适用于 Godot 3.x 的版本 (Dialogic 1.x)，请点击这里。](https://github.com/dialogic-godot/dialogic-1)

## 安装指南
请遵循我们[《快速开始指南》](https://docs.dialogic.pro/getting-started.html#1-installation--activation)（英文）中的安装说明。

Dialogic 附带自动更新程序，因此你可以直接在插件内部安装将来的版本。

## 文档说明
你可以在这里找到 Dialogic 的官方详细文档：[Dialogic 官方文档](https://docs.dialogic.pro/)

我们也提供了 API 类参考手册：[类参考手册 (Class Reference)](https://docs.dialogic.pro/class_index.html)


## 联系我们！
如果你需要帮助或者想要分享你的 Dialogic 项目，可以通过以下途径：

- 在我们的 [Discord](https://discord.gg/DjcDgDaTMe) 频道中提问或报告 Bug。
- 在 [GitHub Issues 页面](https://github.com/dialogic-godot/dialogic/issues) 提交 Bug 和待解决的问题。
- 在 [GitHub Discussions](https://github.com/dialogic-godot/dialogic/discussions) 发起各类讨论提问。

## 关于测试
Dialogic 使用 [单元测试 (Unit Tests)](https://en.wikipedia.org/wiki/Unit_testing) 来确保特定的代码模块按预期生效。这些测试代码在每次 git `push` 和 `pull request` 时都会自动运行。我们用来执行这些测试的框架是 [gdUnit4](https://github.com/MikeSchulze/gdUnit4) ，测试用例保存在 [/Tests/Unit](https://github.com/dialogic-godot/dialogic/tree/main/Tests/Unit) 目录下。我们建议你从 Godot `AssetLib` (`资产库`) 安装 `gdUnit4` 插件，这样你就可以在本地运行和验证这些测试了。

如果想要开始上手，你可以先看看该路径下现有的测试文件，并阅读文档来[编写你的第一个测试](https://mikeschulze.github.io/gdUnit4/first_steps/firstTest/)。

## 与源代码进行交互
在 Dialogic 2 的源代码中，所有**以前缀下划线 (`_`) 开头的方法和变量**均被视为*私有（private）*，例如：`_remove_character()`。

虽然你可以强行调用它们，但它们在后续版本中随时可能会发生行为变化或签名更改，进而导致你的项目代码在切换版本时崩溃。
大多数私有方法是在公共（public）方法内部调用的；如果你需要帮助，请参考我们的官方文档。

**受支持的公共方法和宏变量可以在我们的[类参考手册 (Class Reference)](https://docs.dialogic.pro/class_index.html)中找到。**

在 Alpha 和 Beta 测试阶段，每次发布 Dialogic 新版本时，代码架构都有可能发生变化，以允许我们采取更优秀的设计草案。
如有这些改动，我们将会在更新日志 (Changelogs) 中予以说明，并指导你如何更新自己的代码。


## 人员鸣谢
主要由 [Jowan-Spooner](https://github.com/Jowan-Spooner) 和 [Emilio Coppola](https://github.com/coppolaemilio) 制作。

代码贡献者: [CakeVR](https://github.com/CakeVR), [Exelia](https://github.com/exelia-antonov), [zaknafean](https://github.com/zaknafean), [以及更多大佬！](https://github.com/dialogic-godot/dialogic/graphs/contributors).

特别鸣谢: [Arnaud](https://github.com/arnaudvergnet), [AnidemDex](https://github.com/AnidemDex), [ellogwen](https://github.com/ellogwen), [Tim Krief](https://github.com/timkrief), [Toen](https://twitter.com/ToenAndreMC), Òscar, [Francisco Presencia](https://francisco.io/), [M7mdKady14](https://github.com/M7mdKady14).

### 感谢在 [Patreons](https://www.patreon.com/jowanspooner) 和 Github 上的所有赞助者，是你们让本项目成为可能！

## 开源协议
本项目根据 [MIT 协议 (MIT license)](https://github.com/dialogic-godot/dialogic/blob/main/LICENSE) 条款进行授权。

Dialogic 可能会使用 [Roboto 字体](https://fonts.google.com/specimen/Roboto)，该字体根据 [Apache license, Version 2.0](https://github.com/dialogic-godot/dialogic/tree/main/addons/dialogic/Example%20Assets/Fonts/LICENSE.txt) 授权许可。
