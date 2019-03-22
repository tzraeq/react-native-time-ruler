import React, {Component} from 'react';
import PropTypes from 'prop-types';
import {requireNativeComponent, View, ViewPropTypes} from 'react-native';

type PropsType = {
    startTime?: number;
    endTime?: number;
    time?: number;
} & typeof
(View);

export default class RNTimeRuler extends Component {
    static propTypes = {
        startTime: PropTypes.number.isRequired,
        endTime: PropTypes.number.isRequired,
        time: PropTypes.number,
        onScroll: PropTypes.func,
        onScrollEnd: PropTypes.func,
        ...ViewPropTypes,
    };
    props: PropsType;
    rulerRef: any;

    setNativeProps(props: PropsType) {
        this.rulerRef.setNativeProps(props);
    }

    _onScroll = (event) => {
        let {onScroll} = this.props;
        if (!onScroll) {
            return;
        }
        onScroll(event.nativeEvent.time);
    }

    _onScrollEnd = (event) => {
        let {onScrollEnd} = this.props;
        if (!onScrollEnd) {
            return;
        }
        onScrollEnd(event.nativeEvent.time);
    }

    render() {
        const {
            startTime,
            endTime,
            defaultValue,
            time,
            onScroll,
            onScrollEnd,
            tickColor,
            bgColor,
            ...otherProps
        } = this.props;

        return (
            <RCTScrollRuler
                ref={(component) => {
                    this.rulerRef = component;
                }}
                startTime={startTime}
                endTime={endTime}
                time={time}
                bgColor={bgColor}
                tickColor={tickColor}
                onScrolling={this._onScroll}
                onScrollEnd={this._onScrollEnd}
                {...otherProps}
            />
        );
    }
}

const RCTScrollRuler = requireNativeComponent('RCTTimeRuler', null);