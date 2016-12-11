//
//  LabJackU6DataDevice.h 
//  Lablib
//
//  Copyright 2016 All rights reserved.
//
#import <Lablib/LLDataDevice.h>
#import "labjackusb.h"
#import "LabJackU6Monitor.h"

// Digital output: Use a 12-bit word; EIO0-7, CIO0-2, all encoded below

#define LJU6_REWARD_FIO         0
#define LJU6_LEVER1_FIO         1
#define LJU6_LEVER1SOLENOID_FIO 2
#define LJU6_LASERTRIGGER_FIO   3
#define LJU6_LEVER2_FIO         4
#define LJU6_LEVER2SOLENOID_FIO 5
#define LJU6_COUNTER_FIO        6
#define LJU6_STROBE_FIO         7

#define LJU6_DITASK_UPDATE_PERIOD_US 15000
#define LJU6_DITASK_WARN_SLOP_US     50000
#define LJU6_DITASK_FAIL_SLOP_US     50000

typedef enum {kRXChannel = 0, kRYChannel, kRPChannel, kLXChannel, kLYChannel, kLPChannel, kLabJackU6Channels} LabJackU6Channel;

@interface LabJackU6DataDevice : LLDataDevice {

    BOOL                    doingDealloc;
    int						eye_used;
	double					nextSampleTimeS;
    HANDLE                  ljHandle;
	double					LabJackU6SamplePeriodS;
	double					sampleTimeS;
	double					monitorStartTimeS;
	double					lastReadDataTimeS;
    long                    laserTrigger;
    long                    lever1Solenoid;
    long                    lever2Solenoid;
	BOOL					justStartedLabJackU6;
    long                    pulseOn;
    long                    pulseDuration;
	NSMutableData			*sampleData[kLabJackU6Channels];
    long                    strobedDigitalWord;
	NSMutableData			*lXData, *lYData, *lPData;
	NSMutableData			*rXData, *rYData, *rPData;
	NSLock					*dataLock;
	NSLock					*deviceLock;
	NSThread				*pollThread;
	LabJackU6Monitor		*monitor;
	LabJackU6MonitorValues	values;
}

- (void)disableSampleChannels:(NSNumber *)bitPattern;
- (void)enableSampleChannels:(NSNumber *)bitPattern;
- (NSString *)name;
- (long)sampleChannels;
- (NSData **)sampleData;
- (float)samplePeriodMSForChannel:(long)channel;
- (void)setDataEnabled:(NSNumber *)state;
- (void)setDeviceEnabled:(NSNumber *)state;
- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;

@end

/*
 *
 *  LabJack U6 Plugin for MWorks
 *
 *  Created by Mark Histed on 4/21/2010
 *    (based on Nidaq plugin code by Jon Hendry and John Maunsell)
 *
 *

#ifndef _LJU6_DEVICE_H_
#define _LJU6_DEVICE_H_

#include <boost/noncopyable.hpp>
#include "labjackusb.h"
#include <boost/shared_ptr.hpp>

#undef VERBOSE_IO_DEVICE
#define VERBOSE_IO_DEVICE 0  // verbosity level is 0-2, 2 is maximum

#define LJU6_DITASK_UPDATE_PERIOD_US 15000
#define LJU6_DITASK_WARN_SLOP_US     50000
#define LJU6_DITASK_FAIL_SLOP_US     50000



BEGIN_NAMESPACE_MW


class LabJackU6DeviceOutputNotification;

class LabJackU6Device : public IODevice, boost::noncopyable {
    
protected:
    
    bool                        connected;
    
    MWTime                      lastLever1TransitionTimeUS;
    MWTime                      lastLever2TransitionTimeUS;
    int lastLever1Value;
    int lastLever2Value;
    
    boost::shared_ptr <Scheduler> scheduler;
    boost::shared_ptr<ScheduleTask>   pulseScheduleNode;
    boost::shared_ptr<ScheduleTask>   pollScheduleNode;
    boost::mutex                pulseScheduleNodeLock;
    boost::mutex                pollScheduleNodeLock;
    boost::mutex                ljU6DriverLock;
    MWTime                      highTimeUS;  // Used to compute length of scheduled high/low pulses
    
    HANDLE                      ljHandle;
    
    boost::shared_ptr <Variable> pulseDuration;
    boost::shared_ptr <Variable> pulseOn;
    boost::shared_ptr <Variable> lever1;
    boost::shared_ptr <Variable> lever2;
    boost::shared_ptr <Variable> lever1Solenoid;
    boost::shared_ptr <Variable> lever2Solenoid;
    boost::shared_ptr <Variable> laserTrigger;
    boost::shared_ptr <Variable> strobedDigitalWord;
    boost::shared_ptr <Variable> counter;
    
    //MWTime update_period;  MH this is now hardcoded, users should not change this
    
    bool active;
    boost::mutex active_mutex;
    bool deviceIOrunning;
    bool doingDestructor;
    
    // raw hardware functions
    bool ljU6ConfigPorts(HANDLE Handle);
    bool ljU6ReadDI(HANDLE Handle, long Channel, long* State);
    bool ljU6WriteDO(HANDLE Handle, long Channel, long State);
    bool ljU6WriteStrobedWord(HANDLE Handle, unsigned int inWord);
    bool ljU6ReadPorts(HANDLE Handle, unsigned int *fioState, unsigned int *eioState, unsigned int *cioState);
    
    
public:
    static const std::string PULSE_DURATION;
    static const std::string PULSE_ON;
    static const std::string LEVER1;
    static const std::string LEVER2;
    static const std::string LEVER1_SOLENOID;
    static const std::string LEVER2_SOLENOID;
    static const std::string LASER_TRIGGER;
    static const std::string STROBED_DIGITAL_WORD;
    static const std::string COUNTER;
    
    static void describeComponent(ComponentInfo &info);
    
    explicit LabJackU6Device(const ParameterValueMap &parameters);
    ~LabJackU6Device();
    
    virtual bool startup();
    virtual bool shutdown();
    //       virtual bool attachPhysicalDevice();       DEPRECATED IN 0.4.4
    virtual bool initialize();
    virtual bool startDeviceIO();
    virtual bool stopDeviceIO();
    
    virtual bool pollAllDI();
    void detachPhysicalDevice();
    void variableSetup();
    bool setupU6PortsAndRestartIfDead();
    
    
    bool readLeverDI(bool *outLever1, bool *outLever2);
    void pulseDOHigh(int pulseLengthUS);
    void pulseDOLow();
    void leverSolenoidDO(bool state, long channel);
    void laserDO(bool state);
    void strobedDigitalWordDO(unsigned int digWord);
    
    virtual void dispense(Datum data){
        if(getActive()){
            bool doReward = (bool)data;
            
            // Bring DO high for pulseDuration
            if (doReward) {
                this->pulseDOHigh(pulseDuration->getValue());
            }
        }
    }
    virtual void setLever1Solenoid(Datum data) {
        //mprintf(M_IODEVICE_MESSAGE_DOMAIN, "set 1");
        if (getActive()) {
            bool lever1SolenoidState = (bool)data;
            this->leverSolenoidDO(lever1SolenoidState, LJU6_LEVER1SOLENOID_FIO);
        }
    }
    virtual void setLever2Solenoid(Datum data) {
        //mprintf(M_IODEVICE_MESSAGE_DOMAIN, "set 2");
        if (getActive()) {
            bool lever2SolenoidState = (bool)data;
            this->leverSolenoidDO(lever2SolenoidState, LJU6_LEVER2SOLENOID_FIO);
        }
    }
    
    virtual void setLaserTrigger(Datum data) {
        if (getActive()) {
            bool laserState = (bool)data;
            this->laserDO(laserState);
        }
    }
    
    virtual void setStrobedDigitalWord(Datum data) {
        if (getActive()) {
            unsigned int digWord = (int)data;
            this->strobedDigitalWordDO(digWord);
        } else {
            // silent: we need to doublecheck the active/deviceIORunning states and make sure they're doing the right thing.
            // here, we set the value of this variable to zero on init; active/deviceIORunning is true only
            //   during a trial.  I think the right thing to do is silently drop the output function.
            //merror(M_IODEVICE_MESSAGE_DOMAIN, "LJU6: not running; not writing to strobed port (data was 0x%02x)", (int)data);
        }
    }
    
    virtual void setActive(bool _active){
        boost::mutex::scoped_lock active_lock(active_mutex);
        active = _active;
    }
    
    virtual bool getActive(){
        boost::mutex::scoped_lock active_lock(active_mutex);
        bool is_active = active;
        return is_active;
    }
    
    boost::shared_ptr<LabJackU6Device> shared_from_this() { return boost::static_pointer_cast<LabJackU6Device>(IODevice::shared_from_this()); }
    
};


 class LabJackU6DeviceOutputNotification : public VariableNotification { // reward variable

protected:
    boost::weak_ptr<LabJackU6Device> daq;
    
public:
    LabJackU6DeviceOutputNotification(boost::weak_ptr<LabJackU6Device> _daq){
        daq = _daq;
    }
    
    virtual void notify(const Datum& data, MWTime timeUS){
        boost::shared_ptr<LabJackU6Device> shared_daq(daq);
        shared_daq->dispense(data);
    }
};

class LabJackU6DeviceL1SNotification : public VariableNotification {
    
protected:
    boost::weak_ptr<LabJackU6Device> daq;
public:
    LabJackU6DeviceL1SNotification(boost::weak_ptr<LabJackU6Device> _daq){
        daq = _daq;
    }
    virtual void notify(const Datum& data, MWTime timeUS){
        boost::shared_ptr<LabJackU6Device> shared_daq(daq);
        shared_daq->setLever1Solenoid(data);
    }
};

class LabJackU6DeviceL2SNotification : public VariableNotification {
    
protected:
    boost::weak_ptr<LabJackU6Device> daq;
public:
    LabJackU6DeviceL2SNotification(boost::weak_ptr<LabJackU6Device> _daq){
        daq = _daq;
    }
    virtual void notify(const Datum& data, MWTime timeUS){
        boost::shared_ptr<LabJackU6Device> shared_daq(daq);
        shared_daq->setLever2Solenoid(data);
    }
};



class LabJackU6DeviceLTNotification : public VariableNotification {
    
protected:
    boost::weak_ptr<LabJackU6Device> daq;
public:
    LabJackU6DeviceLTNotification(boost::weak_ptr<LabJackU6Device> _daq){
        daq = _daq;
    }
    virtual void notify(const Datum& data, MWTime timeUS){
        boost::shared_ptr<LabJackU6Device> shared_daq(daq);
        shared_daq->setLaserTrigger(data);
    }
};

class LabJackU6DeviceSDWNotification : public VariableNotification {
    
protected:
    boost::weak_ptr<LabJackU6Device> daq;
public:
    LabJackU6DeviceSDWNotification(boost::weak_ptr<LabJackU6Device> _daq){
        daq = _daq;
    }
    virtual void notify(const Datum& data, MWTime timeUS){
        boost::shared_ptr<LabJackU6Device> shared_daq(daq);
        shared_daq->setStrobedDigitalWord(data);
    }
};


END_NAMESPACE_MW


#endif
*/
