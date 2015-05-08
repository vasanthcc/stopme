//
//  ViewController.m
//  StopIt
//
//  Created by Vasanth Ravichandran on 22/04/15.
//  Copyright (c) 2015 msf. All rights reserved.
//

#import "ViewController.h"
#import "TimerLabel.h"
#import "SnowFallView.h"

#define ZERO_ACHEIVEMENT 1000
#define VIEW_FRAME self.view.frame
@interface ViewController ()
{
    UILabel *lblShowTarget,*lblShowTimer,*lblShowBest,*lblShowTotal,*lblShowNumberOfFiveStar;
    UIButton *btnTryAgain;//*btnStart,*btnStop
    TimerLabel *timer;
    int currentTime;
    long output;
    UIView *viewResult;
    BOOL isStarted;
    SnowFallView *snowView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
    [self.view setBackgroundColor:[UIColor blackColor]];
}
-(void)createView
{

    isStarted = NO;
    
    UITapGestureRecognizer *labelTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performViewClick)];
    [self.view addGestureRecognizer:labelTapGesture];
    
    
//    MZTimerLabel *redStopwatch = [[MZTimerLabel alloc] init];
//    redStopwatch.frame = CGRectMake(100,50,100,20);
//    redStopwatch.timeLabel.font = [UIFont systemFontOfSize:20.0f];
//    redStopwatch.timeLabel.textColor = [UIColor redColor];
//    [self.view addSubview:redStopwatch];
//    [redStopwatch start];
    
//    -(void)start;
//    -(void)pause;
//    -(void)reset;
    
    lblShowTimer=[[UILabel alloc] initWithFrame:CGRectMake(0,0,VIEW_FRAME.size.width,VIEW_FRAME.size.height/3)];
    lblShowTimer.font=[UIFont fontWithName:@"DBLCDTempBlack" size:80];
    lblShowTimer.textColor=[UIColor cyanColor];
    lblShowTimer.textAlignment=NSTextAlignmentCenter;
    lblShowTimer.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblShowTimer];
    
    lblShowBest=[[UILabel alloc] initWithFrame:CGRectMake(0,lblShowTimer.frame.origin.y+lblShowTimer.frame.size.height,VIEW_FRAME.size.width/2,(VIEW_FRAME.size.height/3)/2)];
    lblShowBest.font=[UIFont fontWithName:@"Helvetica" size:18];
    lblShowBest.textColor=[UIColor purpleColor];
    lblShowBest.textAlignment=NSTextAlignmentCenter;
    lblShowBest.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblShowBest];
    
    lblShowTotal=[[UILabel alloc] initWithFrame:CGRectMake(VIEW_FRAME.size.width/2,lblShowBest.frame.origin.y,VIEW_FRAME.size.width/2,(VIEW_FRAME.size.height/3)/2)];
    lblShowTotal.font=[UIFont fontWithName:@"Helvetica" size:18];
    lblShowTotal.textColor=[UIColor purpleColor];
    lblShowTotal.textAlignment=NSTextAlignmentCenter;
    lblShowTotal.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblShowTotal];
    
    lblShowNumberOfFiveStar=[[UILabel alloc] initWithFrame:CGRectMake(0,lblShowBest.frame.origin.y+lblShowBest.frame.size.height,VIEW_FRAME.size.width,(VIEW_FRAME.size.height/3)/2)];
    lblShowNumberOfFiveStar.font=[UIFont fontWithName:@"Helvetica" size:16];
    lblShowNumberOfFiveStar.textColor=[UIColor purpleColor];
    lblShowNumberOfFiveStar.textAlignment=NSTextAlignmentCenter;
    lblShowNumberOfFiveStar.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lblShowNumberOfFiveStar];
    
    
    timer = [[TimerLabel alloc] initWithLabel:lblShowTimer andTimerType:TimerLabelTypeStopWatch];
    timer.timeFormat = @"ss : SS";
    
    
    UILabel *lblTarget=[[UILabel alloc] initWithFrame:CGRectMake(0,2*(VIEW_FRAME.size.height/3),VIEW_FRAME.size.width,30)];
    
    lblTarget.font=[UIFont fontWithName:@"Helvetica" size:20];
    lblTarget.textColor=[UIColor lightGrayColor];
    lblTarget.textAlignment=NSTextAlignmentLeft;
    lblTarget.text=@"Stop me here";
    lblTarget.backgroundColor=[UIColor clearColor];
    lblTarget.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblTarget];
    
    lblShowTarget=[[UILabel alloc] initWithFrame:CGRectMake(0,lblTarget.frame.origin.y+20,VIEW_FRAME.size.width,80)];
    lblShowTarget.font=[UIFont fontWithName:@"DBLCDTempBlack" size:50];
    lblShowTarget.textColor=[UIColor cyanColor];
    lblShowTarget.backgroundColor=[UIColor clearColor];
    lblShowTarget.textAlignment=NSTextAlignmentCenter;
    lblShowTarget.text=@"";
    [self.view addSubview:lblShowTarget];
    
    viewResult = [[UIView alloc]init];//WithFrame:CGRectMake(VIEW_FRAME.origin.x,VIEW_FRAME.origin.y , VIEW_FRAME.size.width, VIEW_FRAME.size.height)];
    viewResult.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:viewResult];
    
    [viewResult setHidden:TRUE];

    [self loadScoresFromDB];
}
-(void)loadScoresFromDB
{
    lblShowBest.text=[NSString stringWithFormat:@"Best :%@",[self getDBValueForThisKey:@"BEST"]];
        lblShowTotal.text=[NSString stringWithFormat:@"Total :%@",[self getDBValueForThisKey:@"TOTAL"]];
        lblShowNumberOfFiveStar.text=[NSString stringWithFormat:@"5 stars :%@",[self getDBValueForThisKey:@"FIVESTAR"]];
}
-(void)performViewClick
{
    isStarted = !isStarted;

    if(isStarted)
        [self proceedWithStart];
    else
        [self proceedWithStop];
}
-(void)timerLabel:(TimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{

}
-(void)proceedWithStart
{
    if(viewResult.frame.size.width>0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        
        [viewResult.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        viewResult.frame = CGRectMake(VIEW_FRAME.size.width/2, VIEW_FRAME.size.height/2, 0, 0);
        
        [UIView commitAnimations];
    }
    
    [self stopSnowFall];
    
    lblShowTarget.text = [NSString stringWithFormat:@"%02d : %02d", [self getRandomNumberBetween:0 to:10],[self getRandomNumberBetween:0 to:100]];
    
    [timer reset];
    [timer start];
}
-(void)proceedWithStop
{
    [timer pause];
    
    [self showResultWindow];
}
-(void)proceedWithPlayAgain
{
    isStarted = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];

   [viewResult.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    viewResult.frame = CGRectMake(VIEW_FRAME.size.width/2, VIEW_FRAME.size.height/2, 0, 0);
    
    [UIView commitAnimations];
    
    [self proceedWithStart];
    //[viewResult setHidden:TRUE];
}
-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);//[NSString stringWithFormat:@"%d",(int)from + arc4random() % (to-from+1)];
}
- (void)showResultWindow
{
    viewResult.frame = CGRectMake(VIEW_FRAME.origin.x,VIEW_FRAME.origin.y+(VIEW_FRAME.size.height/3) , VIEW_FRAME.size.width, VIEW_FRAME.size.height/3);
    [viewResult setHidden:FALSE];
    
    UILabel *lblShowStarPoint=[[UILabel alloc] initWithFrame:CGRectMake((viewResult.frame.size.width/2)-60,(viewResult.frame.size.height/2)-60,120,120)];
    lblShowStarPoint.font=[UIFont fontWithName:@"Helvetica-Bold" size:70];
    lblShowStarPoint.textColor=[UIColor blackColor];
    lblShowStarPoint.numberOfLines=0;
    lblShowStarPoint.textAlignment=NSTextAlignmentLeft;
    lblShowStarPoint.backgroundColor=[UIColor purpleColor];
    lblShowStarPoint.textAlignment=NSTextAlignmentCenter;
    [viewResult addSubview:lblShowStarPoint];
    
    btnTryAgain=[UIButton buttonWithType:UIButtonTypeCustom];
    btnTryAgain.frame=CGRectMake((viewResult.frame.size.width/2)-60,viewResult.frame.size.height-80,120,60);
    [btnTryAgain setTitle:@"Play Again" forState:UIControlStateNormal];
    [btnTryAgain setTitle:@"Play Again" forState:UIControlStateSelected];
    [btnTryAgain addTarget:self action:@selector(proceedWithPlayAgain) forControlEvents:UIControlEventTouchUpInside];
    [btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTryAgain.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnTryAgain.backgroundColor=[UIColor orangeColor];
    btnTryAgain.titleLabel.backgroundColor=[UIColor clearColor];
    btnTryAgain.imageView.backgroundColor=[UIColor clearColor];
    
    //[viewResult addSubview:btnTryAgain];
    

    CGRect f = viewResult.frame;
    
    CGRect f1 = CGRectMake(CGRectGetMinX(f), 0, f.size.width/2, f.size.height);//f.origin.y
    CGRect f2 = CGRectMake(CGRectGetMidX(f), 0, f.size.width/2, f.size.height);//f.origin.y
    
    UIView *viewLeft = [[UIView alloc] initWithFrame:f1];
    viewLeft.backgroundColor = [UIColor blackColor];
    [viewResult addSubview:viewLeft];
    
    UILabel *lblShowDifference=[[UILabel alloc] initWithFrame:CGRectMake(85,20,viewLeft.frame.size.width-90,viewLeft.frame.size.height-40)];
    lblShowDifference.font=[UIFont fontWithName:@"Helvetica" size:15];
    lblShowDifference.textColor=[UIColor whiteColor];
    lblShowDifference.numberOfLines=0;
    lblShowDifference.textAlignment=NSTextAlignmentLeft;
    lblShowDifference.backgroundColor=[UIColor purpleColor];
    lblShowDifference.textAlignment=NSTextAlignmentCenter;
    [viewLeft addSubview:lblShowDifference];
    
    UIView *viewRight = [[UIView alloc] initWithFrame:f2];
    viewRight.backgroundColor = [UIColor blackColor];
    [viewResult addSubview:viewRight];
    
    UILabel *lblShowStarComment=[[UILabel alloc] initWithFrame:CGRectMake(5,20,viewRight.frame.size.width-90,viewRight.frame.size.height-40)];
    lblShowStarComment.font=[UIFont fontWithName:@"Helvetica" size:15];
    lblShowStarComment.textColor=[UIColor whiteColor];
    lblShowStarComment.numberOfLines=0;
    lblShowStarComment.textAlignment=NSTextAlignmentLeft;
    lblShowStarComment.backgroundColor=[UIColor purpleColor];
    lblShowStarComment.textAlignment=NSTextAlignmentCenter;
    [viewRight addSubview:lblShowStarComment];
    
    f1.origin.x -= 80;
    f2.origin.x += 80;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    viewLeft.frame = f1;
    viewRight.frame = f2;
    
    [UIView commitAnimations];
    
    [self setCalculatedResultDifferenceInOutput];
    
    if(output==ZERO_ACHEIVEMENT)
           lblShowDifference.text =@"You have missed a lot.\nPlease try again";
       else if(output==0)
           lblShowDifference.text =@"You deserved this 5 star.\nThat's awesome Keep going.";
           else
   lblShowDifference.text =[NSString stringWithFormat:@"Missed : \n%ld milli seconds",output];
    
    if(output==4)
    {
        lblShowStarPoint.text=@"*5*";
        
        [self setDBValueForThisKey:@"FIVESTAR" andValue:[NSString stringWithFormat:@"%d",[[self getDBValueForThisKey:@"FIVESTAR"] integerValue] + 1]];
    }
    else if(output<10)
    {
        lblShowStarPoint.text=@"*4*";
    }
    else if(output<20)
    {
        lblShowStarPoint.text=@"*3*";
    }
    else if(output<30)
    {
        lblShowStarPoint.text=@"*2*";
    }
    else if(output<40)
    {
        lblShowStarPoint.text=@"*1*";
    }
    else
    {
        lblShowStarPoint.text=@"*0*";
    }
    int curScore =(1000-output)/10;
    lblShowStarComment.text =[NSString stringWithFormat:@"Score :\n%d",curScore>0?curScore:0];
    
    [self startSnowFall];
    
    //Save Score in DB
    if([[self getDBValueForThisKey:@"BEST"] integerValue] < curScore)
    [self setDBValueForThisKey:@"BEST" andValue:[NSString stringWithFormat:@"%d",curScore]];
    
    [self setDBValueForThisKey:@"TOTAL" andValue:[NSString stringWithFormat:@"%d",[[self getDBValueForThisKey:@"TOTAL"] integerValue] + curScore]];
    
    [self loadScoresFromDB];
    
}
-(void)startSnowFall
{
    snowView = [[SnowFallView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width*2, self.view.frame.size.height*2)];
    [self.view addSubview:snowView];
    
    snowView.flakesCount = 100;
    [snowView letItSnow];
}
-(void)stopSnowFall
{
    if([snowView isDescendantOfView:self.view])
    {
        [snowView removeFromSuperview];
    }
}
-(void)setCalculatedResultDifferenceInOutput
{
    long secTarget=[[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:0] integerValue];
    long millisecTarget = [[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:1] integerValue];
    
    long secStopped=[[[lblShowTimer.text componentsSeparatedByString:@" : "] objectAtIndex:0] integerValue];
    long millisecStopped = [[[lblShowTimer.text componentsSeparatedByString:@" : "] objectAtIndex:1] integerValue];
    
    NSLog(@"Target label %@",lblShowTarget.text);
        NSLog(@"Stopped label %@",lblShowTimer.text);

            NSLog(@"Stopped label label %@",[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:0]);
            NSLog(@"Stopped label label %@",[[lblShowTarget.text componentsSeparatedByString:@" : "] objectAtIndex:0]);
    
    
    if(secTarget==secStopped)
    {
        output = millisecTarget>millisecStopped?millisecTarget-millisecStopped:millisecStopped-millisecTarget;
    }
    else if(secTarget < secStopped)
    {
        if((secStopped-secTarget)==1)
        {
            output = 333;
        }
        else
            output=ZERO_ACHEIVEMENT;
    }
    else if(secTarget > secStopped)
    {
        if((secTarget-secStopped)==1)
        {
                        output = 444;
        }
        else
            output=ZERO_ACHEIVEMENT;
    }
    else
        output=ZERO_ACHEIVEMENT;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*)getDBValueForThisKey:(NSString*)strKey
{

if([[NSUserDefaults standardUserDefaults] stringForKey:strKey] !=nil && ![[[NSUserDefaults standardUserDefaults] stringForKey:strKey] isEqualToString:@"null"])
{
    NSLog(@"%@ ::: %@",strKey,[[NSUserDefaults standardUserDefaults] stringForKey:strKey]);
        return [[NSUserDefaults standardUserDefaults] stringForKey:strKey];
}
    else
        return @"0";
}
-(void)setDBValueForThisKey:(NSString*)strKey andValue:(NSString*)strVal
{
    [[NSUserDefaults standardUserDefaults] setObject:strVal forKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
//- (void)timerTick:(NSTimer *)timer {
//    currentTime += 1 ;
//    [self populateLabelwithTime:currentTime];
//    
//}
//- (void)populateLabelwithTime:(int)milliseconds
//{
//    int seconds = milliseconds/100;
//    int minutes = seconds / 60;
//    int hours = minutes / 60;
//    
//    seconds -= minutes * 60;
//    minutes -= hours * 60;
//    
//    //    NSString * result = [NSString stringWithFormat:@"%@%02d:%02d:%02d:%02d", (milliseconds<0?@"-":@""), hours, minutes, seconds,milliseconds%1000];
//    
//    NSString * result = [NSString stringWithFormat:@"%02d : %02d", seconds,milliseconds%100];
//    lblShowTimer.text = result;
//    
//    if([lblShowTarget.text isEqualToString:@""])
//    {
//        lblShowTarget.text = [NSString stringWithFormat:@"%02d : %02d", [self getRandomNumberBetween:0 to:5],[self getRandomNumberBetween:0 to:100]];
//    }
//    
//}

@end
