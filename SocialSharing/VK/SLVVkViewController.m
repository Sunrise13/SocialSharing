 //
//  SLVVkViewController.m
//  SocialSharing
//
//  Created by Sasha Gypsy on 19.08.14.
//  Copyright (c) 2014 Oleksiy. All rights reserved.
//

#import "SLVVkViewController.h"
#import "NSString+StringBetween.h"


@interface SLVVkViewController () <UIWebViewDelegate>

@property (copy, nonatomic) LoginCompletionBlock completionBlock;
@end

@implementation SLVVkViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) initWithBlock:(LoginCompletionBlock) completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([self.authView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound) {
        self.authView.hidden = YES;
        NSString *secret = [self.authView.request.URL.absoluteString getStringBetweenString:@"access_token" andString:@"&"]; //извлекаем из ответа token
        NSLog(@"%@", secret); //печатаем secret в консоль
    } else if ([self.authView.request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound) {
        self.authView.hidden = YES;
        NSLog(@"%@", self.authView.request.URL.absoluteString); //выводим ошибку
    } else {
         self.authView.hidden = NO; //показываем окно авторизации
    }
}




- (void) postToVk
{
   
    NSMutableString * st = [[NSMutableString alloc]initWithString: @"https://api.vk.com/method/wall.post?owner_id=13058851&message=blablabla&attachments=photo13058851_336538660&access_token=944fa3a2506339d0be211fb2985c72f8ae7affcebac18e433e5de4c923114393efdcb8b59056baf9af353"];
  //  [st appendString:[SLVRequestManager sharedManager].accessToken.token];
   
    NSURL * authUrl = [[NSURL alloc] initWithString:[st stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:authUrl];
    [self.authView loadRequest:request];
    
    
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.authView = webView;
    [self.view addSubview:self.authView];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
    [self.navigationItem setRightBarButtonItem:item];
    
    self.navigationItem.title = @"Login";
    
    NSURL * authUrl = [[NSURL alloc] initWithString:[@"https://oauth.vk.com/authorize?client_id=4514266&scope=139286&redirect_uri=hello.there&display=mobile&v= 5.24&response_type=token&revoke=1" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
   
    NSURLRequest *authRequest = [[NSURLRequest alloc] initWithURL:authUrl];
    self.authView.delegate = self;
    
    [self.authView loadRequest:authRequest];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //https://api.vk.com/method/'''METHOD_NAME'''?'''PARAMETERS'''&access_token='''ACCESS_TOKEN'''
    
    
    if ([[[request URL] host] isEqualToString:@"hello.there"])
    {
        NSLog(@"%@", request);
        SLVVkToken* token = [[SLVVkToken alloc] init];
        
        NSString* query = [[request URL] description];
        
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [values lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.userID = [values lastObject];
                }
            }
        }
        
        self.authView.delegate = nil;
        
        
        //[self postToVk];
        [self publishVK];
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        

        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        
        return NO;
    }
    return YES;
}


- (void) actionCancel:(UIBarButtonItem*) item {
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}


- (void) publishVK {
NSString * tempToken = @"944fa3a2506339d0be211fb2985c72f8ae7affcebac18e433e5de4c923114393efdcb8b59056baf9af353";

    /*
     
     Отправка изображения на стену пользователя происходит в несколько этапов:
     1. Запрос сервера ВКонтакте для загрузки нашего изображения (photos.getWallUploadServer)
     2. По полученной ссылке в ответе сервера отправляем изображение методом POST
     3. Получив в ответе hash, photo, server отправлем команду на сохранение фото на стене (photos.saveWallPhoto)
     4. Получив в ответе photo id делаем запрос на размещение на стене картинки с помощью wall.post, где в качестве attachment указываем photo id
     
     */
    
    UIImage *image = [UIImage imageNamed:@"test.jpg"];
    NSString *user_id = @"13058851";
    NSString *accessToken = tempToken;
    
    // 1
    NSString *getWallUploadServer = [NSString stringWithFormat:@"https://api.vk.com/method/photos.getWallUploadServer?owner_id=%@&access_token=%@", user_id, accessToken];
    
    NSDictionary *uploadServer = [self sendRequest:getWallUploadServer];
    
 
    NSString *upload_url = [[uploadServer objectForKey:@"response"] objectForKey:@"upload_url"];
    
    //  2

    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    
    NSDictionary *postDictionary = [self sendPOSTRequest:upload_url withImageData:imageData];
    
    
    NSString *hash = [postDictionary objectForKey:@"hash"];
    NSString *photo = [postDictionary objectForKey:@"photo"];
    NSString *server = [postDictionary objectForKey:@"server"];
    
    //  3

    NSString *saveWallPhoto = [NSString stringWithFormat:@"https://api.vk.com/method/photos.saveWallPhoto?owner_id=%@&access_token=%@&server=%@&photo=%@&hash=%@", user_id, accessToken,server,photo,hash];
    saveWallPhoto = [saveWallPhoto stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *saveWallPhotoDict = [self sendRequest:saveWallPhoto];
    
    NSDictionary *photoDict = [[saveWallPhotoDict objectForKey:@"response"] lastObject];
    NSString *photoId = [photoDict objectForKey:@"id"];
    
    //  4
  
 
    NSLog(@"photoID: %@", photoId);

    
    NSString *postToWallLink = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&access_token=%@&message=%@&attachment=%@", user_id, accessToken, @"NSString", photoId];
    
    NSDictionary *postToWallDict = [self sendRequest:postToWallLink];
    NSString *errorMsg = [[postToWallDict objectForKey:@"error"] objectForKey:@"error_msg"];
    if(errorMsg) {
        [self sendFailedWithError:errorMsg];
    }


}


- (NSDictionary *) sendRequest:(NSString *)reqURl {
    NSLog(@"Sending request: %@", reqURl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    id jsonData = [NSJSONSerialization JSONObjectWithData: responseData options:NSJSONReadingAllowFragments error:nil];
    
    if([jsonData isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict = (NSMutableDictionary*) jsonData;
        
        NSString *errorMsg = [[dict objectForKey:@"error"] objectForKey:@"error_msg"];
        
        NSLog(@"Server response: %@ \nError: %@", dict, errorMsg);
        
        return dict;
    }
    return nil;
}

- (NSDictionary *) sendPOSTRequest:(NSString *)reqURl withImageData:(NSData *)imageData {
    NSLog(@"Sending request: %@", reqURl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];

    [request setHTTPMethod:@"POST"];
    
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString * uuidString = [[NSString alloc] init];
    CFRelease(uuid);
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;  boundary=%@", stringBoundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"%@",endItemBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:body];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    id jsonData = [NSJSONSerialization JSONObjectWithData: responseData options:NSJSONReadingAllowFragments error:nil];

    if([jsonData isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict = (NSMutableDictionary*) jsonData;
        
        NSString *errorMsg = [[dict objectForKey:@"error"] objectForKey:@"error_msg"];
        
        NSLog(@"Server response: %@ \nError: %@", dict, errorMsg);
        
        return dict;
    }
    return nil;
}

- (void) sendFailedWithError:(NSString *)error {

}

@end


