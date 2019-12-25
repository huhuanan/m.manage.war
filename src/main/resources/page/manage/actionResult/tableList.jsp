<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<page>
	<transition name="slide-fade-right">
	<div name="_table_list" v-show="showList">
		<c:if test="${!empty map.openKey&&!empty map.title}"><h3>${map.title }</h3></c:if>
		<div style="${fn:length(map.vulist.top)>0?'margin-bottom:10px;':'' }"><c:forEach var="vui" items="${map.vulist.top }">${vui }</c:forEach></div>
		<div style="${map.openMode=='INNER'?'text-align:right;':'' }">
		<button-group style="margin-bottom:10px;margin-right:10px;${map.openMode=='PAGE'||!map.hiddenQueryList?'':'display:none;'}" >
		<c:if test="${map.openMode=='PAGE' }">
			<i-button type="default" @click="back(false)"><i class="iconfont">&#xe718;</i>&nbsp;返回&nbsp;</i-button>
		</c:if>
		<c:if test="${!map.hiddenQueryList }">
			<i-button type="default" @click="searchPanel=true;"><i class="iconfont">&#xe6ac;</i>&nbsp;过滤&nbsp;</i-button>
			<modal width="500" :footer-hide="true" v-model="searchPanel" >
				<h3>过滤</h3>
				<card>
				<i-form :model="param" :label-width="130" inline style="margin-top:10px;">
				<c:if test="${!empty map.searchHint }">
					<form-item label="搜索:" style="margin-bottom:10px;">
						<i-input v-model="param['searchText']" placeholder="${map.searchHint }" style="width:260px;"></i-input>
					</form-item>
				</c:if>
				<c:forEach var="item" items="${map.tableQueryList }">
				<c:if test="${item.type=='HIDDEN' }">
					<input type="hidden" v-model="param['params[${item.field }]']" />
				</c:if>
				<c:if test="${item.type!='HIDDEN' }">
				<div>
					<form-item label="${item.name }:" style="margin-bottom:10px;">
					<c:if test="${item.type=='TEXT' }">
						<i-input v-model="param['params[${item.field }]']" placeholder="${item.hint }" @on-blur="doClearField('${item.field }')" style="width:260px;"></i-input>
					</c:if>
					<c:if test="${item.type=='SELECT' }">
					<i-select ref="${item.field }" v-model="param['params[${item.field }]']" style="width:260px;" @on-change="doClearField('${item.field }');" :filterable="true" :transfer="true" :clearable="true">
						<i-option v-for="item in selectDatas['${item.field }']" :value="item.value" :key="item.value">{{ item.label }}</i-option>
					</i-select>
					</c:if>
					<c:if test="${item.type=='SELECT_NODE' }">
					<cascader :data="selectDatas['${item.field }']" trigger="hover" :filterable="true" style="width:260px;" v-model="cascaders['${item.field }']" @on-change="doClearField('${item.field }',arguments);" placeholder="${item.hint }" ></cascader>
					</c:if>
					<c:if test="${item.type=='INT_RANGE' }">
					<input-number v-model="param['params[${item.field }down]']" :style="{width:'123px'}" @on-blur="doClearField('${item.field }')" placeholder="下限"></input-number> ~ 
					<input-number v-model="param['params[${item.field }up]']" :style="{width:'123px'}" @on-blur="doClearField('${item.field }')" placeholder="上限"></input-number>
					</c:if>
					<c:if test="${item.type=='DOUBLE_RANGE' }">
					<input-number v-model="param['params[${item.field }down]']" :style="{width:'123px'}" @on-blur="parseNumber('params[${item.field }down]',6);doClearField('${item.field }')" placeholder="下限"></input-number> ~ 
					<input-number v-model="param['params[${item.field }up]']" :style="{width:'123px'}" @on-blur="parseNumber('params[${item.field }up]',6);doClearField('${item.field }')" placeholder="上限"></input-number>
					</c:if>
					<c:if test="${item.type=='DATE_RANGE' }">
					<date-picker type="datetime" v-model="param['params[${item.field }down]']" format="${item.dateFormat }" @on-change="doClearField('${item.field }');" placeholder="下限" style="width:123px;" :transfer="true"></date-picker> ~ 
					<date-picker type="datetime" v-model="param['params[${item.field }up]']" format="${item.dateFormat }" @on-change="doClearField('${item.field }');" placeholder="上限" style="width:123px;" :transfer="true"></date-picker>
					</c:if>
					</form-item>
				</div>
				</c:if>
				</c:forEach>
				<c:if test="${fn:length(map.hiddenCols)>2}">
					<form-item label="隐藏列:" style="margin-bottom:10px;">
					<poptip trigger="hover" width="380" :transfer="true" :word-wrap="true" padding="10px 0 2px 10px">
						<div style="display:block;width:260px;">
							<template v-for="item in allColumns"><tag color="default" v-if="isHiddenCol(item.field)">{{item.title}}</tag></template>
							<span v-if="hiddenCols.length==0">设置隐藏列</span>
						</div>
						<checkbox-group slot="content" v-model="hiddenCols" >
							<template v-for="item in allColumns">
						        <checkbox v-if="item.title" :label="item.field"><span style="display:inline-block;min-width:90px;margin-bottom:8px;">{{item.title}}</span></checkbox>
							</template>
					    </checkbox-group>
				    </poptip>
					</form-item>
				</c:if>
				</i-form>
				</card>
				<div style="text-align:right;margin-top:10px;">
					<i-button type="primary" @click="queryList" ><i class="iconfont">&#xe6ac;</i>&nbsp;查询&nbsp;</i-button>
				</div>
			</modal>
		</c:if>
		</button-group>
		<button-group v-if="tableButtons.length>0&&tableDropButtons.length>0" style="margin-bottom:10px;">
			<i-button v-for="item in tableButtons" :key="item.title" :type="item.style" @click="toolsHandler(item.param)"><i class="iconfont" v-html="item.icon"></i>&nbsp;<span>{{item.title}}</span>&nbsp;</i-button>
			<i-button v-for="item in tableDropButtons" :key="item.title" :type="item.style">
				<dropdown @on-click="toolsHandler(item.buttons[$event].param)" :transfer="true">
					<i class="iconfont" v-html="item.icon"></i>&nbsp;<span>{{item.title}}</span>&nbsp;
					<icon type="ios-arrow-down"></icon>
					<dropdown-menu slot="list">
						<dropdown-item v-for="(btn,index) in item.buttons" :name="index"><i class="iconfont" v-html="btn.icon"></i>&nbsp;<span :style="{'color':fn_color(btn.style)}">{{btn.title}}</span>&nbsp;</dropdown-item>
					</dropdown-menu>
				</dropdown>
			</i-button>
		</button-group>
		<c:forEach var="vui" items="${map.vulist.buttonRight }">${vui }</c:forEach>
		</div><%-- button-group --%>
		<div>
			<div style="${fn:length(map.vulist.middle)>0?'margin-bottom:10px;':'' }"><c:forEach var="vui" items="${map.vulist.middle }">${vui }</c:forEach></div>
			<c:if test="${!empty map.alert}">
				<alert show-icon type="${map.alert.type }" style="margin-bottom:10px;padding-right:8px;">${map.alert.title }
					<c:if test="${!empty map.alert.icon}"><icon type="${map.alert.icon}" slot="icon"></icon></c:if>
					<c:if test="${!empty map.alert.desc}"><div slot="desc">${map.alert.desc }</div></c:if>
				</alert>
			</c:if>
		</div>
		<div>
		<i-table ref="itable" :loading="tableLoading" :height="tableHeight" :columns="columns" :data="datas" size="small" :stripe="false" :border="true" :highlight-row="true" @on-sort-change="sortHandler" @on-selection-change="selectHandler"
			:show-summary="null!=countData" :summary-method="summaryMethod" :span-method="spanMethod" @on-row-click="rowClickHandler"></i-table>
		</div>
		<div style="${map.openMode=='INNER'?'text-align:right;':'' }">
		<page style="margin-top:10px;" :total="count" :current="param.pageNo" :page-size="param.pageNum" show-elevator show-total show-sizer transfer @on-change="changePageNo" @on-page-size-change="changePageNum">
			<i-button type="default" @click="query"><i class="iconfont">&#xe6aa;</i>&nbsp;刷新&nbsp;</i-button>
			&nbsp;共 {{count}} 条
		</page>
		</div>
		<div style="${fn:length(map.vulist.bottom)>0?'margin-top:10px;':'' }"><c:forEach var="vui" items="${map.vulist.bottom }">${vui }</c:forEach></div>
	</div>
	</transition>
	<transition name="slide-fade-right">
	<div v-show="showPage" >
		<div id="_table_page_${key }"></div>
	</div>
	</transition>
	<modal v-model="showModal" :footer-hide="true" :width="modalWidth" :mask-closable="false" @on-cancel="handlerResult(backEvent,'MODAL',false)">
		<div id="_table_modal_${key }"></div>
	</modal>
	<modal v-model="loadModal.show" :footer-hide="true" width="300" :closable="false">
		<div style="text-align:center"><i-progress :percent="loadModal.percent"></i-progress></div>
		<div style="text-align:center" v-html="loadModal.content"></div>
	</modal>
</page>
<script>
(function(){
	return { //vue对象属性
		components:{
			"expand-row":{
				template:`<div style="padding:5px ${map.expandPadding[1]}px 5px ${map.expandPadding[0]}px">
					<div v-if="showHiddenCol">
						<template v-for="item in allColumns">
							<span v-if="isHiddenCol(item.field)&&item.key!='oid'" v-html="toText(item)"></span>
						</template>
					</div>
					<div>${map.expandRow.template}</div>
					<div ref="url">${map.expandRow.url}</div>
				</div>`,
				props:['openKey','rowIndex','row','raw','allColumns','hiddenCols'],
				data(){
					return {showHiddenCol:${map.expandRow.showHiddenCol}};
				},
				mounted:function(){
					this.$el.parentNode.style.padding="3px";
					var url=this.$refs['url'].innerHTML.replace(/\|and\|/ig,"&");
					if(url){
						$.loadVuePage(this.$refs['url'],
							url,$.convertJSONData(url,{openMode:'INNER',openKey:this.openKey,rowIndex:this.rowIndex}),
							(function(vueObj,vueId){
							}).bind(this)
						);
					}
				},
				methods:{
					isHiddenCol:function(field){
						return this.hiddenCols.indexOf(field)>=0;
					},
					toText:function(col){
						console.log(this.raw,col.key,this.raw[col.key]);
						if(col.colType=='color') html='<span style="padding:5px;display:inline-block;width:100px;">'+col.title+' : <span style="padding:0 7px;background-color:'+this.raw[col.key]+'"></span></span>';
						else html='<span style="padding:5px;display:inline-block;width:'+(col.width+50)+'px;">'+col.title+' : '+(this.raw[col.key]||'')+'</span>';
						return html;
					},
				}
			}
		},
		data(){
			return{
				//key:'',
				//openKey:'',
				openMode:'',
				backEvent:'',
				backSuccess:false,
				searchPanel:false,
				showList:true,
				showPage:false,
				showModal:false,
				loadModal:{
					show:false,
					content:"",
					percent:0
				},
				tableLoading:true,
				modalWidth:0,
				param:[],
				cascaders:{},
				tableHeight:${map.tableHeight},
				dataUrl:'${map.dataUrl}',
				rowspanIndex:${map.rowspanIndex},
				rowspanNum:${map.rowspanNum},
				datas:[],
				countData:null,
				selected:[],
				row:{},//单选的行
				count:0,
				page:{no:1,size:10},
				tableButtons:${map.tableButtons},
				tableDropButtons:${map.tableDropButtons},
				hiddenCols:${map.hiddenCols},
				allColumns:${map.tableCols},
				columns:[],
				selectMethod:{},
				selectDatas:{},
				clearField:{}
			};
		},
		mounted:function(){
			var param={};
			param['pageNo']=1;
			param['pageNum']=10;
			var selectMethod={};
			var selectDatas={};
			var clearField={};
			<c:if test="${!empty map.searchHint }">
			param['searchText']="";
			</c:if>
			<c:forEach var="item" items="${map.tableQueryList }">
				clearField['${item.field}']='${item.clearField}';
				<c:if test="${item.type=='HIDDEN'||item.type=='TEXT'||item.type=='SELECT'||item.type=='SELECT_NODE'}">
					param['params[${item.field }]']="${map.params[item.field]}";
				</c:if>
				<c:if test="${item.type=='SELECT'||item.type=='SELECT_NODE'}">
					selectDatas["${item.field}"]=[];
					<c:forEach var="op" items="${item.selectData}">selectDatas["${item.field}"].push({value:"${op[0] }",label:"${op[1] }"});</c:forEach>
					<c:if test="${!empty item.selectParam}">selectMethod["${item.field}"]=${item.selectParam};</c:if>
				</c:if>
				<c:if test="${item.type=='INT_RANGE'||item.type=='DOUBLE_RANGE'||item.type=='DATE_RANGE'}">
					param['params[${item.field }down]']="${map.params[item.field.concat('down')]}";
					param['params[${item.field }up]']="${map.params[item.field.concat('up')]}";
				</c:if>
			</c:forEach>
			this.param=param;
			this.selectMethod=selectMethod;
			this.selectDatas=selectDatas;
			<c:forEach var="item" items="${map.tableQueryList }">
				<c:if test="${item.type=='SELECT_NODE'}"> this.setCascaderValue("${item.field }"); </c:if>
			</c:forEach>
			this.clearField=clearField;
			this.initSelectMethod();
			this.initSort();
			this.query();
		},
		methods:$.vueTableListMethods
	};
})();
</script>
