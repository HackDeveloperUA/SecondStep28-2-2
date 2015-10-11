
#import "ViewController.h"
#import "SCLAlertView.h"


@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldsArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lableArray;
@end

NSString *kSuccessTitle = @"Отлично";
NSString *kErrorTitle = @"Connection error";
NSString *kNoticeTitle = @"Notice";
NSString *kWarningTitle = @"Warning";
NSString *kInfoTitle = @"Info";
NSString *kSubtitle = @"Запрос отправлен на сервер";
NSString *kButtonTitle = @"Done";
NSString *kAttributeTitle = @"Attributed string operation successfully completed.";



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.scroller setContentSize:CGSizeMake(320, 1000)];
    
    [[self.textFieldsArray objectAtIndex:0] becomeFirstResponder];
    [self.scroller layoutIfNeeded];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (![textField isEqual:[self.textFieldsArray objectAtIndex:[self.textFieldsArray count]-1]]) {
        
        NSInteger index = [self.textFieldsArray indexOfObject:textField];
        [[self.textFieldsArray objectAtIndex:index+1] becomeFirstResponder];

    } else {
        [textField resignFirstResponder];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    

    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger index = [self.textFieldsArray indexOfObject:textField];
    UILabel* lab =  [self.lableArray objectAtIndex:index];
    
    // TextField - Age
    if (index == 4) {
        BOOL var =[self checkInputAge:textField shouldChangeCharactersInRange:range replacementString:string];
        return var;
    }
    
    // TextField - Phone
    if (index == 5) {
      [self checkInputPhoneNumber:textField shouldChangeCharactersInRange:range replacementString:string];
      return NO;
    }
    
    
    //TextField - Email
    if (index == 6) {
         BOOL var = [self checkInputEmail:textField shouldChangeCharactersInRange:range replacementString:string];
         return var;
     }
    
    lab.text = newString;
    return YES;
}


#pragma mark - Hide Keyboard Methods

-(void) hideKeyBoard {
    
    for (UITextField* field in self.textFieldsArray) {
        
        if ([field isFirstResponder]) {
            [field resignFirstResponder];
        }
    }
}


-(void) handleTap:(UITapGestureRecognizer*) tap {
    
      [self hideKeyBoard];
}



#pragma mark - Show Success

- (IBAction)showSuccess:(id)sender
{
    [self hideKeyBoard];
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];

    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    [alert showSuccess:kSuccessTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}


#pragma mark - Check Input Phone Number


-(NSString*) checkInputPhoneNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 3;
    
    
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validComponents componentsJoinedByString:@""];
    
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
        return NO;
    }
    NSMutableString* resultString = [NSMutableString string];
    NSInteger        localNumberLength = MIN([newString length], localNumberMaxLength);
    
    if (localNumberLength > 0) {
        
        NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
        [resultString appendString:number];
        if ([resultString length]>3) {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    
    if ([newString length] > localNumberMaxLength) {
        
        NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
        NSRange   areaRange =  NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        NSString* area = [newString substringWithRange:areaRange];
        area = [NSString stringWithFormat:@"(%@)",area];
        [resultString insertString:area atIndex:0];
    }
    
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
        
        NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        NSRange   countryCodeRange =  NSMakeRange(0,countryCodeLength);
        NSString* countryCode = [newString substringWithRange:countryCodeRange];
        countryCode = [NSString stringWithFormat:@"+%@ ",countryCode];
        [resultString insertString:countryCode atIndex:0];
    }
    UILabel* lab =  [self.lableArray objectAtIndex:5];
    lab.text = textField.text = resultString;

    return  NO;
}

#pragma mark - Check Input Age

-(BOOL) checkInputAge:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
   
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([components count] > 1) {
        return NO;
    }
    if ([newString length] > 3) {
        return NO;
    }
    
    NSInteger age = [newString intValue];
    if (age >= 110) {
        return NO;
    }
    UILabel* lab =  [self.lableArray objectAtIndex:4];
    lab.text = textField.text = newString;
    
    return NO;
}

#pragma mark - Check Input Email
-(BOOL) checkInputEmail:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {


    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    NSMutableCharacterSet *workingSet = [[NSCharacterSet uppercaseLetterCharacterSet] mutableCopy];
    [workingSet addCharactersInString: @"abcdefghijklmnopqrstuvwxyz1234567890@."];
    NSCharacterSet *finalCharacterSet = [[workingSet copy]invertedSet];
    
    NSArray* components = [string componentsSeparatedByCharactersInSet:finalCharacterSet];
    if ([components count] > 1) {
        return NO;
    }
    
    NSRange rangeSearch = NSMakeRange(0, [newString length]);
    NSInteger counter = 0;
    
    while (YES) {
        
        NSRange range = [newString rangeOfString:@"@"options:0 range:rangeSearch];
        
        if (range.location != NSNotFound) {
            NSInteger index = range.location + range.length;
            rangeSearch.location = index;
            rangeSearch.length = [newString length] - index;
            counter++;
        }
        else break;
    }
    
    if (counter > 1) {
        return NO;
    }
    UILabel* lab =  [self.lableArray objectAtIndex:6];
    lab.text = textField.text = newString;
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
