var wxUtil={
	isWechat:false,//是否微信客户端
	jsApiList:["scanQRCode","chooseWXPay"],
	scanQRCode:function(fn){
		if(wxUtil.isWechat){
			wx.scanQRCode({
				needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
				scanType: ["qrCode","barCode"], // 可以指定扫二维码还是一维码，默认二者都有
				success: (function (res) {
					var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
					if(fn){
						fn(result);
					}
				}).bind(this)
			});
		}else{
			$.alert("扫码功能需要在微信客户端运行","提示");
		}
	}
};
var apUtil={
	isAlipay:false,//是否支付宝客户端
	scanQRCode:function(fn){
		if(apUtil.isAlipay&&window.AlipayJSBridge){
			AlipayJSBridge.call(
				"scan",
				{type: "qr"},
				function(res) {
					var result = res.codeContent; 
					if(fn){
						fn(result);
					}
				}
			);
		}else{
			$.alert("扫码功能需要在支付宝客户端运行","提示");
		}
	}
};
var jsUtil={
	scanQRCode:function(fn){
		if(wxUtil.isWechat){
			wxUtil.scanQRCode(fn);
		}else if(apUtil.isAlipay&&window.AlipayJSBridge){
			apUtil.scanQRCode(fn);
		}else{
			$.alert("扫码功能需要在微信客户端或支付宝客户端运行","提示");
		}
	}
};
$(function(){
	var ua = window.navigator.userAgent.toLowerCase();
	//console.log(ua);//mozilla/5.0 (iphone; cpu iphone os 9_1 like mac os x) applewebkit/601.1.46 (khtml, like gecko)version/9.0 mobile/13b143 safari/601.1
	if (ua.match(/MicroMessenger/i) == 'micromessenger') {
		wxUtil.isWechat=true;
	} else {
		wxUtil.isWechat=false;
	}
	if (ua.match(/AlipayClient/i) == 'alipayclient') {
		apUtil.isAlipay=true;
	} else {
		apUtil.isAlipay=false;
	}
	if(wx){
		wx.ready(function(){
			wxUtil.isWechat=true;
		});
		wx.error(function(res){
		});
		$.execJSON("action/appApi/getWxConfig",
			{"url":location.href.split('#')[0]},
			function(ele){
				if(ele.code==0){
					wx.config({
						debug: false, // 
						appId: ele.appId, // 
						timestamp: ele.timestamp, // 
						nonceStr: ele.nonceStr, //
						signature: ele.signature,//
						jsApiList: wxUtil.jsApiList
					});
				}else{
					console.log(ele.msg);
				}
			}
		);
	}
});