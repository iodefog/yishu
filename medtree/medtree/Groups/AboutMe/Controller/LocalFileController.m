//
//  LocalFileController.m
//  medtree
//
//  Created by 无忧 on 14-10-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "LocalFileController.h"
#import "LoadingView.h"

@interface LocalFileController () <UIWebViewDelegate>
{
    UIWebView       *web;
}

@end

@implementation LocalFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [naviBar setTopTitle:@"《用户协议》"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)createBackButton
{
    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png" selectedImage:@"btn_back_click.png" target:self action:@selector(clickBack)];
    [naviBar setLeftButton:backButton];
    return backButton;
}

- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    web = [[UIWebView alloc] initWithFrame:CGRectZero];
    web.delegate = self;
    web.backgroundColor = [UIColor whiteColor];
    web.scalesPageToFit = YES;
    web.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:web];
    
    [web loadHTMLString:@"<html><bodystyle='text-align:justify;'><h3>一、必要说明</h3>1&nbsp;、本协议为北京医树网信息技术有限责任公司（以下简称“医树网公司”）提供的社交及平台化服务（以下简称“医树网服务”）与使用人（以下简称“用户”）之间的协议。<br>2&nbsp;、医树网公司在此提请注意，用户欲使用医树网服务，必须事先认真阅读本协议中各条款（未成年人阅读时应得到法定监护人的陪同），包括免除或者限制医树网公司责任的免责条款及对用户的权利限制。<br>3&nbsp;、用户注册、登录、使用及连接等行为将视为用户完全了解并接受及遵守本协议下的全部条款内容，本协议可由医树网公司适时修改，修改后的协议条款一旦公布即代替原来的协议条款，用户可在本平台下查阅最新版协议条款。如果用户不接受修改后的条款，可立即停止使用相关服务；如继续使用医树网服务，则视为用户接受当次修改。<br>4&nbsp;、用户同意:（1）提供及时、详尽及准确的个人资料。（2）不断更新注册资料，符合及时、详尽、准确的要求。所有原始键入的资料将引用为注册资料。<br><br><h3>二、医树网服务</h3>1&nbsp;、用户隐私信息包括下列信息：用户真实姓名，照片、手机号、学习及工作经历、IP地址等。而非个人隐私信息是指用户对本服务的操作状态以及使用习惯等一些明确且客观反映在医树网服务器端的基本记录信息和其他一切个人隐私信息范围外的普通信息；以及用户同意公开的上述隐私信息。公司通过收集、统计和分析用户在创建、导入上述信息建立的好友关系，向用户提供好友交互、人脉分布、关系链以及其它服务。<br>2&nbsp;、用户的个人隐私资料将获得有效保护，除医树网服务必须涉及或产品自身设计特点需要的情况以及有利于公司或客户原则下的合理使用和法律下的必要配合外，未经用户同意，个人隐私资料不得随意透露。公司有权对整个用户数据库进行收集、统计、分析，并对用户数据库进行商业利用，但无需向单个用户支付费用。用户可关闭账户，但对医树网公司不具有追溯效力。<br>3&nbsp;、用户同意接受医树网公司提供的相关信息服务。公司拥有对医树网服务的调整、变更、中断或终止的权利，拥有对用户在医树网服务中行为合法性监督以及及时补救和处置的权利，而无需向用户或第三方承担任何责任。<br>4&nbsp;、如果用户提供的资料不准确，不真实，不合法有效，医树网公司保留结束用户使用医树各项服务的权利。<br><br><h3>三、使用规则</h3>1&nbsp;、用户明确且必须对以其账号进行的活动或事件承担法律责任。<br>2&nbsp;、用户在使用医树网服务中，必须遵循以下原则：<br><ul><li>遵守中国法律和法规。</li><li>遵守所有与网络服务有关的规定。</li><li>不得在医树网服务中从事非法活动。</li><li>不能利用在医树网公司获取的各项服务，在其它相关网站上使用相关数据或进行其他商业性行为。用户违反此约定，医树网公司将依法追究其违约责任，由此给公司造成损失的，公司有权进行追偿。</li><li>不得在医树网服务中侵犯他人合法权利，包括但不限于他人依法享有的专利权、著作权、商标权、名誉权或其他任何合法权益。不得制造、散播虚假骚扰性的、中伤诽谤性的、种族歧视性的等任何非法言语或信息资料。</li><li>不得侵害医树网公司的权利或利益；不得侵害医树网公司网络，不得利用医树网公司网络制造有损于其它网络安全的行为。</li></ul><br><h3>四、知识产权</h3>1&nbsp;、医树网服务中所含的任何照片、文本、音像或视频等，均受相关知识产权法律保护，未经相关权利人同意，相关资料不得随意被任何媒体使用、发布或被用于任何商业目的。<br>2&nbsp;、公司有权依据独立判断对违反知识产权或违反本协议规定的内容进行适时监控和处理；对于可能因处置行为所引起的任何后果或损失不负任何责任。<br><br><h3>五、免责与赔偿声明</h3>1&nbsp;、医树网公司提供的服务信息仅供用户参考使用，用户应对其信息自行加以判断，公司不对相关信息的真实性和完整性承担责任，不对因用户行为而导致的任何损失或损害承担责任。<br>2&nbsp;、因用户不法、不当行为而侵犯公司或第三方合法权益，用户需自行承担由此带来的责任和损害赔偿。如果用户未保管好自己的帐号和密码而对其自身、医树网公司或第三方造成的损害，用户将负全部责任。<br>3&nbsp;、对于因不可抗力或医树网公司不能控制或通过努力仍能力不及的原因造成的威胁或损害到用户的计算机信息和数据安全，医树网公司无需承担任何责任。<br><br><h3>六、法律管辖</h3>本协议签订地为北京市海淀区。用户在此完全同意将纠纷或争议提交协议签订地有管辖权的人民法院管辖。<br><br><h3>七、其他规定</h3>以上各项条款内容的最终解释权及修改权均归医树网公司所有。</div><br><br><br><center>北京医树网信息技术有限责任公司</center><br><center>2014年10月</center><br></body></html>" baseURL:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    web.frame = CGRectMake(20, [self getOffset]+44, size.width-40, size.height-([self getOffset]+44));
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [LoadingView showProgress:YES inView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [web stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"];
    [LoadingView showProgress:NO inView:self.view];
}

@end
