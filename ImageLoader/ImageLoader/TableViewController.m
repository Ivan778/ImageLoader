//
//  TableViewController.m
//  ImageLoader
//
//  Created by Иван on 08.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self images] count];
}

- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:original];
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:cornerRadius] addClip];
    // Draw your image
    [original drawInRect:imageView.bounds];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageView.image;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = [cell viewWithTag:110];
    [label setText:[NSString stringWithFormat:@"Guitar image №%d", (int)[indexPath row] + 1]];
    
    // Изображение, которое нужно вставить в таблицу
    UIImage *im = [[self images] objectAtIndex:[indexPath row]];
    
    // Получаем доступ к таблице и добавляем туда изображение
    UIImageView *image = [cell viewWithTag:111];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [image setImage:[self imageWithRoundedCornersSize:70 usingImage:im]];
    
    return cell;
}


@end
