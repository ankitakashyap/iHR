//
//  NewConditions.h
//  HealthRecords
//
//  Created by Dhivya Narayanan on 12/8/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#ifndef HealthRecords_NewConditions_h
#define HealthRecords_NewConditions_h

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface NewConditions : UIViewController{
    sqlite3 *db;
}
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIButton *calendarBt;
//- (IBAction)calendarAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *radioBt;
//- (IBAction)radioBtSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *conditions;
@property (weak, nonatomic) IBOutlet UITextField *commentsField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)discard:(id)sender;

- (IBAction)add:(id)sender;
- (IBAction)refresh:(id)sender;


@property(nonatomic)NSString* itemUserName;
@property(nonatomic)NSString* itemConditions;
@property(nonatomic)NSString* itemComments;
@property(nonatomic)NSDate* itemDate;
@property(nonatomic)NSString* itemDatestr;
@property(nonatomic)NSString* curCondition;

-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

@end

#endif
