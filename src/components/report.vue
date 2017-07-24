<template>
    <div class="report" @click="report">
        <text>举报</text>
        <image :src="reportImage" class="report-image"></image>
    </div>
</template>
<script>
    import config from '../config'
    const navigator = weex.requireModule('navigator')
    export default {
        props:['reportImage'],
        created(){
            this.reportImage = config.image('report.png')
        },
        methods:{
            report(){
                navigator.push({url:config.js('components/report-detail.js')},()=>{})
            },
        }
    }
</script>
<style>
    .report {
        padding:20px;
        flex-direction: row;
        justify-content:flex-end;
    }
    .report-image {
        width:30px;
        height:30px;
        margin-left: 10px;
    }
</style>