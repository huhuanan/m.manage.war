<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/m_common.tld" prefix="mc" %>
<page>
	<i-button @click="viewCache" style="margin-bottom:8px;">查看缓存</i-button>
	<i-table :columns="columns" :data="data" width="100%" size="small"></i-table>
	<modal v-model="showCache" :footer-hide="true" :width="1000">
		<tabs value="cacheHost" :animated="false">
			<span slot="extra" style="line-height:35px;">主机:{{model.ipport}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<tab-pane v-if="selectHost>=0" label="主机缓存" name="cacheHost">
				<row>
					<i-col :span="6">
						<cell-group>
							<cell v-for="(item,index) in cacheHost" :title="item.key" :selected="selectHost==index" @click.native="selectHost=index" />
						</cell-group>
					</i-col>
					<i-col :span="18">
						<card :dis-hover="true">
						<div>{{cacheHost[selectHost].key}}</div>
						<json-val :json-val="cacheHost[selectHost].value" :current-depth="0" :max-depth="1" :last="true"></json-val>
						</card>
					</i-col>
				</row>
			</tab-pane>
			<tab-pane v-if="selectMap>=0" label="单Key缓存" name="cacheMap">
				<row>
					<i-col :span="6">
						<cell-group>
							<cell v-for="(item,index) in cacheMap" :title="item.key" :selected="selectMap==index" @click.native="selectMap=index" />
						</cell-group>
					</i-col>
					<i-col :span="18">
						<card :dis-hover="true">
						<json-val :json-val="cacheMap[selectMap].value" :current-depth="0" :max-depth="1" :last="true"></json-val>
						</card>
					</i-col>
				</row>
			</tab-pane>
			<tab-pane v-if="selectMap2>=0" label="双Key缓存" name="cacheMap2">
				<row>
					<i-col :span="6">
						<cell-group>
							<cell v-for="(item,index) in cacheMap2" :title="item.key" :selected="selectMap2==index" @click.native="selectMap2=index" />
						</cell-group>
					</i-col>
					<i-col :span="18">
						<card :dis-hover="true">
						<json-val :json-val="cacheMap2[selectMap2].value" :current-depth="0" :max-depth="1" :last="true"></json-val>
						</card>
					</i-col>
				</row>
			</tab-pane>
			<tab-pane v-if="selectList>=0" label="单Key列表缓存" name="cacheList">
				<row>
					<i-col :span="6">
						<cell-group>
							<cell v-for="(item,index) in cacheList" :title="item.key" :selected="selectList==index" @click.native="selectList=index" />
						</cell-group>
					</i-col>
					<i-col :span="18">
						<card :dis-hover="true">
						<json-val :json-val="cacheList[selectList].value" :current-depth="0" :max-depth="1" :last="true"></json-val>
						</card>
					</i-col>
				</row>
			</tab-pane>
		</tabs>
	</modal>
</page>
<script>
(function(){
	return { //vue对象属性
		data(){
			return{
				columns: [
					{title: 'ID',key: 'oid',align:'center'},
					{title: 'IPPORT',key: 'ipport',align:'center'},
					{title: 'JVM内存',key: 'memory',align:'center'},
					{title: 'db链接',key: 'dbLinkNum',align:'center'},
					{title: '创建时间',key: 'createDate',align:'center'},
					{title: '最后链接',key: 'lastDate',align:'center'},
				],
				data:[],
				model:{},
				showCache:false,
				cacheHost:[],
				selectHost:-1,
				cacheMap:[],
				selectMap:-1,
				cacheMap2:[],
				selectMap2:-1,
				cacheList:[],
				selectList:-1,
			}
		},
		mounted:function(){
			<c:forEach var="item" items="${list}">
			this.data.push({oid:'${item.oid }',ipport:'${item.ipport }',memory:'${item.freeMemory} / ${item.totalMemory} / ${item.maxMemory}',dbLinkNum:'${item.dbUseLinkNum} / ${item.dbMaxLinkNum}',
				createDate:'${mc:toFormatStyle(item.createDate,"yyyy-MM-dd HH:mm")}',lastDate:'${mc:toFormatStyle(item.lastDate,"yyyy-MM-dd HH:mm")}'});
			</c:forEach>
		},
		methods:{
			viewCache:function(){
				this.getCacheList();
				this.showCache=true;
			},
			getCacheList:function(){
				$.execJSON("action/manageHostInfo/getCacheList",
					{},
					(function(data){
						if(data.code==0){
							this.model=data.model;
							this.cacheHost=data.cacheHost;
							if(this.cacheHost.length>0) this.selectHost=0;
							this.cacheMap=data.cacheMap;
							if(this.cacheMap.length>0) this.selectMap=0;
							this.cacheMap2=data.cacheMap2;
							if(this.cacheMap2.length>0) this.selectMap2=0;
							this.cacheList=data.cacheList;
							if(this.cacheList.length>0) this.selectList=0;
							console.log(data);
						}
					}).bind(this)
				);
			},
		}
	};
})();
</script>
