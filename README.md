# 我设想的一个双色球项目

用来很多双色球客户端。都很不错。但不是自己想要的。主要是想先把自己的看球方法做成一个程序，不用每次浪费时间选号，麻烦。

我觉得整体大概可以分成4个部分（资讯、选号、统计、小工具）。

目前算是完成了基础程序。离自己想要的还有些差距。

---

## 客户端部分

### 资讯
* 获奖方面的信息（中奖规则、中奖详情、历史中奖等）；OK
* 中奖后的建议（比如：中奖后的自救手册）；
* 加奖讯息；
* 不合理理财的教训等；

### 选号
* 根据（胆号、杀号、和值范围、头号、尾号等）综合条件选号；这部分可以通过“!”，跟统计合起来使用。

### 统计
* 基础统计（红球、蓝球、和值、头、尾、热门组合等）；
* 条件统计（比如：红球15出现后的下1期出号统计等）；

### 小工具
* 奖金计算器；

---

## 服务器端部分

最好有自己的服务器部分。这样就能最小化网络请求。最小化解析网络，减少出错可能。

1. 数据后台；
2. 简单与用户交流平台（主要是：bug提交、功能建议2项）；
3. 简单网页版显示（简洁风）；