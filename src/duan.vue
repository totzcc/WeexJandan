<template >
	<div class="container">
		<waterfall column-count="2">
			<cell v-for="item in datalist">
				<div class='item'>
					<text>{{item.text}}</text>
				</div>
			</cell>
			<loading class="loading" @loading="onloading" :display="showLoading">
		      <text class="indicator">{{loadingTips}}</text>
		    </loading>
		</waterfall>
	</div>
</template>
<style>
	.container{padding-top: 35px; padding-left: 10px}
	.item{border-radius: 10px;background-color: #e3e3e3;padding: 10px;margin-top: 15px;}
	.loading{width: 750px; padding-bottom: 40px; align-items: center;justify-content: center;}
</style>
<script>
	import jandan from './services/jandan'
	export default {
		data: {
			datalist:[],
			maxPage:0,
			showLoading:'hide',
		},
		computed:{
			loadingTips(){
				if(!this.datalist || this.datalist.length == 0){
					return '加载中...'
				}
				return this.showLoading == 'hide' ? '上拉加载更多' : '加载中...'
			}
		},
		created() {
			jandan.duan().then((response)=>{
				this.datalist = response.datalist
				if(response.maxPage) {
					this.maxPage = response.maxPage
				}
			})
		},
		methods: {
			onloading(){
		        this.showLoading = 'show'
		        jandan.duan(this.maxPage - 1).then(response =>{
		        		this.datalist = this.datalist.concat(response.datalist)
		        		this.maxPage -= 1
		        		this.showLoading = 'hide'
		        })
			}
		}
	}
</script>