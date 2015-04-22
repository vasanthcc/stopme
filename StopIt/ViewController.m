//
//  ViewController.m
//  StopIt
//
//  Created by Vasanth Ravichandran on 22/04/15.
//  Copyright (c) 2015 msf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UILabel *lblShowTarget,*lblShowTimer;
    UIButton *btnStart,*btnStop;
    NSTimer *theTimer;
int currentTime;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
    currentTime = 0;//270000000;

}
-(void)createView
{
  lblShowTarget=[[UILabel alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-100,self.view.frame.size.width,80)];
    
    lblShowTarget.font=[UIFont fontWithName:@"Helvetica" size:50];
    lblShowTarget.textColor=[UIColor darkGrayColor];
    lblShowTarget.textAlignment=NSTextAlignmentLeft;
    lblShowTarget.backgroundColor=[UIColor whiteColor];
    lblShowTarget.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblShowTarget];
    
    lblShowTimer=[[UILabel alloc] initWithFrame:CGRectMake(0,50,self.view.frame.size.width,100)];
    
    lblShowTimer.font=[UIFont fontWithName:@"Helvetica" size:80];
    lblShowTimer.textColor=[UIColor darkGrayColor];
    lblShowTimer.textAlignment=NSTextAlignmentLeft;
    lblShowTimer.backgroundColor=[UIColor whiteColor];
    lblShowTimer.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lblShowTimer];
    
    
    btnStart=[UIButton buttonWithType:UIButtonTypeCustom];
    btnStart.frame=CGRectMake(10,self.view.frame.size.height-100,160,80);
    [btnStart setTitle:@"START" forState:UIControlStateNormal];
    [btnStart setTitle:@"START" forState:UIControlStateSelected];
    [btnStart addTarget:self action:@selector(proceedWithStart) forControlEvents:UIControlEventTouchUpInside];
    [btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnStart.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnStart.backgroundColor=[UIColor orangeColor];
    btnStart.titleLabel.backgroundColor=[UIColor clearColor];
    btnStart.imageView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:btnStart];
    
    
    btnStop=[UIButton buttonWithType:UIButtonTypeCustom ];
    btnStop.frame=CGRectMake(self.view.frame.size.width-btnStart.frame.size.width-20,btnStart.frame.origin.y,btnStart.frame.size.width,80);
    [btnStop setTitle:@"STOP" forState:UIControlStateNormal];
    [btnStop setTitle:@"STOP" forState:UIControlStateSelected];
    [btnStop addTarget:self action:@selector(proceedWithStop) forControlEvents:UIControlEventTouchUpInside];
    [btnStop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnStop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnStop.backgroundColor=[UIColor orangeColor];
    btnStop.titleLabel.backgroundColor=[UIColor clearColor];
    btnStop.imageView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:btnStop];
    
            lblShowTarget.text=@"";
}
-(void)proceedWithStart
{
    theTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
}
-(void)proceedWithStop
{
    if ([theTimer isValid])
    {
        [theTimer invalidate];
    }
}
- (void)timerTick:(NSTimer *)timer {
    currentTime += 10 ;
    [self populateLabelwithTime:currentTime];
}
- (void)populateLabelwithTime:(int)milliseconds
{
    
    int seconds = milliseconds/1000;
    int minutes = seconds / 60;
    int hours = minutes / 60;
    
    seconds -= minutes * 60;
    minutes -= hours * 60;
    
//    NSString * result = [NSString stringWithFormat:@"%@%02d:%02d:%02d:%02d", (milliseconds<0?@"-":@""), hours, minutes, seconds,milliseconds%1000];
    
        NSString * result = [NSString stringWithFormat:@"%02d : %02d", seconds,milliseconds%1000];
    lblShowTimer.text = result;
    
    if([lblShowTarget.text isEqualToString:@""])
    {
        lblShowTarget.text = [NSString stringWithFormat:@"%2@ : %2@", [self getRandomNumberBetween:0 to:60],[self getRandomNumberBetween:0 to:1000]];
    }
    
}
-(NSString*)getRandomNumberBetween:(int)from to:(int)to {
    
    return [NSString stringWithFormat:@"%d",(int)from + arc4random() % (to-from+1)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
