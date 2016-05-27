#import "ownioscam.h"
#import "ownioscamController.h"

@implementation ownioscamController

-(BOOL)     shouldAutorotate
{
    return NO;
}
// Entry point method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Instantiate the UIImagePickerController instance
        self.picker = [[UIImagePickerController alloc] init];
         self.picker.delegate = self;
            self.picker.modalPresentationStyle = UIModalPresentationCustom;
        // Configure the UIImagePickerController instance
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.picker.showsCameraControls = NO;
         self.picker.toolbarHidden=YES;
        
        // Make us the delegate for the UIImagePickerController
       
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
      NSString * imgarray1 = [defaults objectForKey:@"k2"];
    
    imgarray = [imgarray stringByAppendingString:@";;" ];
    imgarray = [imgarray stringByAppendingString:imgarray1 ];
    
    
    [self.plugin capturedImageWithPath:imgarray];
    [defaults removeObjectForKey:@"k1"];
      [defaults removeObjectForKey:@"k2"];

   
}
-(NSString*)generateRandomString:(int)num {
    NSMutableString* string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// Delegate method.  UIImagePickerController will call this method as soon as the image captured above is ready to be processed.  This is also like an event callback in JavaScript.
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get a reference to the captured image
     UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.ImageView.image = image;
    
     NSString* string = [self generateRandomString:5];
      NSString* compresed_string = [self generateRandomString:5];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString * s1 = @".jpg";
    string = [string stringByAppendingString:s1 ];
     compresed_string = [compresed_string stringByAppendingString:s1 ];
    NSString* filename = string;
     NSString* compressed_filename = compresed_string;
    
    
    NSString* imagePath = [documentsDirectory stringByAppendingPathComponent:filename];
     NSString* compressed_imagePath = [documentsDirectory stringByAppendingPathComponent:compressed_filename];
    
    // Get the image data (blocking; around 1 second)
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    [imageData writeToFile:imagePath atomically:YES];
    
    
    UIImage *newImage=image;
    CGSize size=CGSizeMake(1000,1000);
    newImage=[self resizeImage:newImage newSize:size];
    
    
    NSData* compressed_imageData = UIImageJPEGRepresentation(newImage, 1.0);
    [compressed_imageData writeToFile:compressed_imagePath atomically:YES];
    
    
    NSString * str5 = [defaults objectForKey:@"k1"];
    //UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    // UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    if([str5 length] == 0)
    {
        [defaults setObject:imagePath forKey:@"k1"];
        
        [defaults setObject:compressed_imagePath forKey:@"k2"];
        
        
    }
    if([str5 length] != 0)
    {
        NSString * _sbuffer =   [defaults objectForKey:@"k1"];
        _sbuffer = [_sbuffer stringByAppendingString:@","];
        
        _sbuffer = [_sbuffer stringByAppendingString:imagePath];
        [defaults setObject:_sbuffer forKey:@"k1"];
        
        
        NSString * _sbufferc =   [defaults objectForKey:@"k2"];
        _sbufferc = [_sbufferc stringByAppendingString:@","];
        
        _sbufferc = [_sbufferc stringByAppendingString:compressed_imagePath];
        [defaults setObject:_sbufferc forKey:@"k2"];
        
        
        
    }
}

@end
