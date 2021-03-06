//
//  LabJackU6DataDevice.h 
//  Lablib
//
//  Copyright 2016 All rights reserved.
//
#import <Lablib/LLDataDevice.h>
#import "LabJackUSB.h"
#import "LabJackU6Monitor.h"

//#define LJU6_DITASK_UPDATE_PERIOD_US 15000
//#define LJU6_DITASK_WARN_SLOP_US     50000
//#define LJU6_DITASK_FAIL_SLOP_US     50000

typedef NS_ENUM(unsigned int, LabJackU6Channel) {kRXChannel = 0, kRYChannel, kRPChannel, kLXChannel, kLYChannel, kLPChannel, kLabJackU6Channels};

@interface LabJackU6DataDevice : LLDataDevice {

    unsigned long           digitalOutputBits;
    BOOL                    doingDealloc;
    int                     eye_used;
    double                  nextSampleTimeS;
    HANDLE                  ljHandle;
    double                  LabJackU6SamplePeriodS;
    double                  sampleTimeS;
    double                  monitorStartTimeS;
    double                  lastReadDataTimeS;
    long                    laserTrigger;
    BOOL                    lever1;
    BOOL                    lever2;
    long                    lever1Solenoid;
    long                    lever2Solenoid;
    BOOL                    justStartedLabJackU6;
    long                    pulseOn;
    long                    pulseDuration;
    NSMutableData           *sampleData[kLabJackU6Channels];
    BOOL                    shouldKillPolling;
    long                    strobedDigitalWord;
    NSMutableData            *lXData, *lYData, *lPData;
    NSMutableData            *rXData, *rYData, *rPData;
    NSLock                    *dataLock;
    NSLock                    *deviceLock;
    NSThread                *pollThread;
    LabJackU6Monitor        *monitor;
    LabJackU6MonitorValues    values;
}

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *name;
@property (NS_NONATOMIC_IOSONLY, readonly) long sampleChannels;
@property (NS_NONATOMIC_IOSONLY, readonly) NSData **sampleData;

- (BOOL)readLeverDI:(BOOL *)outLever1 lever2:(BOOL *)outLever2;
- (BOOL)ljU6WriteDO:(long)channel state:(long)state;
- (void)disableSampleChannels:(NSNumber *)bitPattern;
- (void)enableSampleChannels:(NSNumber *)bitPattern;
- (float)samplePeriodMSForChannel:(long)channel;
//- (void)setDataEnabled:(NSNumber *)state;
- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;

@end

/*

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
    
};


#endif
*/
