import { Platform } from "react-native";
import RNTimeRulerIOS from "./index.ios.js";
import RNTimeRulerAndroid from "./index.android.js";

const RNScrollRuler = Platform.OS === "ios"
  ? RNTimeRulerIOS
  : RNTimeRulerAndroid;

export default RNTimeRuler;
