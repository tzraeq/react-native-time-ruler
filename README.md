# react-native-scroll-ruler
ReactNative版时间,兼容Android和iOS。

## Gifs
![](https://github.com/shenhuniurou/react-native-scroll-ruler/blob/master/scroll-ruler-ios.gif)
![](https://github.com/shenhuniurou/react-native-scroll-ruler/blob/master/scroll-ruler-android.gif)

##  Get Started

### Installation

Step 1:

`npm i react-native-time-ruler --save`

or 

`yarn add react-native-time-ruler`

Step 2:

`react-native link react-native-time-ruler`

That's all!

### Usage

#### Simple

```javascript
import RNScrollRuler from 'react-native-time-ruler';

<RNTimeRuler 
	style={{width: Util.size.width - 20, height: 100, backgroundColor: '#fff'}}
   	ref={(view) => {
   	}}
   	minValue={30}
   	maxValue={180}
   	step={1}
   	num={10}
   	unit={"kg"}
   	defaultValue={this.state.defaultWeight}
   	onSelect={(value) => {
    	this.setState({weight: value});
   	}}
></RNTimeRuler>


<RNTimeRuler 
	style={{width: Util.size.width - 20, height: 100, backgroundColor: '#fff'}}
   	ref={(view) => {
   	}}
   	minValue={120}
   	maxValue={250}
   	step={1}
   	num={10}
   	unit={"cm"}
   	defaultValue={this.state.defaultHeight}
   	onSelect={(value) => {
    	this.setState({height: value});
   	}}
></RNTimeRuler>
```

#### Props

|Prop|Description|Type|Required|
|:---|:----|:---|:---|
|minValue|尺子显示的最小值|number|Y|
|maxValue|尺子显示的最大值|number|Y|
|defaultValue|尺子默认值|number|Y|
|step|两个大刻度之间的数值间隔|number|Y|
|num|两个小刻度之间的数值间隔|number|Y|
|unit|单位|string|N|

#### Methods

|Method|Description|
|:---|:----|
|onSelect|选中值后的回调方法|




#### License

[MIT](https://github.com/tzraeq/react-native-time-ruler/blob/master/LICENSE)
