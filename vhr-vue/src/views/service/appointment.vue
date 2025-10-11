<template>
  <div>
    <div style="margin-top: 10px">
      <!-- 搜索表单 -->
      <div
        style="margin-bottom: 20px; padding: 10px; background-color: #f5f7fa; border-radius: 4px"
      >
        <el-form :inline="true" :model="searchForm" size="small">
          <el-form-item label="预约人">
            <el-input v-model="searchForm.name" placeholder="请输入预约人姓名" style="width: 180px" />
          </el-form-item>
          <el-form-item label="手机号">
            <el-input v-model="searchForm.phone" placeholder="请输入手机号" style="width: 180px" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch">搜索</el-button>
            <el-button @click="handleReset">重置</el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- 工具栏 -->
      <div style="display: flex;align-items: center;">
        <el-button
          style="margin:0 10px 10px 0"
          type="primary"
          @click="handleAddAppointment"
          v-if="!isAdmin"
          size="small"
        >
          <el-icon>
            <Plus />
          </el-icon>发起预约
        </el-button>
      </div>

      <el-table :data="appointments" border stripe style="width: 100%">
        <el-table-column prop="hr.name" label="预约人" width="180">
          <template #default="scope">{{ scope.row.hr.name }}</template>
        </el-table-column>
        <el-table-column prop="hr.phone" label="手机号" width="180">
          <template #default="scope">{{ scope.row.hr.phone }}</template>
        </el-table-column>
        <el-table-column prop="content" label="预约项目" width="300">
          <template
            #default="scope"
          >{{ scope.row.content.split(',').map(i=>healthMetrics[i]).join('、') }}</template>
        </el-table-column>
        <el-table-column prop="appointmentTime" label="预约时间" width="180" />
        <el-table-column label="状态" width="120">
          <template #default="scope">{{ scope.row.status == 0 ? '待受理' : '已受理' }}</template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <el-button
              v-if="isAdmin && scope.row.status == 0"
              size="small"
              type="primary"
              @click="handleAccept(scope.row.id)"
            >受理</el-button>
            <el-button
              v-if="!isAdmin && scope.row.status == 0"
              size="small"
              type="danger"
              @click="handleCancel(scope.row.id)"
            >取消</el-button>
            <el-button
              v-if="!isAdmin && scope.row.status == 0"
              size="small"
              type="primary"
              @click="handleModify(scope.row)"
            >修改</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div style="display: flex;justify-content: flex-end;margin-top: 10px">
        <el-pagination
          background
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :page-sizes="[5,10,20,30,50,100]"
          layout="sizes,prev, pager, next, jumper, ->, total"
          :total="total"
          :current-page="page"
          :page-size="size"
        />
      </div>
    </div>

    <!-- 预约弹窗组件 -->
    <AppointmentDialog
      v-model="showAppointmentDialog"
      :edit-appointment="editAppointment"
      @success="handleAppointmentSuccess"
    />
  </div>
</template>

<script setup>
import { reactive, toRefs, computed, onMounted } from "vue";
import { Plus } from "@element-plus/icons-vue";
import {
  loadAllAppointments,
  acceptAppointmentById,
  cancelAppointmentById,
  addAppointment,
  updateAppointment
} from "@/api/service/appointment.js";
import { ElMessage } from "element-plus";
import { userStore } from "@/stores/index.js";
import { healthMetrics } from "@/utils/lookup.js";
import AppointmentDialog from "./components/add.vue";

const uStore = userStore();

const isAdmin = computed(() => uStore.isAdmin);

const data = reactive({
  appointments: [],
  total: 0,
  page: 1,
  size: 10,
  searchForm: {
    name: "",
    phone: ""
  },
  showAppointmentDialog: false,
  editAppointment: null // 存储当前正在编辑的预约信息
});

const {
  appointments,
  total,
  page,
  size,
  searchForm,
  showAppointmentDialog,
  editAppointment
} = toRefs(data);

// 加载预约列表
function appointmentList() {
  loadAllAppointments({
    page: page.value,
    size: size.value,
    name: searchForm.value.name,
    phone: searchForm.value.phone
  }).then(res => {
    appointments.value = res.data;
    total.value = res.total;
  });
}

// 处理受理
function handleAccept(id) {
  acceptAppointmentById(id).then(res => {
    ElMessage.success("受理成功");
    appointmentList();
  });
}

// 处理取消
function handleCancel(id) {
  cancelAppointmentById(id).then(res => {
    ElMessage.success("取消成功");
    appointmentList();
  });
}

// 搜索按钮点击事件
function handleSearch() {
  page.value = 1; // 搜索时重置为第一页
  appointmentList();
}

// 重置搜索表单
function handleReset() {
  searchForm.value.id = "";
  searchForm.value.name = "";
  searchForm.value.phone = "";
  page.value = 1;
  appointmentList();
}

// 分页处理
function handleSizeChange(newSize) {
  size.value = newSize;
  appointmentList();
}

function handleCurrentChange(newPage) {
  page.value = newPage;
  appointmentList();
}

// 处理添加预约
function handleAddAppointment() {
  data.editAppointment = null; // 确保是新增模式
  showAppointmentDialog.value = true;
}

// 处理修改预约
function handleModify(row) {
  data.editAppointment = row; // 设置为编辑模式并传递数据
  showAppointmentDialog.value = true;
}

// 处理预约成功
function handleAppointmentSuccess(data) {
  // 根据是否包含id判断是新增还是修改
  const apiMethod = data.id ? updateAppointment : addAppointment;
  const successMessage = data.id ? "修改成功" : "预约成功";

  apiMethod(data).then(res => {
    ElMessage.success(successMessage);
    // 刷新列表
    appointmentList();
  });
}

// 页面挂载时加载列表
onMounted(() => {
  appointmentList();
});
</script>

<style scoped>
</style>