<template>
    <div class="report">
        <text>举报</text>
        <image :src="reportImage" class="report-image"></image>
    </div>
</template>
<script>
    import config from '../config'
    export default {
        data: {
            reportImage:''
        },
        created(){
            this.reportImage = config.image('report.png')
        },
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