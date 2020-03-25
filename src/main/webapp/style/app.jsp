<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
	<head>
		<base href="<%=basePath%>">
		<title>加载中</title>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-touch-fullscreen" content="yes">
		<meta name="full-screen" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta name="format-detection" content="telephone=no">
		<meta name="format-detection" content="address=no">
		<meta name="screen-orientation" content="portrait">
		<meta name="x5-orientation" content="portrait">
		<meta name="x5-fullscreen" content="true">
		<meta name="browsermode" content="application">
		<meta name="x5-page-mode" content="app">
		
		<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/weui.min.css"/>
		<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/mescroll.min.css"/>
		<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/swiper.min.css"/>
		<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/vui/vui.css"/>
	</head>
	<body ontouchstart="">
		<div id="load_js" style="text-align:center;padding-top:40%;height:100%;display:block;"></div>
		<div id="app"></div>
		<script type="text/javascript">var $,wx;</script>
		<script type="text/javascript" src="//res2.wx.qq.com/open/js/jweixin-1.4.0.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery.min.js"></script>
		<script type="text/javascript">
		function initApp(tab){
		console.log("initApp");
			var items=[{"oid":"A","name":"首页","level":null,"urlPath":"style/module.html?oid=A","icoFont":"","icoHover":"","sort":null,"isPublic":"Y"},
				{"oid":"E","name":"我的","level":null,"urlPath":"style/module.html?oid=E","icoFont":"","icoHover":"","sort":null,"isPublic":"Y"}];
			var selectItem={};
			for(var n=0;n<items.length;n++){
				if(items[n].oid==tab){
					selectItem=items[n];
				}
			}
			$.pageManager.gotoHash(function(){
				new Vue({
					el:'#app',
					data(){
						return {
							tabSelected:selectItem,
							tabItems:items
						}
					},
					mounted:function(){
						this.tabChange(this.tabSelected);
					},
					methods:{
						tabChange:function(tab){
							var tabpage=$("#tabpage");
							tabpage.children().hide();
							var tp=tabpage.children("#tabpage"+tab.oid);
							if(tp.length>0){
							}else{
								tp=$('<div></div>',{id:"tabpage"+tab.oid});
								tabpage.append(tp);
								$.loadVuePage(tp,tab.urlPath,$.parseParams(tab.urlPath),function(vue){});
							}
							tp.show();
						}
					}
				});
			});
		}
		function refreshIndexPageHandler(tab){
			$.pageManager.closeAllPage();
			$("#app").html('<div class="page" id="tabpage"></div><vui-tabbar :selected="tabSelected" :items="tabItems" @on-change="tabChange"></vui-tabbar>');
			$.pageManager.gotoHash(function(){initApp(tab);});
		}
		function refreshIndexPage(tab){
			refreshIndexPageHandler(tab);
		}
		function jsLoadDone(){
			$.mconfig.business="";
			$.execProcessJSON=function(json){
				return true;
			};
			
			if($&&!$.getLocationHash()){
				var ps=$.parseParams(""+location);
				if(ps['hash']){
					var hash=ps['hash'].split("#");
					pm.go(decodeURIComponent(hash[0]),{'finally':function(){
						refreshIndexPage('A');
					}});
					return;
				}
			}
			refreshIndexPage('A');
		};
		var jsList=["/resources/js/mescroll.min.js",
			"/resources/js/swiper.min.js",
			"/resources/js/vue.min.js",
			"/resources/vui/vui.js",
			"/resources/default/app.js"];
		var loadTimer={
			timer:null,
			index:jsList.length,
			max:jsList.length,
			exec:function(i){
				this.index=i;
				this.timer=this.to();
			},
			n:0,
			s:'.',
			to:function(){
				var self=this;
				return setTimeout(function(){
					if(self.timer){
						clearTimeout(self.timer);
						self.timer=null;
					}
					if(self.index<=0){
						$("#load_js").html('加载完成').fadeOut(1000);
					}else{
						if(self.s.length>10) self.s='.';
						else self.s+='.';
						if(self.n<99&&self.n<(1-(self.index-1)/self.max)*100){
							if(self.n<(1-self.index/self.max)*100){
								self.n=Math.round((1-self.index/self.max)*100);
							}else{
								self.n++;
							}
						}
						$("#load_js").html('资源加载中<br>'+self.s+self.n+"%"+self.s);
						self.timer=self.to();
					}
				},66);
			}
		};
		function loadJs(){
			loadTimer.exec(jsList.length);
			if(jsList.length>0){
				$.getScript(jsList[0],function(data, status, jqxhr){
					jsList.shift();
					loadJs();
				});
			}else{
				jsLoadDone();
			}
		};
		if($){}else{location.reload();}
		$(function(){
			if($("script").length!=4){location.reload();}
			loadJs();
		});
		</script>
	</body>
</html>
