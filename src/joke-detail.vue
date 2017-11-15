<template>
    <navpage
            dataRole="none"
            :height="config.barHeight()"
            title="评论列表"
            backgroundColor="#ffffff"
            titleColor="#333333"
            :leftItemSrc="config.image('back.png')"
            :rightItemSrc="config.image('reply.png')"
            @naviBarLeftItemClick="naviBarLeftItemClick"
            @naviBarRightItemClick="naviBarRightItemClick">
        <list style="background-color: #f3f3f3;">
            <cell style="height: 44px;"></cell>
            <cell>
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
                                <text style="color:#FE0000;">{{item.support}}</text>
                            </div>
                            <div style="flex: 1;height: 55px; margin-left: 30;" class="item-box-center" @click='support'
                                 :item="item" vote-type="0">
                                <text style="color: #999999;">XX</text>
                                <text style="color: #666666;">{{item.unsupport}}</text>
                            </div>
                        </div>
                        <div>
                            <text style="color: #666666;">吐槽 {{item.tucao}}</text>
                        </div>
                        <report/>
                    </div>
                </div>
            </cell>
            <cell style="height: 30;"></cell>
            <cell v-for="v in hotTucao" style="background-color: #f3f3f3">
                <div style="padding: 20; border-bottom-width: 1; border-color: #f3f3f3;">
                    <div style="flex-direction: row; justify-content: space-between;">
                        <div style="flex-direction: row;align-items: center;">
                            <text style="color: #666666;">{{v.comment_author}}</text>
                            <text style="color: #999999;"> @{{v.comment_date}}</text>
                        </div>
                        <div style="flex-direction: row; align-items: center;">
                            <div style="flex: 1; border-right-width: 0px; height: 55px;" class="item-box-center"
                                 @click='supportComment' :item="v" vote-type="1">
                                <text style="color:#FF4D33;">OO</text>
                                <text style="color:#FE0000;">{{v.vote_positive}}</text>
                            </div>
                            <div style="flex: 1;height: 55px;" class="item-box-center" @click='supportComment' :item="v"
                                 vote-type="0">
                                <text style="color: #999999;"> XX</text>
                                <text style="color: #666666;">{{v.vote_negative}}</text>
                            </div>
                        </div>
                    </div>
                    <text style="color: #333333;">{{v.comment_content}}</text>
                    <report/>
                </div>
            </cell>
            <cell v-for="v in tucao" style="background-color: #FFFFFF">
                <div style="padding: 20; border-bottom-width: 1; border-color: #f3f3f3;">
                    <div style="flex-direction: row; justify-content: space-between;">
                        <div style="flex-direction: row;align-items: center;">
                            <text style="color: #666666;">{{v.comment_author}}</text>
                            <text style="color: #999999;"> @{{v.comment_date}}</text>
                        </div>
                        <div style="flex-direction: row; align-items: center;">
                            <div style="flex: 1; border-right-width: 0px; height: 55px;" class="item-box-center"
                                 @click='supportComment' :item="v" vote-type="1">
                                <text style="color:#FF4D33;">OO</text>
                                <text style="color:#FE0000;">{{v.vote_positive}}</text>
                            </div>
                            <div style="flex: 1;height: 55px;" class="item-box-center" @click='supportComment' :item="v"
                                 vote-type="0">
                                <text style="color: #999999;"> XX</text>
                                <text style="color: #666666;">{{v.vote_negative}}</text>
                            </div>
                        </div>
                    </div>
                    <text style="color: #333333;">{{v.comment_content}}</text>
                    <report/>
                </div>
            </cell>
        </list>
    </navpage>
</template>

<script>

    let storage = weex.requireModule('storage')
    const navigator = weex.requireModule('navigator')
    import config from './config'
    import stream from './services/jandan-stream'
    import jandanComments from './services/jandan-comments'
    export default {
        components: {
            navpage: require('./include/navpage.vue'),
            report: require('./components/report.vue')
        },
        data() {
            return {
                config: config,
                item: {
                    title: '',
                    author: '',
                    time: '',
                    support: '',
                    unsupport: '',
                    id: ''
                },
                hotTucao: [],
                tucao: []
            }
        },
        created() {
            storage.getItem('joke-detail', (e) => {
                this.item = JSON.parse(e.data)
                stream.fetch({
                    method: 'get',
                    url: 'http://jandan.net/tucao/' + this.item.id,
                    type: 'json'
                }, (res) => {
                    let hotTucao = res.data.hot_tucao
                    let tucao = res.data.tucao
                    this.handleDate(hotTucao)
                    this.handleDate(tucao)
                    this.hotTucao = hotTucao
                    this.tucao = tucao
                    this.item.tucao = tucao.length
                })
            })
        },
        methods: {
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
            supportComment(e){
                const item = e.target.attr.item
                const voteType = e.target.attr.voteType
                if (item.vote) {
                    return
                }
                item.vote = voteType
                jandanComments.vote(item.comment_ID, voteType).then(res => {
                    if (voteType == 1) {
                        item.vote_positive = parseInt(item.vote_positive) + 1
                    } else {
                        item.vote_negative = parseInt(item.vote_negative) + 1
                    }
                })
            },
            naviBarRightItemClick(e){
                storage.setItem('REPLY_COMMENTS', JSON.stringify({
                    postId: this.item.id,
                    type: 'tucao',
                    placeholder: '回复吐槽：' + this.item.title
                }), () => {
                    navigator.push({url: config.js('comment-submit.js')})
                })
            },
            naviBarLeftItemClick(e){
                navigator.pop({}, () => {
                })
            },
            handleDate(tucao) {
                tucao.forEach((value) => {
                    let timestamp = this.getDateTimeStamp(value.comment_date)
                    let diff = this.getDateDiff(timestamp)
                    value.comment_date = diff
                })
            },
            getDateDiff(dateTimeStamp) {
                var minute = 1000 * 60;
                var hour = minute * 60;
                var day = hour * 24;
                var halfamonth = day * 15;
                var month = day * 30;
                var now = new Date().getTime();
                var diffValue = now - dateTimeStamp;
                if (diffValue < 0) {
                    return;
                }
                var monthC = diffValue / month;
                var weekC = diffValue / (7 * day);
                var dayC = diffValue / day;
                var hourC = diffValue / hour;
                var minC = diffValue / minute;
                var result = ""
                if (monthC >= 1) {
                    result = "" + parseInt(monthC) + "月前";
                } else if (weekC >= 1) {
                    result = "" + parseInt(weekC) + "周前";
                } else if (dayC >= 1) {
                    result = "" + parseInt(dayC) + "天前";
                } else if (hourC >= 1) {
                    result = "" + parseInt(hourC) + "小时前";
                } else if (minC >= 1) {
                    result = "" + parseInt(minC) + "分钟前";
                } else
                    result = "刚刚";
                return result;
            },
            getDateTimeStamp(dateStr) {
                return Date.parse(dateStr.replace(/-/gi, "/"));
            }
        }
    }
</script>

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
</style>