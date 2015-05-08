
#import <UIKit/UIKit.h>


/**********************************************
 TimerLabel TimerType Enum
 **********************************************/
typedef enum{
    TimerLabelTypeStopWatch,
    TimerLabelTypeTimer
}TimerLabelType;

/**********************************************
 Delegate Methods
 @optional
 
 - timerLabel:finshedCountDownTimerWithTimeWithTime:
    ** TimerLabel Delegate method for finish of countdown timer

 - timerLabel:countingTo:timertype:
    ** TimerLabel Delegate method for monitering the current counting progress
 
 - timerlabel:customTextToDisplayAtTime:
    ** TimerLabel Delegate method for overriding the text displaying at the time, implement this for your very custom display formmat
**********************************************/
 
@class TimerLabel;
@protocol TimerLabelDelegate <NSObject>
@optional
-(void)timerLabel:(TimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime;
-(void)timerLabel:(TimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(TimerLabelType)timerType;
-(NSString*)timerLabel:(TimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time;
@end

/**********************************************
 TimerLabel Class Defination
 **********************************************/

@interface TimerLabel : UILabel;

/*Delegate for finish of countdown timer */
@property (nonatomic,weak) id<TimerLabelDelegate> delegate;

/*Time format wish to display in label*/
@property (nonatomic,copy) NSString *timeFormat;

/*Target label obejct, default self if you do not initWithLabel nor set*/
@property (nonatomic,strong) UILabel *timeLabel;

/*Type to choose from stopwatch or timer*/
@property (assign) TimerLabelType timerType;

/*Is The Timer Running?*/
@property (assign,readonly) BOOL counting;

/*Do you want to reset the Timer after countdown?*/
@property (assign) BOOL resetTimerAfterFinish;

/*Do you want the timer to count beyond the HH limit from 0-23 e.g. 25:23:12 (HH:mm:ss) */
@property (assign,nonatomic) BOOL shouldCountBeyondHHLimit;

#if NS_BLOCKS_AVAILABLE
@property (copy) void (^endedBlock)(NSTimeInterval);
#endif


/*--------Init methods to choose*/
-(id)initWithTimerType:(TimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel andTimerType:(TimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel;


/*--------Timer control methods to use*/
-(void)start;
#if NS_BLOCKS_AVAILABLE
-(void)startWithEndingBlock:(void(^)(NSTimeInterval countTime))end; //use it if you are not going to use delegate
#endif
-(void)pause;
-(void)reset;

/*--------Setter methods*/
-(void)setCountDownTime:(NSTimeInterval)time;
-(void)setStopWatchTime:(NSTimeInterval)time;
-(void)setCountDownToDate:(NSDate*)date;

-(void)addTimeCountedByTime:(NSTimeInterval)timeToAdd;

/*--------Getter methods*/
- (NSTimeInterval)getTimeCounted;
- (NSTimeInterval)getTimeRemaining;
- (NSTimeInterval)getCountDownTime;





@end


