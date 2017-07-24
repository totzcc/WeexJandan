<template>
    <div class="container">
        <list>
            <refresh class="refresh" @refresh="onrefresh" :display="showRefresh" v-if="datalist">
                <text class="indicator">{{refreshTips}}</text>
            </refresh>
            <cell style="height: 30px;"></cell>
            <cell v-if="!datalist">
                <div v-if="!datalist" style="width: 750px; height: 100px; align-items:center;justify-content: center;">
                    <text>Loading...</text>
                </div>
            </cell>
            <cell v-for="item in datalist" @click="click" :item="item">
                <!--<report/>-->
                <report></report>
                <div class="item">
                    <text style="color: #333333;">{{item.title}}</text>
                    <div style="flex-direction: row; align-items: center; justify-content: space-between; margin-top: 5px; padding: 5px;"
                         class="item-box">
                        <div>
                            <text style='color: #666666; font-size: 28;'>{{item.author}}</text>
                            <text style='color: #999999; font-size: 24;'>{{item.time}}</text>
                        </div>
                        <image v-if="item.vote==1" class="like-item" :src="config.image('like.png')"></image>
                        <image v-if="item.vote==0" class="like-item" :src="config.image('dislike.png')"></image>
                    </div>
                    <div style="flex-direction: row; justify-content: space-between; align-items: center;">
                        <div style="flex-direction: row;">
                            <div style="flex: 1; border-right-width: 0px; height: 55px;" class="item-box-center"
                                 @click='support' :item="item" vote-type="1">
                                <text style="color:#FF4D33;">OO</text>
                                <text style="color:#FE0000;">[{{item.support}}]</text>
                            </div>
                            <div style="flex: 1;height: 55px; margin-left: 30;" class="item-box-center" @click='support'
                                 :item="item" vote-type="0">
                                <text style="color: #999999;">XX</text>
                                <text style="color: #666666;">[{{item.unsupport}}]</text>
                            </div>
                        </div>
                        <div>
                            <text style="color: #666666;">吐槽 {{item.tucao}}</text>
                        </div>
                    </div>
                </div>
                <div style="height: 10px; background-color: #f3f3f3;"></div>
            </cell>
            <cell style="height: 20px;"></cell>
            <loading class="loading" @loading="onloading" :display="showLoading" v-if="datalist">
                <text class="indicator">{{loadingTips}}</text>
            </loading>
        </list>
    </div>
</template>
<style>
    .container {
        padding-left: 10px;
        background-color: #f3f3f3;
    }

    .item {
        padding: 10px;
        padding-bottom: 0px;
        background-color: #FFFFFF;
        border-width: 1px;
        border-color: #e3e3e3;
    }

    .item-box {
        border-width: 1px;
        border-color: #e3e3e3;
        border-style: dashed;
    }

    .item-box-center {
        align-items: center;
        justify-content: center;
        flex-direction: row;
    }

    .refresh {
        width: 750px;
        height: 100px;
        align-items: center;
        justify-content: center;
    }

    .loading {
        width: 750px;
        height: 100px;
        align-items: center;
        justify-content: center;
    }

    .like-conver {
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        justify-content: center;
        align-items: center;
    }

    .like {
        width: 300px;
        height: 300px;
        opacity: 0;
    }

    .like-item {
        width: 50px;
        height: 50px;
    }

    .report {
        /*height:100px;*/
        background-color: white;
        flex-direction: row;
        justify-content: flex-end;
        padding: 30px;
        color: red;
    }

    .report-image {
        width: 30px;
        height: 30px;
    }
</style>
<script>
    import config from './config'
    import jandan from './services/jandan'
    import jandanComments from './services/jandan-comments'
    import animation from './animation/animation'
    const browser = weex.requireModule('browser')
    const storage = weex.requireModule('storage')
    const navigator = weex.requireModule('navigator')
    const modal = weex.requireModule('modal')
    export default {
        data: {
            config: config,
            datalist: null,
            maxPage: 0,
            showRefresh: 'hide',
            showLoading: 'hide',
            lastClickObj: {item: null, timestamp: 0},
            isSingleClick: true,
            type: 'joke'
        },
        computed: {
            loadingTips(){
                if (!this.datalist || this.datalist.length == 0) {
                    return '加载中...'
                }
                return this.showLoading == 'hide' ? '上拉加载更多' : '加载中...'
            },
            refreshTips(){
                return this.showRefresh == 'hide' ? '下拉获取最新数据' : '加载中...'
            }
        },
        created() {
            this.onrefresh(true)
        },
        components: {
            report: require('./components/report.vue')
        },
        methods: {
            getUrlParam (key) {
                var reg = new RegExp('[?|&]' + key + '=([^&]+)')
                var match = weex.config.bundleUrl.match(reg)
                return match && match[1]
            },
            onrefresh(readCache){
                var cache = false
                if (readCache == true) {
                    cache = true
                }
                this.showRefresh = 'show'
                jandan.list(this.type, null, cache).then((response) => {
                    this.showRefresh = 'hide'
                    this.datalist = response.datalist
                    if (response.maxPage) {
                        this.maxPage = response.maxPage
                    }
                })
            },
            onloading(){
                this.showLoading = 'show'
                this.maxPage -= 1
                jandan.list(this.type, this.maxPage).then(response => {
                    this.showLoading = 'hide'
                    setTimeout(() => {
                        this.datalist = this.datalist.concat(response.datalist)
                    }, 500)
                })
            },
            support(e){
                const item = e.target.attr.item
                const voteType = e.target.attr.voteType
                if (item.vote) {
                    return
                }
                item.vote = voteType
                jandanComments.vote(item.id, voteType).then(res => {
                    if (voteType == 1) {
                        item.support += 1
                    } else {
                        item.unsupport += 1
                    }
                })
            },
            click(e){
                const item = e.target.attr.item
                storage.setItem('joke-detail', JSON.stringify(item), (e) => {
                    navigator.push({url: config.js('joke-detail.js')}, () => {
                    })
                })
            }
        }
    }
</script>