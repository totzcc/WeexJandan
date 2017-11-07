<template>
    <div class='rich-container'>
        <div v-for="item in nodes" :key="item">
            <image v-if='item.name == "img"' :src='item.src' class="img" resize='cover' @click='clickImage'></image>
            <text v-if='item.text' class='text'>{{item.text}}</text>
        </div>
    </div>
</template>

<script>
const html = weex.requireModule('html')
const browser = weex.requireModule('browser')
export default {
    props: ["html"],
    data(){
        return {
            nodes:[],
            images:[],
        }
    },
    watch: {
        html: function(val) {
            html.parseTree(val, (nodes) => {
                this.nodes = nodes;
                this.images = nodes.filter(item => item.name === 'img').map(item => {
                    return item.src
                })
            });
        }
    },
    methods:{
        clickImage(e){
            const src = e.target.attr.src
            console.log(src)
            browser.browserImages(this.images)
        }
    }
}
</script>

<style>
.img {
    height: 500rpx;
    margin-top: 30px;
}
.text {
    color:#333333;
    font-size: 28px;
    margin-top: 30px;
}
</style>
