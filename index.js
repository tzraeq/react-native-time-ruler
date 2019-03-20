import { Platform } from "react-native";
import RNTimeRulerIOS from "./index.ios.js";
import RNTimeRulerAndroid from "./index.android.js";

const RNTimeRuler = Platform.OS === "ios"
  ? RNTimeRulerIOS
  : RNTimeRulerAndroid;

export default RNTimeRuler;
