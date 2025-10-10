<template>
  <div>
    <div style="margin-top: 10px">
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
import { reactive, toRefs, computed } from "vue";
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
  addNo: { content: "" }
});
const { notices, total, page, size, addNo } = toRefs(data);

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

function noticeList() {
  loadAllNotices({ page: page.value, size: size.value }).then(res => {
    notices.value = res.data;
    total.value = res.total;
  });
}

noticeList();
</script>

<style scoped>
</style>
