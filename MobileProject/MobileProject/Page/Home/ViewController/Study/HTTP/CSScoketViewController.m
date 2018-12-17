//
//  CSScoketViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/12/15.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSScoketViewController.h"
#import <sys/socket.h>

#import <netinet/in.h>

#import <arpa/inet.h>

#import <unistd.h>

#import <netinet/tcp.h>
static const char *server_ip = "127.0.0.1";
static const short server_port = 6969;
@interface CSScoketViewController ()
{
    int _clientSocket;
}
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@end

@implementation CSScoketViewController

/**
 什么是长连接、短连接？
 在HTTP/1.0中默认使用短连接。也就是说，客户端和服务器每进行一次HTTP操作，就建立一次连接，任务结束就中断连接。当客户端浏览器访问的某个HTML或其他类型的Web页中包含有其他的Web资源（如JavaScript文件、图像文件、CSS文件等），每遇到这样一个Web资源，浏览器就会重新建立一个HTTP会话。
 
 而从HTTP/1.1起，默认使用长连接，用以保持连接特性。使用长连接的HTTP协议，会在响应头加入这行代码：
 
 Connection:keep-alive
 在使用长连接的情况下，当一个网页打开完成后，客户端和服务器之间用于传输HTTP数据的TCP连接不会关闭，客户端再次访问这个服务器时，会继续使用这一条已经建立的连接。Keep-Alive不会永久保持连接，它有一个保持时间，可以在不同的服务器软件（如Apache）中设定这个时间。实现长连接需要客户端和服务端都支持长连接。
 
 HTTP协议的长连接和短连接，实质上是TCP协议的长连接和短连接。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSocket];
}

- (void)initSocket{
    //1.创建  socket
    /*
     第一个参数:address_family,协议簇 AF_INET ---->IPV4
     第二个参数:数据格式 --> SOCK_STREAM(TCP)(数据流)/SOCK_DGRAM(UDP)(数据报文)
     第三个参数:protocol IPPROTO_TCP,如果传入0,会自动根据第二个参数选中合适的协议.
     返回值:成功 ---->正值  失败---->-1
     */
    _clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    //2.连接
    /*
     第一个参数:客户端 socket
     第二个参数:指向数据结构 socketAddr 的指针,其中包括目的端口和IP地址
     第三个参数:结构体数据长度
     返回值 : 成功 ---> 0 其他 --->错误代号
     */
    //结构体
    struct sockaddr_in sockAddr = {0};
    sockAddr.sin_len = sizeof(sockAddr);
    sockAddr.sin_family = AF_INET;
    inet_aton(server_ip, &sockAddr.sin_addr);
    sockAddr.sin_port = htons(server_port);
    int flag = connect(_clientSocket, (struct sockaddr *)&sockAddr, sizeof(sockAddr));
    if (!flag) {
        //链接成功的话 就开始进行读写操作。。。
        //开辟新的线程 接受服务端的数据
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(receiveAction) object:nil];
        [thread start];
        
    }else{
        NSLog(@"链接错误");
    }
}

- (void)receiveAction{
    //死循环 保持连接。接收消息
    while (1) {
        /*
         第一个参数:客户端 socket
         第二个参数:接收内容缓冲区域
         第三个参数:接收内容缓冲区长度
         第四个参数:接收方式 0 表示阻塞，必须等服务器返回数据。
         返回值 : 成功 ---> 返回读入字节数
         */
        //数据流是NSData 的二进制数据，。
        //需要接收数据。先声明一个缓冲区。
        char recv_msg[1024];
        //接收消息 api
        recv(_clientSocket, recv_msg, sizeof(recv_msg), 0);
        printf("%s\n",recv_msg);
    }
}
- (void)sendMessage:(NSString *)msg{
    const char *send_Msg = [msg cStringUsingEncoding:NSUTF8StringEncoding];
    //发送消息 api
    send(_clientSocket, send_Msg, strlen(send_Msg), 0);
    
}
- (IBAction)action:(id)sender {
    if (!kStringIsEmpty(self.messageField.text)) {
        [self sendMessage:self.messageField.text];
    }
}

@end
