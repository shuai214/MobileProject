//
//  KCSConstant.h
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/3.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#ifndef KCSConstant_h
#define KCSConstant_h

#pragma mark static ----

static NSString* const kTel_num = @"4008-108-717";
static NSString* const Login_Nitify = @"loginNotify";
static NSString* const ShopCar_Nitify = @"shopCarNotify";

static NSString* const SFEXPRESS = @"SFEXPRESS";
static NSString* const ZTO = @"ZTO";
static NSString* const ZTO56 = @"ZTO56";
static NSString* const YTO = @"YTO";
static NSString* const STO = @"STO";
static NSString* const YUNDA = @"YUNDA";
//#define AES_KEY @"12345678"
#define AES_KEY @"lBhZwbty4uU9YIonMOFiZi7KXFMobrCT"
#define AES_IV  @"0102030405060708"

#pragma mark --------发票类型
#define SPE_INV @"SPE_INV"
#define GEN_INV @"GEN_INV"
#define BILL_TYPE_Z @"专用发票" 
#define BILL_TYPE_P @"普通发票"


#define SIGNATURE_KEY @"signature"
#define DATA_PAGE_SIZE @"5"

/***********TabBar**************/
#define CSClassKey @"viewController"
#define CSTitleKey @"title"
#define CSImageKey @"imageName"
#define CSImageSelKey @"selectedImageName"


#pragma mark ---------------------- request url -----------------------------

//#define URL @"https://buscentre.chinascpet.com"
#define APP_URL @"http://120.77.86.221:8080/buscentre"

//#define URL @"http://localhost:8080/businessCentre"
#define LOGIN_URL @"/a/login.mobile"
#define LOGOUT_URL @"/a/logout.mobile"//注销
#define Validate_Code @"/servlet/validateCodeServlet"//获取验证码
#define Modify_URL @"/a/buscentre/common/moidfyPwd.mobile"//修改密码

#define SUPPLIER_LIST @"/a/buscentre/pay/goodsPurchase/supplierList.mobile"//供货商列表
#define GOODS_PURCHASE_LIST @"/a/buscentre/pay/goodsPurchase/list.mobile"//供货商商品列表
#define BuscentrePhysicalTransportOrder_LIST @"/a/buscentre/bill/buscentrePhysicalTransportOrder/list.mobile"//实物运输单列表
#define BuscentrePhysicalReceiptOrder_LIST @"/a/buscentre/bill/buscentrePhysicalReceiptOrder/list.mobile"//实物交接单列表
#define BuscentrePhysicalReceiptOrder_FORM @"/a/buscentre/bill/buscentrePhysicalReceiptOrder/form.mobile"//实物交接单列表详情
#define BuscentreOutcomeBill_LIST @"/a/buscentre/bill/buscentreOutcomeBill/list.mobile"//销项发票列表
#define BuscentreOutcomeBill_Logistics @"/a/buscentre/bill/buscentreLogisticsDetail/form.mobile"//销项发票列表
#define BuscentreOutcomeBill_DETAIL @"/a/buscentre/bill/buscentreOutcomeBill/view.mobile"//销项发票详情
#define Contract_List @"/a/buscentre/bill/contract/distributorContractList.mobile"//分销商合同
#define Contract_Detail @"/a/buscentre/bill/contract/distributorContractView.mobile"//分销商合同详情
#define Order_List @"/a/buscentre/order/buscentreOrder/list.mobile"//订单列表
#define Order_Form @"/a/buscentre/order/buscentreOrder/form.mobile"//订单列表详情
#define Order_Pay @"/a/buscentre/order/buscentreOrder/pay.mobile"//订单确认付款
#define Confirm_Ship @"/a/buscentre/order/buscentreOrder/confirmShip.mobile"//订单确认收货
#define Confirm_Outcome_Bill @"/a/buscentre/order/buscentreOrder/confirmOutcomeBill.mobile"//订单确认收票
#define Supplier_Info @"/a/buscentre/pay/goodsPurchase/supplierInfo.mobile"//供货商公司详情
#define User_Info @"/a/buscentre/common/userDetailInfo.mobile"//分销商user
#define Office_Info @"/a/buscentre/common/officeDetailInfo.mobile"//分销商office
#define Supplier_Save @"/a/buscentre/pay/goodsPurchase/save.mobile"//商品加入购物车
#define ShoppingCart_List @"/a/buscentre/pay/buscentreShoppingCart/list.mobile"//购物车列表
#define ShoppingCart_Del @"/a/buscentre/pay/buscentreShoppingCart/delete.mobile"//商品删除购物车
#define Down_Bill @"/a/buscentre/pay/goodsPurchase/downBill.mobile"//下单

#endif /* KCSConstant_h */
