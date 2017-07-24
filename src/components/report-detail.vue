<template>
    <navpage
            dataRole="none"
            :height="config.barHeight()"
            title="不良信息举报"
            backgroundColor="#ffffff"
            titleColor="#333333"
            :leftItemSrc="config.image('back.png')"
            @naviBarLeftItemClick="naviBarLeftItemClick">
        <scroller class="container">
            <div class="header">
                <text class="header-text">请选择举报类型</text>
            </div>
            <div class="item" v-for="v in types" @click="click" :item="v">
                <text class="item-text">{{v.content}}</text>
                <image v-if="v.selected" :src="image.selected" class="item-image"/>
            </div>
            <div class="confirm" @click="report">
                <div class="confirm-btn" :style="{backgroundColor:canReport ? '#0088fb' : '#999999'}">
                    <text class="confirm-btn-text">确定举报</text>
                </div>
            </div>
        </scroller>
    </navpage>
</template>
<script>
    import config from '../config'
    const modal = weex.requireModule('modal');
    const navigator = weex.requireModule('navigator')
    export default {
        data: {
            config:config,
            types: [
                {
                    selected: false,
                    content: '欺诈'
                },
                {
                    selected: false,
                    content: '色情'
                },
                {
                    selected: false,
                    content: '不实信息'
                },
                {
                    selected: false,
                    content: '违法犯罪'
                },
                {
                    selected: false,
                    content: '骚扰'
                },
                {
                    selected: false,
                    content: '其他'
                }
            ],
            image: {
                selected: config.image('selected.png')
            }
        },
        computed: {
            canReport(){
                for (var index = 0; index < this.types.length; index++) {
                    if (this.types[index].selected) {
                        return true
                    }
                }
                return false
            }
        },
        components:{
            navpage:require('../include/navpage.vue')
        },
        methods: {
            click(e){
                e.target.attr.item.selected = !e.target.attr.item.selected;
            },
            report(e){
                if (this.canReport) {
                    modal.alert({
                        message: '感谢您的反馈,我们将尽快处理!'
                    },this.naviBarLeftItemClick)
                }
            },
            naviBarLeftItemClick(){
                navigator.pop({},()=>{})
            }
        }
    }
</script>
<style>
    .container {
        background-color: #f3f3f3;
    }

    .header {
        padding-top: 40px;
        padding-left: 20px;
        height: 100px;
        justify-content: center;
    }

    .header-text {
        color: #666666;
    }

    .item {
        height: 100px;
        padding: 20px;
        flex-direction: row;
        align-items: center;
        justify-content: space-between;
        background-color: #ffffff;
        border-bottom-color: #e3e3e3;
        border-bottom-width: 1px;
    }

    .item-image {
        width: 40px;
        height: 40px;
    }

    .confirm {
        margin-top: 50px;
        justify-content: center;
        align-items: center;
    }

    .confirm-btn {
        width: 500px;
        height: 88px;
        border-radius: 10px;
        background-color: #0088fb;
        justify-content: center;
        align-items: center;
    }

    .confirm-btn-text {
        color: #ffffff;
    }
</style>