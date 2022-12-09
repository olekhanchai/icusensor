package com.main.icusensor.service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RetData {
        private String GainChamber;
        private String OffsetChamber;
        private String GainO2;
        private String OffsetO2;
        private String GainCo2;
        private String OffsetCo2;
        private String GainHumidit;
        private String OffsetHumidity;
        private String Temp;
        private String TargetTemp;
        private String HystersisTemp;
        private String O2;
        private String TargetO2;
        private String HystersisO2;
        private String CO2;
        private String TargetCO2;
        private String HystersisCO2;
        private String HUMI;
        private String TargetHumi;
        private String HystersisHumi;
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
        private String O2PWM;
        private String O2Inverting;
        private String CO2State;
        private String CO2Timer;
        private String CO2Mode1;
        private String CO2Mode2;
        private String CO2Elaps;
        private String CO2PWM;
        private String CO2Inverting;
        private String HumiState;
        private String HumiTimer;
        private String HumiMode1;
        private String HumiMode2;
        private String HumiElaps;
        private String HumiPWM;
        private String HumiInverting;
        private String LightState;
        private String LightTimer;
        private String LightMode1;
        private String LightMode2;
        private String LightElaps;
        private String UVCState;
        private String UVCTimer;
        private String UVCMode1;
        private String UVCMode2;
        private String UVCElaps;
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
        private String Bright;
        private String TempFan;
        private String O2Fan;
        private String HumiFan;
        private String HotEnd1;
        private String HotEnd2;
        private String HotEnd3;
        private String HotEnd4;

        public RetData(){

        }

        public String getGainChamber() {
                return GainChamber;
        }

        public void setGainChamber(String gainChamber) {
                GainChamber = gainChamber;
        }

        public String getOffsetChamber() {
                return OffsetChamber;
        }

        public void setOffsetChamber(String offsetChamber) {
                OffsetChamber = offsetChamber;
        }

        public String getGainO2() {
                return GainO2;
        }

        public void setGainO2(String gainO2) {
                GainO2 = gainO2;
        }

        public String getOffsetO2() {
                return OffsetO2;
        }

        public void setOffsetO2(String offsetO2) {
                OffsetO2 = offsetO2;
        }

        public String getGainCo2() {
                return GainCo2;
        }

        public void setGainCo2(String gainCo2) {
                GainCo2 = gainCo2;
        }

        public String getOffsetCo2() {
                return OffsetCo2;
        }

        public void setOffsetCo2(String offsetCo2) {
                OffsetCo2 = offsetCo2;
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

        public String getTemp() {
                return Temp;
        }

        public void setTemp(String temp) {
                Temp = temp;
        }

        public String getTargetTemp() {
                return TargetTemp;
        }

        public void setTargetTemp(String targetTemp) {
                TargetTemp = targetTemp;
        }

        public String getHystersisTemp() {
                return HystersisTemp;
        }

        public void setHystersisTemp(String hystersisTemp) {
                HystersisTemp = hystersisTemp;
        }

        public String getO2() {
                return O2;
        }

        public void setO2(String o2) {
                O2 = o2;
        }

        public String getTargetO2() {
                return TargetO2;
        }

        public void setTargetO2(String targetO2) {
                TargetO2 = targetO2;
        }

        public String getHystersisO2() {
                return HystersisO2;
        }

        public void setHystersisO2(String hystersisO2) {
                HystersisO2 = hystersisO2;
        }

        public String getCO2() {
                return CO2;
        }

        public void setCO2(String CO2) {
                this.CO2 = CO2;
        }

        public String getTargetCO2() {
                return TargetCO2;
        }

        public void setTargetCO2(String targetCO2) {
                TargetCO2 = targetCO2;
        }

        public String getHystersisCO2() {
                return HystersisCO2;
        }

        public void setHystersisCO2(String hystersisCO2) {
                HystersisCO2 = hystersisCO2;
        }

        public String getHUMI() {
                return HUMI;
        }

        public void setHUMI(String HUMI) {
                this.HUMI = HUMI;
        }

        public String getTargetHumi() {
                return TargetHumi;
        }

        public void setTargetHumi(String targetHumi) {
                TargetHumi = targetHumi;
        }

        public String getHystersisHumi() {
                return HystersisHumi;
        }

        public void setHystersisHumi(String hystersisHumi) {
                HystersisHumi = hystersisHumi;
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

        public String getO2PWM() {
                return O2PWM;
        }

        public void setO2PWM(String o2PWM) {
                O2PWM = o2PWM;
        }

        public String getO2Inverting() {
                return O2Inverting;
        }

        public void setO2Inverting(String o2Inverting) {
                O2Inverting = o2Inverting;
        }

        public String getCO2State() {
                return CO2State;
        }

        public void setCO2State(String CO2State) {
                this.CO2State = CO2State;
        }

        public String getCO2Timer() {
                return CO2Timer;
        }

        public void setCO2Timer(String CO2Timer) {
                this.CO2Timer = CO2Timer;
        }

        public String getCO2Mode1() {
                return CO2Mode1;
        }

        public void setCO2Mode1(String CO2Mode1) {
                this.CO2Mode1 = CO2Mode1;
        }

        public String getCO2Mode2() {
                return CO2Mode2;
        }

        public void setCO2Mode2(String CO2Mode2) {
                this.CO2Mode2 = CO2Mode2;
        }

        public String getCO2Elaps() {
                return CO2Elaps;
        }

        public void setCO2Elaps(String CO2Elaps) {
                this.CO2Elaps = CO2Elaps;
        }

        public String getCO2PWM() {
                return CO2PWM;
        }

        public void setCO2PWM(String CO2PWM) {
                this.CO2PWM = CO2PWM;
        }

        public String getCO2Inverting() {
                return CO2Inverting;
        }

        public void setCO2Inverting(String CO2Inverting) {
                this.CO2Inverting = CO2Inverting;
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

        public String getHumiPWM() {
                return HumiPWM;
        }

        public void setHumiPWM(String humiPWM) {
                HumiPWM = humiPWM;
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

        public String getUVCState() {
                return UVCState;
        }

        public void setUVCState(String UVCState) {
                this.UVCState = UVCState;
        }

        public String getUVCTimer() {
                return UVCTimer;
        }

        public void setUVCTimer(String UVCTimer) {
                this.UVCTimer = UVCTimer;
        }

        public String getUVCMode1() {
                return UVCMode1;
        }

        public void setUVCMode1(String UVCMode1) {
                this.UVCMode1 = UVCMode1;
        }

        public String getUVCMode2() {
                return UVCMode2;
        }

        public void setUVCMode2(String UVCMode2) {
                this.UVCMode2 = UVCMode2;
        }

        public String getUVCElaps() {
                return UVCElaps;
        }

        public void setUVCElaps(String UVCElaps) {
                this.UVCElaps = UVCElaps;
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

        public String getBright() {
                return Bright;
        }

        public void setBright(String bright) {
                Bright = bright;
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

        public String getHotEnd1() {
                return HotEnd1;
        }

        public void setHotEnd1(String hotEnd1) {
                HotEnd1 = hotEnd1;
        }

        public String getHotEnd2() {
                return HotEnd2;
        }

        public void setHotEnd2(String hotEnd2) {
                HotEnd2 = hotEnd2;
        }

        public String getHotEnd3() {
                return HotEnd3;
        }

        public void setHotEnd3(String hotEnd3) {
                HotEnd3 = hotEnd3;
        }

        public String getHotEnd4() {
                return HotEnd4;
        }

        public void setHotEnd4(String hotEnd4) {
                HotEnd4 = hotEnd4;
        }
}