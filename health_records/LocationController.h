//
//  LocationController.h
//  HealthRecords
//
//  Created by Dhivya Narayanan on 12/6/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#ifndef HealthRecords_LocationController_h
#define HealthRecords_LocationController_h

@import UIKit;
@import CoreLocation;

@interface LocationController : UIViewController <CLLocationManagerDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>


/*@property (weak, nonatomic) IBOutlet UIImageView *displayedFlag;     //UIImageView - displaying a national flag
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;    //UIPickerView - holding the names of all the countries whose flags might be displayed
@property (weak, nonatomic) IBOutlet UITextField *displayResult;     //UITextField-user can enter his answer & the app can signal whether or not the answer is correct


-(IBAction)countryTxt:(id)sender;*/

@property(assign) double currentLatitude;
@property(assign) double currentLongitude;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTxt;
@property (weak, nonatomic) IBOutlet UISwitch *getCurLocation;
- (IBAction)getcurlocation:(id)sender;
- (IBAction)findHospital:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *milesaroundTxt;
@property (weak, nonatomic) IBOutlet UILabel *noofhospitalLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *listofHospitals;

@end

#endif
