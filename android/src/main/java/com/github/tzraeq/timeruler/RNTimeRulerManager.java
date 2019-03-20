package com.github.tzraeq.timeruler;

import android.view.View;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import javax.annotation.Nullable;

/**
 * @author tzraeq
 * @email tzraeq@163.com
 * @description
 */

public class RNTimeRulerManager extends SimpleViewManager {

    public static final String REACT_CLASS = "RNTimeRuler";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected View createViewInstance(final ThemedReactContext reactContext) {
        final RNTimeRuler ruler = new RNTimeRuler(reactContext);
        ruler.setOnChooseResulterListener(new RNTimeRuler.OnChooseResulterListener() {
            @Override
            public void onEndResult(String result) {
                WritableMap event = Arguments.createMap();
                event.putString("value", result);
                reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(ruler.getId(), "topSelect", event);
            }

            @Override
            public void onScrollResult(String result) {

            }
        });
        return ruler;
    }

    @ReactProp(name = "minValue")
    public void setMinValue(RNTimeRuler ruler, @Nullable int minValue) {
        ruler.setMinScale(minValue);
    }

    @ReactProp(name = "maxValue")
    public void setMaxValue(RNTimeRuler ruler, @Nullable int maxValue) {
        ruler.setMaxScale(maxValue);
    }

    @ReactProp(name = "defaultValue")
    public void setDefaultValue(RNTimeRuler ruler, @Nullable int defaultValue) {
        ruler.setFirstScale(defaultValue);
    }

    @ReactProp(name = "unit")
    public void setUnit(RNTimeRuler ruler, @Nullable String unit) {
        ruler.setUnit(unit);
    }

    @ReactProp(name = "step")
    public void setStep(RNTimeRuler ruler, @Nullable float step) {
        ruler.setScaleLimit((int)(step * 10));
    }

    @ReactProp(name = "num")
    public void setNum(RNTimeRuler ruler, @Nullable int num) {
        ruler.setScaleCount(num);
    }

}
