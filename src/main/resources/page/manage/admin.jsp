<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<meta charset="utf-8">
		<meta name="viewport" i-content="width=device-width, initial-scale=1, maximum-scale=1">
		<title>${map.systemInfo.backgroundTitle }</title>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/resources/css/iview.css" />
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/resources/default/admin.css" />
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/custom/admin.css" />
		<script type="text/javascript">var $;</script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/jquery.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/vue.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/echarts-all.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/iview.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/vue-html5-editor.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/jsplumb.js"></script>
		<script type="text/javascript">//style="display: block;position: absolute;width: 100%;"
		function initVueComponent(){
			Vue.use(iview, {
				transfer: true,
				capture: false
			});
			Vue.component('admin-layout',{
				template:`<layout>
					<slot name="head"></slot>
					<layout :style="{padding: '60px 0px 0 0px'}">
						<i-content :style="{padding: '0', background: '#fff'}">
							<sider hide-trigger :style="{position: 'fixed',top:'60px', bottom:0,left:0,overflow:'auto',background:'transparent',minWidth:width,maxWidth:width}">
								<slot name="menu"></slot>
							</sider>
							<layout :style="{marginLeft:width}">
								<slot></slot>
							</layout>
						</i-content>
					</layout>
				</layout>`,
				data:function(){
					return {width:'200px'};
				},
				mounted:function(){
					pageVue.$on("menuExpansion",function(b){
						if(b){
							this.width='200px';
						}else{
							this.width='75px';
						}
					}.bind(this));
				},
			});
			Vue.component('admin-header',{
				template:`<i-header :style="{position:'fixed',width:'100%',padding:0}" style="z-index:999;">
					<i-menu ref="moduleMenu" mode="horizontal" theme="light" :active-name="active" >
						<div style="padding:0 20px;display:inline-block;float:left;color: #2d8cf0;font-size:17px;">
							<c:if test="${map.systemInfo.titleType!='N'}"><img src="${map.systemInfo.titleIcon.path }" style="margin-left:-20px;height:60px;"/></c:if>
							<c:if test="${map.systemInfo.titleType!='Y'}"><span>${map.systemInfo.backgroundTitle }</span></c:if>
						</div>
						<menu-item v-for="(module,key) in modules" :key="key" :name="key" @click.native="doModule(key)" :class="active==key?'ivu-menu-item-active':''">
							<i class="iconfont" style="font-size:19px;" v-html="module.icon"></i><span style="font-size:15px;" v-html="module.name"></span>
						</menu-item>
						<slot></slot>
					</i-menu>
				</i-header>`,
				props:['active','modules'],
				methods:{
					doModule:function(key){
						this.active=key;
						this.$emit("on-click-module",key);
					}
				}
			});
			Vue.component('admin-menu',{
				template:`<div :style="{height:'100%',width:menuExpansion?'200px':'75px'}">
					<div style="height:100%;" v-if="menuExpansion">
						<transition name="slide-fade-down" v-for="(module,key) in modules" :key="key">
							<i-menu style="min-height:100%;background:rgba(255,255,255,0.7)" :ref="'menu'+key" v-show="key==activeModule" :accordion="true" :active-name="activeMenu2" theme="light" width="auto" :open-names="[activeMenu1]">
								<submenu v-for="(menu1,key1) in module.menus" :key="key1" :name="key1">
									<template slot="title">
									<i class="iconfont" v-html="menu1.icon"></i><span v-html="menu1.name"></span>
									</template>
									<menu-item v-for="(menu2,key2) in menu1.menus" :key="key2" :name="key2" @click.native="doMenu(key2)" :class="activeMenu2==key2?'ivu-menu-item-active':''">
										<icon type="ios-arrow-forward" style="font-size:12px;"></icon>
										<span v-html="menu2"></span>
									</menu-item>
								</submenu>
							</i-menu>
						</transition>
					</div>
					<div style="height:100%;border-right:1px solid rgb(221, 221, 221);background:rgba(240,245,255,0.6);" v-if="!menuExpansion">
						<transition name="slide-fade-down" v-for="(module,key) in modules" :key="key">
							<div v-show="key==activeModule" style="padding:15px 0 0;">
								<dropdown v-for="(menu1,key1) in module.menus" :key="key1" transfer placement="right-start" trigger="hover">
									<span :style="{width:'75px',textAlign:'center',display:'block',marginBottom:'8px',color:activeMenu1==key1?'#2d8cf0':''}">
										<i class="iconfont" style="font-size:28px;" v-html="menu1.icon"></i>
										<div v-html="menu1.name"></div>
									</span>
									<dropdown-menu slot="list">
										<a v-html="menu1.name" style="fontSize:17px;lineHeight:35px;padding:0 35px;"></a>
										<dropdown-item v-for="(menu2,key2) in menu1.menus" :key="key2" :name="key2" @click.native="doMenu(key2)" :selected="key2==activeMenu2">
											<icon type="ios-arrow-forward" style="font-size:12px;"></icon>
											<span v-html="menu2"></span>
										</dropdown-item>
									</dropdown-menu>
								</dropdown>
							</div>
						</transition>
					</div>
				</div>`,
				props:['modules'],
				data:function(){
					return {activeModule:'',activeMenu1:'',activeMenu2:'',menuExpansion:true};
				},
				mounted:function(){
					pageVue.$on("changeModule",function(oid){
						this.activeModule=oid;
						if(this.menuExpansion && this.activeMenu1.indexOf(this.activeModule)!=0){
							this.$nextTick(function(){
								for(var key in this.modules[this.activeModule].menus){
									this.$refs['menu'+this.activeModule][0].openedNames=[key];
									break;
								}
								this.$refs['menu'+this.activeModule][0].updateOpened();
							}.bind(this));
						}
					}.bind(this));
					pageVue.$on("changeMenu",function(arr){
						this.activeModule=arr[0];
						this.activeMenu1=arr[1];
						this.activeMenu2=arr[2];
						if(this.menuExpansion){
							this.$nextTick(function(){
								this.$refs['menu'+this.activeModule][0].updateOpened();
							}.bind(this));
						}
						
					}.bind(this));
					pageVue.$on("menuExpansion",function(b){
						this.menuExpansion=b;
					}.bind(this));
				},
				methods:{
					doMenu:function(key2){
						this.$emit("on-click-menu",key2);
					}
				}
			});
			Vue.component('admin-nav-tags',{
				template:`<div :style="{position:'fixed',zIndex:'998',top:'60px',left:menuExpansion?'200px':'75px',right:'1px',padding:'8px 0px 0px 8px',backgroundColor:'rgba(238,238,238,0.85)',overflow:'hidden',height:'39px'}">
					<slot name="first"></slot>
					<tabs type="card" :closable="tags.length>1" :before-remove="beforeClose" :value="active" @on-click="doClick">
						<tab-pane v-for="tag in tags" :label="tagName[tag]" :name="tag"></tab-pane>
						<dropdown transfer slot="extra">
							<i-button style="padding:0 10px;" type="text"><i class="iconfont" style="font-size:20px;">&#xe71b;</i></i-button>
							<dropdown-menu slot="list">
								<dropdown-item v-for="tag in tags" :key="tag" :name="tag" @click.native="doClick(tag)" :selected="active==tag"><span v-html="tagName[tag]"></span></dropdown-item>
							</dropdown-menu>
						</dropdown>
					</tabs>
				</div>`,
				props:{
					active:{type:String},
					tags:{type:Array},
					tagName:{type:Object},
				},
				data:function(){
					return {menuExpansion:true};
				},
				mounted:function(){
					pageVue.$on("menuExpansion",function(b){
						this.menuExpansion=b;
					}.bind(this));
				},
				methods:{
					doClick:function(tag){
						this.$emit("on-click-tag",tag);
					},
					beforeClose:function(i){
						this.$emit("on-close-tag",this.tags[i]);
						return new Promise(
							function(resolve, reject) {
								reject('tag click');
							}
						);
					}
				}
				
			});
		}
		</script>
	</head>
	
	<body>
		<div style="z-index:0;display: block;position: fixed;width: 100%;height: 100%;opacity: 0.2;filter: Alpha(opacity=20);background-color:#ddd;background:url(${fn:indexOf('YB',map.systemInfo.backgroundType)>-1?map.systemInfo.backgroundImage.imgPath:'' });background-size:cover;"></div>
		<div id="load_js" style="z-index:99999;display: block;position: fixed;width: 100%;top:47%;padding:10px 0;line-height:25px;font-size:20px;background-color:rgba(255,255,255,0.7);color:#000;text-align:center;"></div>
		<div id="main_page" style="display: block;position: absolute;width: 100%;overflow: auto;" >
			<admin-layout>
				<admin-header slot="head" :modules="modules" :active="activeModule" @on-click-module="doModule">
					<dropdown transfer style="float:right;" trigger="click">
						<a href="javascript:void(0)" style="height:60px;padding:10px;display:inline-block;">
							<avatar :src="modelInfo.headImage.thumPath" style="vertical-align:baseline;"></avatar>
							<span :style="{display:'inline-block','line-height':modelInfo.orgGroup&&modelInfo.orgGroup.oid?1.2:0.6}">
								<span style="display:block;" v-html="modelInfo.realname"></span>
								<small v-if="modelInfo.orgGroup&&modelInfo.orgGroup.oid" v-html="modelInfo.orgGroup.name"></small>
								<small v-else>&nbsp;</small>
							</span>
						</a>
						<dropdown-menu slot="list">
							<dropdown-item @click.native="modify"><span v-html="'修改登陆信息'"></span></dropdown-item>
							<dropdown v-if="modelInfo.orgGroup&&modelInfo.orgGroup.oid" placement="right-start" style="width:100%;">
								<dropdown-item><span v-html="modelInfo.orgGroup.name"></span><icon type="ios-arrow-forward" style="float:right;margin-top:3px;"></icon></dropdown-item>
								<dropdown-menu slot="list">
									<template v-for="item in orgGroups">
										<dropdown-item :selected="item.oid==modelInfo.orgGroup.oid" @click.native="setCurrentOrgGroup(item)"><span v-html="item.parent.name+' - '+item.name"></span></dropdown-item>
									</template>
								</dropdown-menu>
							</dropdown>
							<dropdown-item @click.native="logout" divided><span v-html="'退出登陆'"></span></dropdown-item>
						</dropdown-menu>
					</dropdown>
				</admin-header>
				<admin-menu slot="menu" :modules="modules" @on-click-menu="doOpenMenu" ></admin-menu>
				<i-content :style="{padding: '0 10px 0 10px',overflowY:'hidden','background':'rgba(255,255,255,0.3)!important'}">
					<admin-nav-tags :active="activeTag" :tags="tags" :tag-name="tagName" @on-click-tag="doOpenMenu" @on-close-tag="doCloseMenu">
						<i-button type="text" slot="first" style="margin:0 8px 8px -10px;padding:0 10px;float:left;" @click="setMenuExpansion">
							<i class="iconfont" style="font-size:20px;" v-html="menuExpansion?'&#xe6b4;':'&#xe6b5;'"></i>
						</i-button>
					</admin-nav-tags>
					<breadcrumb :style="{position:'absolute',top:'118px',right:'12px',textAlign:'right'}">
						<breadcrumb-item :style="{color:'#2d8cf0'}"><span v-html="breadcrumb3"></span></breadcrumb-item>
						<breadcrumb-item><span v-html="breadcrumb2"></span></breadcrumb-item>
						<breadcrumb-item><span v-html="breadcrumb1"></span></breadcrumb-item>
					</breadcrumb>
					<div id="main_content" style="margin:53px 0 10px 0;"></div>
				</i-content>
			</admin-layout>
			<modal :mask-closable="false" :width="470" v-model="toModify" :footer-hide="true">
				<div id="modifyModelInfo"></div>
			</modal>
		</div>
		<div id="login_page" v-show="loginBackground" style="position: fixed;overflow: hidden;width:100%;top:0px;bottom:0px;z-index:2000;background:url(${fn:indexOf('YA',map.systemInfo.backgroundType)>-1?map.systemInfo.backgroundImage.imgPath:'' });background-size:cover;background-color:#4f555a;">
			<modal id="login_modal" class-name="vertical-center-modal" :style="{zIndex:2001}" width="450" :closable="false" footer-hide :mask-closable="false" v-model="tologin">
				<row>
					<i-col offset="5" span="14">
						<p style="color:#fff;text-align:center;padding-top:50px;">
							<span v-html="'${map.systemInfo.backgroundTitle }'" :style="{fontSize:'19px'}"></span>
						</p>
						<div style="height:8px;"></div>
						<alert type="error" show-icon v-if="loginMessage" v-html="loginMessage"></alert>
						<i-form :model="loginInfo">
							<form-item style="margin-bottom:4px;">
								<i-input type="text" v-model="loginInfo['model.username']" placeholder="用户名">
									<icon type="ios-person-outline" slot="prepend"></icon>
								</i-input>
							</form-item>
							<form-item style="margin-bottom:4px;">
								<i-input type="password" v-model="loginInfo['model.password']" placeholder="密码" @on-enter="codeVerify?'':doLogin()">
									<icon type="ios-medical-outline" slot="prepend"></icon>
								</i-input>
							</form-item>
							<form-item v-if="codeVerify" style="margin-bottom:4px;">
								<i-input type="text" v-model="loginInfo['imageCode']" placeholder="验证码" @on-enter="doLogin">
									<icon type="ios-medical-outline" slot="prepend"></icon>
									<span slot="append"><img height="22" :src="loginCode?'action/manageAdminLogin/getCaptchaCode':''" /></span>
								</i-input>
							</form-item>
							<form-item style="margin-bottom:4px;text-align:right;">
								<checkbox v-model="autoLogin"><span style="color:#fff;" v-html="'一周内自动登录'"></span></checkbox>
							</form-item>
						</i-form>
						<div style="height:8px;"></div>
						<i-button type="primary" size="large" long @click="doLogin" v-html="'登录'"></i-button>
					</i-col>
				</row>
			</modal>
		</div>
		
		<script type="text/javascript">
		
		function jsLoadDone(){
			initVueComponent();
			$(document.body).ready(function(){
				$.vue['main_admin']=new Vue({//主页面初始化
					el:"#main_page",
					data:{init:false,modelInfo:{headImage:{thumPath:''}},orgGroups:[],modules:[],menuMap:{},
						toModify:false,tags:[],tagName:{},activeTag:'',currentMenuOid:'',
						activeModule:'',breadcrumb1:'',breadcrumb2:'',breadcrumb3:'',
						menuExpansion:true},
					mounted:function(){
						pageVue.$on("menuExpansion",function(b){
							this.menuExpansion=b;
						}.bind(this));
					},
					methods:{
						backHandler:function(s){
							if(s){location.reload();}
							else this.toModify=false;
						},
						setMenuExpansion:function(){
							this.menuExpansion=!this.menuExpansion;
							pageVue.$emit("menuExpansion",this.menuExpansion);
						},
						modify:function(){
							var self=this;
							$.loadVuePage($('#modifyModelInfo'),'action/manageAdminLogin/toEdit4Self',{openMode:'MODAL',openKey:'main_admin'},function(){
								self.toModify=true;
							});
						},
						setCurrentOrgGroup:function(org){
							if(org.oid!=this.modelInfo.orgGroup.oid){
								this.$Modal.confirm({
									title: '更改当前机构',
									content: '<p>确定要更改为('+org.parent.name+'-'+org.name+')?<br/>更改完成后将刷新页面</p>',
									loading: true,
									onOk: function(){
										$.execJSON("action/manageAdminGroup/setCurrentOrgGroup",{'model.oid':org.oid},function(json){
											window.location.hash="";
											location.reload();
										});
									}
								});
							}
						},
						logout:function(){
							this.$Modal.confirm({
								title: '退出系统',
								content: '<p>确定要退出系统吗?</p>',
								loading: true,
								onOk: function(){
									$.execJSON("action/manageAdminLogin/doLogout",{},function(json){
										window.location.hash="";
										location.reload();
									});
								}
							});
						},
						doModule:function(oid){
							if(!this.init) return;
							pageVue.$emit("changeModule",oid);
						},
						doOpenMenu:function(oid){
							if(!this.init) return;
							var arr=this.menuMap[oid];
							if(!arr[0]) this.doCloseMenu(oid);
							this.activeModule=arr[0].oid;
							this.activeTag=oid;
							pageVue.$emit("changeMenu",[arr[0].oid,arr[1].oid,oid]);
							this.breadcrumb1=arr[0].name;
							this.breadcrumb2=arr[1].name;
							this.breadcrumb3=arr[2];
							if(this.tags.indexOf(oid)<0){
								this.tags.push(oid);
								this.tagName[oid]=this.breadcrumb3;
							}
							window.location.hash=oid;
						},
						doCloseMenu:function(oid){
							if(!this.init) return;
							var n=this.closeMenu(oid);
							if(n){
								this.tags.remove(oid);
								this.tagName[oid]=null;
								this.doOpenMenu(n);
							}
						},
						closeMenu:function(oid){
							if(!this.init) return;
							if(this.currentMenuOid==oid){
								var childs=$("#main_content").children("div");
								if(childs.length==1){
									pageVue.$Message.error("最后一个标签了,不能再关闭了");
									return "";
								}
								$("#menu"+oid).remove();
								childs=$("#main_content").children("div");
								if(childs.length>0){
									var content=childs.eq(0);
									this.currentMenuOid=(content.attr("id")+"").substring(4);
								}else{
									this.currentMenuOid="";
								}
							}else{
								$("#menu"+oid).remove();
							}
							return this.currentMenuOid;
						},
						setDefaultMenu:function(menuid){
							for(var i=this.tags.length-1;i>=0;i--){
								if(!this.menuMap[this.tags[i]]){
									this.tags.splice(this.tags.length-1,1);
								}
							}
							var hash=$.getLocationHash();
							if(hash&&this.menuMap[hash]){
								this.doOpenMenu(hash);
								this.hashChange();
							}else{
								this.doOpenMenu(menuid);
							}
						},
						hashChange:function(){
							if(!this.init) return;
							var hash=$.getLocationHash();
							var self=$.vue['main_admin'];
							if(self.currentMenuOid){$("#menu"+self.currentMenuOid)['slideUp'](300);}
							self.currentMenuOid=hash;
							var content=$("#main_content").children('#menu'+hash);
							if(content.length){
								content.slideDown(300);
							}else{
								$.execHTML('action/manageGroupMenuLink/gotoMenuPage',{'menu.oid':hash},function(html){
									html=$.trim(html);
									if(html.indexOf("<")==0){
										var ele=$(html).slideUp();
										$("#main_content").append(ele);
										ele.fadeIn(300);
									}else{
										pageVue.$Message.error(html);
									}
								});
							}
						}
					}
				});
				var loginTimer=null;
				var loginVue=new Vue({
					el:"#login_page",
					data:{
						lastTime:0,
						tologin:false,
						loginBackground:true,
						loginCode:false,
						codeVerify:false,
						loginMessage:"",
						autoLogin:false,
						loginInfo:{
							'model.username':'',
							'model.password':'',
							imageCode:"",
						},
						modelInfo:{
						}
					},
					mounted:function(){
						this.isLogin();
						this.setTimer();
					},
					methods:{
						isLogin:function(){
							if(new Date().getTime()-10*60*1000-1000>this.lastTime){//上次检测时间十分钟后才能检测,1秒误差
								this.lastTime=new Date().getTime();
								var self=this;
								$.execJSON('action/manageAdminLogin/isLogin',this.loginInfo,function(json){
									console.log(json);
									if(json.codeVerify) loginVue.codeVerify=true;
									if(json.code==0&&null!=json.model){
										loginVue.tologin=false;
										loginVue.loginBackground=false;
										loginVue.loginCode=false;
										self.modelInfo=json.model;
									}else{
										loginVue.tologin=true;
										loginVue.loginBackground=true;
										loginVue.loginCode=true;
										self.modelInfo={};
									}
								},false,true);
							}
						},
						doLogin:function(){
							loginVue.loginCode=false;
							var self=this;
							this.loginInfo['autoLogin']=this.autoLogin?"Y":"N";
							$.execJSON('action/manageAdminLogin/doLogin',this.loginInfo,function(json){
								console.log(json);
								if(json.code==0){
									loginVue.loginMessage="";
									pageVue.$Message.success(json.msg);
									loginVue.tologin=false;
									loginVue.loginBackground=false;
									loginVue.codeVerify=false;
									self.modelInfo=json.model;
								}else{
									loginVue.loginMessage=json.msg;
									loginVue.tologin=true;
									loginVue.loginBackground=true;
									loginVue.loginCode=true;
									loginVue.codeVerify=true;
									self.modelInfo={};
								}
							});
						},
						setTimer:function(){
							loginTimer=setTimeout(function(){
								loginVue.isLogin();
							},10*60*1000);//每过十分钟检查登录是否超时
						},
						resetTimer:function(){//重置
							this.clearTimer();
							this.setTimer();
						},
						clearTimer:function(){//window失去焦点调用
							if(loginTimer){//清除定时检测
								clearTimeout(loginTimer);
								loginTimer=null;
							}
						}
					},
					watch:{
						loginBackground:function(val,old){
							if(!val){
								$.execJSON('action/manageGroupMenuLink/getModuleList',{},function(json){
									if(json.code==0){
										var menuMap={};
										for(var a in json.modules){
											for(var b in json.modules[a].menus){
												for(var c in json.modules[a].menus[b].menus){
													menuMap[c]=[json.modules[a],json.modules[a].menus[b],json.modules[a].menus[b].menus[c]];
												}
											}
										}
										if(!loginVue.modelInfo.headImage)loginVue.modelInfo.headImage={thumPath:''};
										$.vue['main_admin'].modelInfo=loginVue.modelInfo;
										$.vue['main_admin'].modules=json.modules;
										$.vue['main_admin'].menuMap=menuMap;
										$.vue['main_admin'].init=true;
										if(json.defaultMenuOid){
											$.vue['main_admin'].setDefaultMenu(json.defaultMenuOid);
											$.execJSON('action/manageAdminGroup/getMyOrgGroup',{},function(json){
												if(json.code==0){
													$.vue['main_admin'].orgGroups=json.list;
												}
											});
										}else{
											pageVue.$Message.error("没有菜单");
										}
									}else{
										pageVue.$Message.error(json.msg);
									}
								});
							}
						}
					}
				});
			
				$(window).on('hashchange',function(){
					$.vue['main_admin'].hashChange();
				});
				$(window).on('resize',function(){
					$("#main_page").css({height:$(window).height()});
				});
				$(window).on('focus',function(){
					loginVue.isLogin();
				});
				$(window).on('blur',function(){
					loginVue.clearTimer();
				});
				$("#main_page").css({height:$(window).height()});
				$(document.body).append("<script type=\"text/javascript\" src=\"https://webapi.amap.com/maps?v=1.4.8&key=97aa8a15d5a9bc783e16236cc66d3662\"><\/script>");
			});
		}
		var jsList=[
			"/resources/default/admin.js",
			"/custom/admin.js"];
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
						$("#load_js").html('${map.systemInfo.backgroundTitle }<br/><small>加载完成</small>').fadeOut(1000);
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
						$("#load_js").html('${map.systemInfo.backgroundTitle }<br/><small>'+self.s+'资源加载中 '+self.n+"%"+self.s+"</small>");
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
			if($("script").length!=9){location.reload();}
			loadJs();
		});
		</script>
	</body>
</html>