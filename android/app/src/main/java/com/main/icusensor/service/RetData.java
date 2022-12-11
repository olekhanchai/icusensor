package com.main.icusensor.service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RetData {
        private String TempGain;
        private String TempOffset;
        private String O2Gain;
        private String Co2Offset;
        private String Co2Gain;
        private String GainHumidit;
        private String OffsetHumidity;
        private String TempValue;
        private String TempTarget;
        private String TempHystersis;
        private String O2Value;
        private String O2Target;
        private String O2Hystersis;
        private String Co2Value;
        private String Co2Target;
        private String Co2Hystersis;
        private String HumiValue;
        private String HumiTarget;
        private String HumiHystersis;
        private String TempState;
        private String TempTimer;
        private String TempMode1;
        private String TempMode2;
        private String TempElaps;
        private String TempPWM;
        private String TempInverting;
        private String O2State;
        private String O2Timer;
        private String O2Mode1;
        private String O2Mode2;
        private String O2Elaps;
        private String O2Pwm;
        private String O2Inverting;
        private String Co2State;
        private String Co2Timer;
        private String Co2Mode1;
        private String Co2Mode2;
        private String Co2Elaps;
        private String Co2Pwm;
        private String Co2Inverting;
        private String HumiState;
        private String HumiTimer;
        private String HumiMode1;
        private String HumiMode2;
        private String HumiElaps;
        private String HumiPwm;
        private String HumiInverting;
        private String LightState;
        private String LightTimer;
        private String LightMode1;
        private String LightMode2;
        private String LightElaps;
        private String UvcState;
        private String UvcTimer;
        private String UvcMode1;
        private String UvcMode2;
        private String UvcElaps;
        private String NebuState;
        private String NebuTimer;
        private String NebuMode1;
        private String NebuMode2;
        private String NebuElaps;
        private String IronState;
        private String IronTimer;
        private String IronMode1;
        private String IronMode2;
        private String IronElaps;
        private String Red;
        private String Green;
        private String Blue;
        private String Brightness;
        private String TempFan;
        private String O2Fan;
        private String HumiFan;

        public RetData(){

        }

        public String getTempGain() {
                return TempGain;
        }

        public void setTempGain(String tempGain) {
                TempGain = tempGain;
        }

        public String getTempOffset() {
                return TempOffset;
        }

        public void setTempOffset(String tempOffset) {
                TempOffset = tempOffset;
        }

        public String getO2Gain() {
                return O2Gain;
        }

        public void setO2Gain(String o2Gain) {
                O2Gain = o2Gain;
        }

        public String getCo2Offset() {
                return Co2Offset;
        }

        public void setCo2Offset(String co2Offset) {
                Co2Offset = co2Offset;
        }

        public String getCo2Gain() {
                return Co2Gain;
        }

        public void setCo2Gain(String co2Gain) {
                Co2Gain = co2Gain;
        }

        public String getGainHumidit() {
                return GainHumidit;
        }

        public void setGainHumidit(String gainHumidit) {
                GainHumidit = gainHumidit;
        }

        public String getOffsetHumidity() {
                return OffsetHumidity;
        }

        public void setOffsetHumidity(String offsetHumidity) {
                OffsetHumidity = offsetHumidity;
        }

        public String getTempValue() {
                return TempValue;
        }

        public void setTempValue(String tempValue) {
                TempValue = tempValue;
        }

        public String getTempTarget() {
                return TempTarget;
        }

        public void setTempTarget(String tempTarget) {
                TempTarget = tempTarget;
        }

        public String getTempHystersis() {
                return TempHystersis;
        }

        public void setTempHystersis(String tempHystersis) {
                TempHystersis = tempHystersis;
        }

        public String getO2Value() {
                return O2Value;
        }

        public void setO2Value(String o2Value) {
                O2Value = o2Value;
        }

        public String getO2Target() {
                return O2Target;
        }

        public void setO2Target(String o2Target) {
                O2Target = o2Target;
        }

        public String getO2Hystersis() {
                return O2Hystersis;
        }

        public void setO2Hystersis(String o2Hystersis) {
                O2Hystersis = o2Hystersis;
        }

        public String getCo2Value() {
                return Co2Value;
        }

        public void setCo2Value(String co2Value) {
                Co2Value = co2Value;
        }

        public String getCo2Target() {
                return Co2Target;
        }

        public void setCo2Target(String co2Target) {
                Co2Target = co2Target;
        }

        public String getCo2Hystersis() {
                return Co2Hystersis;
        }

        public void setCo2Hystersis(String co2Hystersis) {
                Co2Hystersis = co2Hystersis;
        }

        public String getHumiValue() {
                return HumiValue;
        }

        public void setHumiValue(String humiValue) {
                HumiValue = humiValue;
        }

        public String getHumiTarget() {
                return HumiTarget;
        }

        public void setHumiTarget(String humiTarget) {
                HumiTarget = humiTarget;
        }

        public String getHumiHystersis() {
                return HumiHystersis;
        }

        public void setHumiHystersis(String humiHystersis) {
                HumiHystersis = humiHystersis;
        }

        public String getTempState() {
                return TempState;
        }

        public void setTempState(String tempState) {
                TempState = tempState;
        }

        public String getTempTimer() {
                return TempTimer;
        }

        public void setTempTimer(String tempTimer) {
                TempTimer = tempTimer;
        }

        public String getTempMode1() {
                return TempMode1;
        }

        public void setTempMode1(String tempMode1) {
                TempMode1 = tempMode1;
        }

        public String getTempMode2() {
                return TempMode2;
        }

        public void setTempMode2(String tempMode2) {
                TempMode2 = tempMode2;
        }

        public String getTempElaps() {
                return TempElaps;
        }

        public void setTempElaps(String tempElaps) {
                TempElaps = tempElaps;
        }

        public String getTempPWM() {
                return TempPWM;
        }

        public void setTempPWM(String tempPWM) {
                TempPWM = tempPWM;
        }

        public String getTempInverting() {
                return TempInverting;
        }

        public void setTempInverting(String tempInverting) {
                TempInverting = tempInverting;
        }

        public String getO2State() {
                return O2State;
        }

        public void setO2State(String o2State) {
                O2State = o2State;
        }

        public String getO2Timer() {
                return O2Timer;
        }

        public void setO2Timer(String o2Timer) {
                O2Timer = o2Timer;
        }

        public String getO2Mode1() {
                return O2Mode1;
        }

        public void setO2Mode1(String o2Mode1) {
                O2Mode1 = o2Mode1;
        }

        public String getO2Mode2() {
                return O2Mode2;
        }

        public void setO2Mode2(String o2Mode2) {
                O2Mode2 = o2Mode2;
        }

        public String getO2Elaps() {
                return O2Elaps;
        }

        public void setO2Elaps(String o2Elaps) {
                O2Elaps = o2Elaps;
        }

        public String getO2Pwm() {
                return O2Pwm;
        }

        public void setO2Pwm(String o2Pwm) {
                O2Pwm = o2Pwm;
        }

        public String getO2Inverting() {
                return O2Inverting;
        }

        public void setO2Inverting(String o2Inverting) {
                O2Inverting = o2Inverting;
        }

        public String getCo2State() {
                return Co2State;
        }

        public void setCo2State(String co2State) {
                Co2State = co2State;
        }

        public String getCo2Timer() {
                return Co2Timer;
        }

        public void setCo2Timer(String co2Timer) {
                Co2Timer = co2Timer;
        }

        public String getCo2Mode1() {
                return Co2Mode1;
        }

        public void setCo2Mode1(String co2Mode1) {
                Co2Mode1 = co2Mode1;
        }

        public String getCo2Mode2() {
                return Co2Mode2;
        }

        public void setCo2Mode2(String co2Mode2) {
                Co2Mode2 = co2Mode2;
        }

        public String getCo2Elaps() {
                return Co2Elaps;
        }

        public void setCo2Elaps(String co2Elaps) {
                Co2Elaps = co2Elaps;
        }

        public String getCo2Pwm() {
                return Co2Pwm;
        }

        public void setCo2Pwm(String co2Pwm) {
                Co2Pwm = co2Pwm;
        }

        public String getCo2Inverting() {
                return Co2Inverting;
        }

        public void setCo2Inverting(String co2Inverting) {
                Co2Inverting = co2Inverting;
        }

        public String getHumiState() {
                return HumiState;
        }

        public void setHumiState(String humiState) {
                HumiState = humiState;
        }

        public String getHumiTimer() {
                return HumiTimer;
        }

        public void setHumiTimer(String humiTimer) {
                HumiTimer = humiTimer;
        }

        public String getHumiMode1() {
                return HumiMode1;
        }

        public void setHumiMode1(String humiMode1) {
                HumiMode1 = humiMode1;
        }

        public String getHumiMode2() {
                return HumiMode2;
        }

        public void setHumiMode2(String humiMode2) {
                HumiMode2 = humiMode2;
        }

        public String getHumiElaps() {
                return HumiElaps;
        }

        public void setHumiElaps(String humiElaps) {
                HumiElaps = humiElaps;
        }

        public String getHumiPwm() {
                return HumiPwm;
        }

        public void setHumiPwm(String humiPwm) {
                HumiPwm = humiPwm;
        }

        public String getHumiInverting() {
                return HumiInverting;
        }

        public void setHumiInverting(String humiInverting) {
                HumiInverting = humiInverting;
        }

        public String getLightState() {
                return LightState;
        }

        public void setLightState(String lightState) {
                LightState = lightState;
        }

        public String getLightTimer() {
                return LightTimer;
        }

        public void setLightTimer(String lightTimer) {
                LightTimer = lightTimer;
        }

        public String getLightMode1() {
                return LightMode1;
        }

        public void setLightMode1(String lightMode1) {
                LightMode1 = lightMode1;
        }

        public String getLightMode2() {
                return LightMode2;
        }

        public void setLightMode2(String lightMode2) {
                LightMode2 = lightMode2;
        }

        public String getLightElaps() {
                return LightElaps;
        }

        public void setLightElaps(String lightElaps) {
                LightElaps = lightElaps;
        }

        public String getUvcState() {
                return UvcState;
        }

        public void setUvcState(String uvcState) {
                UvcState = uvcState;
        }

        public String getUvcTimer() {
                return UvcTimer;
        }

        public void setUvcTimer(String uvcTimer) {
                UvcTimer = uvcTimer;
        }

        public String getUvcMode1() {
                return UvcMode1;
        }

        public void setUvcMode1(String uvcMode1) {
                UvcMode1 = uvcMode1;
        }

        public String getUvcMode2() {
                return UvcMode2;
        }

        public void setUvcMode2(String uvcMode2) {
                UvcMode2 = uvcMode2;
        }

        public String getUvcElaps() {
                return UvcElaps;
        }

        public void setUvcElaps(String uvcElaps) {
                UvcElaps = uvcElaps;
        }

        public String getNebuState() {
                return NebuState;
        }

        public void setNebuState(String nebuState) {
                NebuState = nebuState;
        }

        public String getNebuTimer() {
                return NebuTimer;
        }

        public void setNebuTimer(String nebuTimer) {
                NebuTimer = nebuTimer;
        }

        public String getNebuMode1() {
                return NebuMode1;
        }

        public void setNebuMode1(String nebuMode1) {
                NebuMode1 = nebuMode1;
        }

        public String getNebuMode2() {
                return NebuMode2;
        }

        public void setNebuMode2(String nebuMode2) {
                NebuMode2 = nebuMode2;
        }

        public String getNebuElaps() {
                return NebuElaps;
        }

        public void setNebuElaps(String nebuElaps) {
                NebuElaps = nebuElaps;
        }

        public String getIronState() {
                return IronState;
        }

        public void setIronState(String ironState) {
                IronState = ironState;
        }

        public String getIronTimer() {
                return IronTimer;
        }

        public void setIronTimer(String ironTimer) {
                IronTimer = ironTimer;
        }

        public String getIronMode1() {
                return IronMode1;
        }

        public void setIronMode1(String ironMode1) {
                IronMode1 = ironMode1;
        }

        public String getIronMode2() {
                return IronMode2;
        }

        public void setIronMode2(String ironMode2) {
                IronMode2 = ironMode2;
        }

        public String getIronElaps() {
                return IronElaps;
        }

        public void setIronElaps(String ironElaps) {
                IronElaps = ironElaps;
        }

        public String getRed() {
                return Red;
        }

        public void setRed(String red) {
                Red = red;
        }

        public String getGreen() {
                return Green;
        }

        public void setGreen(String green) {
                Green = green;
        }

        public String getBlue() {
                return Blue;
        }

        public void setBlue(String blue) {
                Blue = blue;
        }

        public String getBrightness() {
                return Brightness;
        }

        public void setBrightness(String brightness) {
                Brightness = brightness;
        }

        public String getTempFan() {
                return TempFan;
        }

        public void setTempFan(String tempFan) {
                TempFan = tempFan;
        }

        public String getO2Fan() {
                return O2Fan;
        }

        public void setO2Fan(String o2Fan) {
                O2Fan = o2Fan;
        }

        public String getHumiFan() {
                return HumiFan;
        }

        public void setHumiFan(String humiFan) {
                HumiFan = humiFan;
        }
}