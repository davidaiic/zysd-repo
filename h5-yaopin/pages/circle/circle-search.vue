<template>
    <CircleList :readonly="false" :defaultWord="keyword" />
</template>

<script>
import CircleList from './circle-list.vue';
export default {
    components: {
        CircleList
    },
    data() {
        return {
            keyword: '',
        }
    },
    onload(option) {
        this.keyword = option.keyword || ''
    },
    methods: {

    }
};
</script>
<style lang="scss">
page {
    overflow: hidden;
}
</style>
<style lang="scss"></style>
