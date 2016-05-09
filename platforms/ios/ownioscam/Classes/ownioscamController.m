#import "ownioscam.h"
#import "ownioscamController.h"

@implementation ownioscamController

// Entry point method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Instantiate the UIImagePickerController instance
        self.picker = [[UIImagePickerController alloc] init];
        
        // Configure the UIImagePickerController instance
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.picker.showsCameraControls = NO;
        
        // Make us the delegate for the UIImagePickerController
        self.picker.delegate = self;
     //   self.overlay = [[ownioscamController alloc] init @"ownioscam" bundle:nil]
                        
        // Set the frames to be full screen
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        self.view.frame = screenFrame;
        self.picker.view.frame = screenFrame;
        
        // Set this VC's view as the overlay view for the UIImagePickerController
        self.picker.cameraOverlayView = self.view;
    }
    return self;
}

// Action method.  This is like an event callback in JavaScript.
-(IBAction) takePhotoButtonPressed:(id)sender forEvent:(UIEvent*)event {
    // Call the takePicture method on the UIImagePickerController to capture the image.
    [self.picker takePicture];
}

-(IBAction) cancel:(id)sender forEvent:(UIEvent*)event {
    // Call the takePicture method on the UIImagePickerController to capture the image.
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString * imgarray = [defaults objectForKey:@"k1"];
    
    [self.plugin capturedImageWithPath:imgarray];
    [defaults removeObjectForKey:@"k1"];
   
}
-(NSString*)generateRandomString:(int)num {
    NSMutableString* string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}

// Delegate method.  UIImagePickerController will call this method as soon as the image captured above is ready to be processed.  This is also like an event callback in JavaScript.
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get a reference to the captured image
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.ImageView.image = image;
    
     NSString* string = [self generateRandomString:5];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString * s1 = @".png";
    string = [string stringByAppendingString:s1 ];
    NSString* filename = string;
    NSString* imagePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    // Get the image data (blocking; around 1 second)
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    [imageData writeToFile:imagePath atomically:YES];
    NSString * str5 = [defaults objectForKey:@"k1"];
    //UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    // UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    if([str5 length] == 0)
    {
        [defaults setObject:imagePath forKey:@"k1"];
        
        
    }
    if([str5 length] != 0)
    {
        NSString * _sbuffer =   [defaults objectForKey:@"k1"];
        _sbuffer = [_sbuffer stringByAppendingString:@","];
        
        _sbuffer = [_sbuffer stringByAppendingString:imagePath];
        [defaults setObject:_sbuffer forKey:@"k1"];
        
        
        
    }
}

@end
