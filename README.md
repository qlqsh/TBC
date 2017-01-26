# 我设想的一个双色球项目

用过很多双色球客户端。都很不错。但不是自己想要的。主要是想先把自己的看球方法做成一个程序，不用每次浪费时间选号，麻烦。

我觉得整体大概可以分成4个部分（资讯、选号、统计、小工具）。

目前算是完成了基础程序。离自己想要的还有些差距。

---

## 客户端部分

### 资讯
* 加奖讯息（主要是方便用户）；
* 节假日休市信息（比如：春节放假情况，主要是方便用户）；
* 获奖方面的信息（中奖规则、中奖详情、历史中奖等）；OK
* 中奖后的建议（比如：中奖后的自救手册）；
* 不合理理财的教训等；

### 选号
* 根据（胆号、杀号、和值范围、头号、尾号等）综合条件选号；这部分可以通过“!”，跟统计合起来使用；
* 根据选择的号码，提供热、冷号（中间是选择的号码，周围是个多边形，每个角是冷号、热号）；

### 统计
* 基础统计（红球、蓝球、和值、头、尾、蓝球012等）；OK
* 条件统计（比如：红球15出现后的下1期出号统计等）；OK
* 历史同期（年）；OK
* 走势图（正常走势图、尾号走势图等）；OK

### 小工具集合
* 奖金计算器；OK

---

## 服务器端部分

最好有自己的服务器部分。这样就能最小化网络请求。最小化解析网络，减少出错可能。

1. 数据后台；
2. 简单与用户交流平台（主要是：bug提交、功能建议2项）；
3. 简单网页版显示（简洁风）；