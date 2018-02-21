
# react-native-unity-bridge

## Getting started

`$ npm install react-native-unity-bridge --save`

### Mostly automatic installation

`$ react-native link react-native-unity-bridge`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-unity-bridge` and add `RNUnityBridge.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNUnityBridge.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNUnityBridgePackage;` to the imports at the top of the file
  - Add `new RNUnityBridgePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-unity-bridge'
  	project(':react-native-unity-bridge').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-unity-bridge/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-unity-bridge')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNUnityBridge.sln` in `node_modules/react-native-unity-bridge/windows/RNUnityBridge.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Unity.Bridge.RNUnityBridge;` to the usings at the top of the file
  - Add `new RNUnityBridgePackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import UnityBridge from 'react-native-unity-bridge';

// TODO: What to do with the module?
UnityBridge;
```
