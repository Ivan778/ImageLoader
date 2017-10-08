//
//  SecondScreenViewController.m
//  ImageLoader
//
//  Created by Иван on 06.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "SecondScreenViewController.h"

@interface SecondScreenViewController ()

@end

@implementation SecondScreenViewController

{
    NSMutableArray *images;
    dispatch_group_t group;
}

// Загрузчик изображений
- (void)imageLoader:(NSString*)UR {
    // Чистим кэш (по заданию нужно грузить картинки из интернета, а после первой загрузки сохранится кэш и дальнейшее тестирование приложения не получится)
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // Формируем ссылку и запрос
    NSURL *url = [NSURL URLWithString: UR];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Создаём NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    // Уведомляем dispatch_group о новом задании
    dispatch_group_enter(group);
    // Формируем задание и вешаем обработчик события по завершению
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSLog(@"Yeah");
            // Добавляем в массив новую картинку
            [images addObject:[[UIImage alloc] initWithData:data]];
            
            // Уведомляем dispatch_group о завершении задания
            dispatch_group_leave(group);
        } else {
            NSLog(@"%@", error);
            
            // Уведомляем dispatch_group о завершении задания
            dispatch_group_leave(group);
        }
    }];
    
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_ActivityIndicator setHidesWhenStopped:true];
    [_ActivityIndicator startAnimating];
    
    // Массив с изображениями, который позднее будет передаваться в третий экран
    images = [[NSMutableArray alloc] init];
    
    // Инициализируем dispatch_group_t
    group = dispatch_group_create();
    
    // Чтобы UI обновлялся, запускаем процесс загрузки изображений в фоне
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        // Загружаем изображения
        [self imageLoader:@"http://www.guitarworld.com/sites/default/files/public/styles/article_detail_featured__622x439_/public/featured-image/gibson-sg-five-things-you-dont-know.jpg"];
        [self imageLoader:@"http://images.gibson.com.s3.amazonaws.com/Lifestyle/Spanish/20151216_LP-Tomato_feature.jpg"];
        [self imageLoader:@"https://media.sweetwater.com/api/i/ha-d96a56cb13852650__q-85__hmac-658d329eea70b6c90989145034731b0368289c4d/images/items/1800/DSFR17VSCH-xlarge.jpg"];
        
        // Вызовется, когда все задания по загрузке будут выполнены
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSLog(@"finally!");
            
            // Выводим сообщение и загрузке в потоке UI
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                // Создаём alert для оповещения пользователя о загрузке изображений
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Download completed" message:[NSString stringWithFormat:@"Downloaded %lu photo(s)", (unsigned long)[images count]] preferredStyle:UIAlertControllerStyleAlert];
                
                // Обработка нажатия на клавишу
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [_ActivityIndicator stopAnimating];
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    
                    [self performSegueWithIdentifier:@"ShowImages" sender:self];
                    
                }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            });
        });
        
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowImages"]){
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        TableViewController *controller = (TableViewController *)navController.topViewController;
        controller.images = images;
    }
}


@end
