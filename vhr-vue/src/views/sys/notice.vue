<template>
  <div>
    <div style="margin-top: 10px">
      <!-- 搜索表单 -->
      <div style="margin-bottom: 20px; padding: 10px; background-color: #f5f7fa; border-radius: 4px">
        <el-form :inline="true" :model="searchForm" size="small">
          <el-form-item label="通知人">
            <el-input v-model="searchForm.name" placeholder="请输入通知人姓名" style="width: 180px" />
          </el-form-item>
          <el-form-item label="手机号">
            <el-input v-model="searchForm.phone" placeholder="请输入手机号" style="width: 180px" />
          </el-form-item>
          <el-form-item label="通知内容">
            <el-input v-model="searchForm.content" placeholder="请输入通知内容" style="width: 220px" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch">搜索</el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <el-table :data="notices" border stripe style="width: 100%">
        <el-table-column prop="content" label="通知人" width="180">
          <template #default="scope">
            {{
            scope.row.hr.name
            }}
          </template>
        </el-table-column>
        <el-table-column prop="content" label="手机号" width="180">
          <template #default="scope">
            {{
            scope.row.hr.phone
            }}
          </template>
        </el-table-column>
        <el-table-column prop="content" label="通知内容" width="180" />
        <el-table-column prop="createDate" label="通知时间" />
        <el-table-column label="状态" width="120">
          <template #default="scope">
            {{
            scope.row.status == 0 ? '待处理' : '已处理'
            }}
          </template>
        </el-table-column>
        <el-table-column label="操作" v-if="isAdmin">
          <template #default="scope">
            <el-button
              v-if="scope.row.status == 0"
              size="small"
              @click="handleUpdate({ status: 1,id: scope.row.id })"
            >受理</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div style="display: flex;justify-content: flex-end;margin-top: 10px">
        <el-pagination
          background
          @change="paginationChange"
          :page-sizes="[5,10,20,30,50,100]"
          layout="sizes,prev, pager, next, jumper, ->, total"
          :total="total"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, toRefs, computed, onMounted, onUnmounted } from "vue";
import {
  loadAllNotices,
  updateNotice,
  addNotice
} from "@/api/system/notice.js";
import { Plus } from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { userStore } from "@/stores/index.js";

const uStore = userStore();

const isAdmin = computed(() => uStore.isAdmin);

const data = reactive({
  notices: [],
  total: 0,
  page: 1,
  size: 10,
  addNo: { content: "" },
  searchForm: {
    name: '',
    phone: '',
    content: ''
  }
});
const { notices, total, page, size, addNo, searchForm } = toRefs(data);

function handleAdd() {
  addNotice(addNo.value).then(res => {
    noticeList();
    addNo.value.content = "";
  });
}

function handleUpdate(row) {
  updateNotice(row).then(res => {
    noticeList();
  });
}

function paginationChange(newPage, newSize) {
  page.value = newPage;
  size.value = newSize;
  noticeList();
}

// 搜索按钮点击事件
function handleSearch() {
  page.value = 1; // 搜索时重置为第一页
  noticeList();
}

// 重置搜索表单
function handleReset() {
  searchForm.value.name = '';
  searchForm.value.phone = '';
  searchForm.value.content = '';
  page.value = 1;
  noticeList();
}

// 列表加载函数
function noticeList() {
  loadAllNotices({
    page: page.value,
    size: size.value,
    name: searchForm.value.name,
    phone: searchForm.value.phone,
    content: searchForm.value.content
  }).then(res => {
    notices.value = res.data;
    total.value = res.total;
  });
}

// 声明定时器变量
// let noticeTimer = null;

// 页面挂载时设置定时器
// onMounted(() => {
//   noticeList();
//   // 设置timer每1秒调用一次noticeList方法
//   noticeTimer = setInterval(() => {
//     noticeList();
//   }, 1000);
// });

// // 页面卸载时清除定时器
// onUnmounted(() => {
//   if (noticeTimer) {
//     clearInterval(noticeTimer);
//     noticeTimer = null;
//   }
// });

noticeList();
</script>

<style scoped>
</style>
