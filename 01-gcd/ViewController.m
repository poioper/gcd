//
//  ViewController.m
//  01-delay
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 xiaofeng. All rights reserved.
//

#import "ViewController.h"
#import "ImageDownloader.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong) ImageDownloader *downloader;
@property (strong,nonatomic) UIImage *image1;
@property (strong,nonatomic) UIImage *image2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //queue group
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block UIImage *image1 = nil;
    dispatch_group_async(group, queue, ^{
        //1st image
        NSURL *url1 = [NSURL URLWithString:@"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS8d3AhaqRyX5q5oKEU6fDk6LCm_2oWG5jSDZQ-eg82JI0rbfJ7mA"];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        image1 = [UIImage imageWithData:data1];
    });
    
    __block UIImage *image2 = nil;
    dispatch_group_async(group, queue, ^{
        //2nd image
        NSURL *url2 = [NSURL URLWithString:@"https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQ_vylFEQYShNTFU81BVwVcl1uEBtXyDDdzkjjmkBZX88q6mO8y"];
        NSData *data2 = [NSData dataWithContentsOfURL:url2];
        image2 = [UIImage imageWithData:data2];
    });
    
    //merge pictures(will execute code in block of notify function after tasks in group finished)
    dispatch_group_notify(group, queue, ^{
        //begin imagecontext
        UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
        
        //draw 1st image
        [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
        
        //draw 2nd image
        [image2 drawInRect:CGRectMake(0, image1.size.height-image2.size.height*.5, image2.size.width*.5,image2.size.height*.5)];
        
        //get image in context
        UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //end context
        UIGraphicsEndImageContext();
        
        //come back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = fullImage;
        });
    });
}

-(void)mergePic2{
    //asynchronize downloading pictures
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //1st image
        NSURL *url1 = [NSURL URLWithString:@"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS8d3AhaqRyX5q5oKEU6fDk6LCm_2oWG5jSDZQ-eg82JI0rbfJ7mA"];
        NSData *data1 = [NSData dataWithContentsOfURL:url1];
        self.image1 = [UIImage imageWithData:data1];
        [self merge];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //2nd image
        NSURL *url2 = [NSURL URLWithString:@"https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQ_vylFEQYShNTFU81BVwVcl1uEBtXyDDdzkjjmkBZX88q6mO8y"];
        NSData *data2 = [NSData dataWithContentsOfURL:url2];
        self.image2 = [UIImage imageWithData:data2];
        [self merge];
    });
}

-(void)merge{
    if (self.image1 == nil || self.image2 == nil) {
        return;
    }else{
        UIGraphicsBeginImageContextWithOptions(self.image1.size, NO, 0.0);
        
        //draw 1st image
        [self.image1 drawInRect:CGRectMake(0, 0, self.image1.size.width, self.image1.size.height)];
        
        //draw 2nd image
        [self.image2 drawInRect:CGRectMake(0, self.image1.size.height-self.image2.size.height*.5, self.image2.size.width*.5,self.image2.size.height*.5)];
        
        //get image in context
        UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //end context
        UIGraphicsEndImageContext();
        
        //come back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = fullImage;
        });
        
    }
}

-(void) mergePic1{
    //1st image
    NSURL *url1 = [NSURL URLWithString:@"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS8d3AhaqRyX5q5oKEU6fDk6LCm_2oWG5jSDZQ-eg82JI0rbfJ7mA"];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    UIImage *image1 = [UIImage imageWithData:data1];
    
    //2nd image
    NSURL *url2 = [NSURL URLWithString:@"https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQ_vylFEQYShNTFU81BVwVcl1uEBtXyDDdzkjjmkBZX88q6mO8y"];
    NSData *data2 = [NSData dataWithContentsOfURL:url2];
    UIImage *image2 = [UIImage imageWithData:data2];
    
    //merge images
    //begin imagecontext
    UIGraphicsBeginImageContextWithOptions(image1.size, NO, 0.0);
    
    //draw 1st image
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    //draw 2nd image
    [image2 drawInRect:CGRectMake(0, image1.size.height-image2.size.height*.5, image2.size.width*.5,image2.size.height*.5)];
    
    //get image in context
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //end context
    UIGraphicsEndImageContext();
    
    //come back to main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = fullImage;
    });
}

/**
 
 -------------------------------------how to delay execute events--------------------------------------------
 
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
 {
 NSLog(@"-----touchesBegan1-------");
 [self delay2];
 NSLog(@"-----touchesBegan2-------");
 
 }
 
 -(void)delay1{
 [self performSelector:@selector(download:) withObject:@"http://www.google.com/image57888.jpg" afterDelay:2];
 }
 
 -(void)delay2{
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
 NSLog(@"------task------%@--",[NSThread currentThread]);
 });
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 NSLog(@"------task------%@--",[NSThread currentThread]);
 });
 }
 
 -(void)download:(NSString *)url
 {
 NSLog(@"download--------%@-----%@",url,[NSThread currentThread]);
 }
 */
/**
 ----------------------------execute code only once----------------------------
 
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
 {
 NSLog(@"touchesBegan");
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 NSLog(@"------once-------");
 ImageDownloader *down = [[ImageDownloader alloc]init];
 self.downloader = down;
 [self.downloader download];
 });
 }
 */

@end
