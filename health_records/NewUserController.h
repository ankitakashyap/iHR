//
//  Name of the file: NewUserController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File gets the profile details from the user. And except firstname and lastname, other fields can be NULL

//  Created by Dhivya Narayanan on 12/2/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#ifndef HealthRecords_NewUserController_h
#define HealthRecords_NewUserController_h

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "CreateAuthController.h"

@interface NewUserController : UIViewController<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate>{
   
}
//IBoutlets and IBActions to the textfields and buttons
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *dobTxt;
@property (weak, nonatomic) IBOutlet UITextField *ageTxt;
@property (weak, nonatomic) IBOutlet UITextField *genderTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet UITextField *bloodGroupTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *addressTxt;
@property (weak, nonatomic) IBOutlet UITextField *cityTxt;
@property (weak, nonatomic) IBOutlet UITextField *stateTxt;
@property (weak, nonatomic) IBOutlet UITextField *countryTxt;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTxt;
- (IBAction)submitEntry:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *ext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(BOOL)isEmpty;
@end


#endif
