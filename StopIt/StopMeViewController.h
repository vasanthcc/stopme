//
//  ViewController.h
//  StopIt
//
//  Created by Vasanth Ravichandran on 22/04/15.
//  Copyright (c) 2015 msf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    kLEVEL0,
    kLEVEL1,
    kLEVEL2,
    kLEVEL3
}Level;
@interface StopMeViewController : UIViewController
@property Level selectedLevel;
@end

