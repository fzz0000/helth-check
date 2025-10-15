<template>
  <div>
    <div style="margin-top: 10px">
      <!-- 搜索表单 -->
      <div
        style="margin-bottom: 20px; padding: 10px; background-color: #f5f7fa; border-radius: 4px"
      >
        <el-form :inline="true" :model="searchForm" size="small">
          <el-form-item label="姓名">
            <el-input v-model="searchForm.name" placeholder="请输入姓名" style="width: 180px" />
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
      <div style="display: flex;align-items: center;" v-if="!isAdmin">
        <el-button
          style="margin:0 10px 10px 0"
          type="primary"
          @click="handleAddHealthRecord"
          size="small"
        >
          <el-icon>
            <Plus />
          </el-icon>上报健康数据
        </el-button>

        <el-button
          style="margin:0 10px 10px 0"
          type="primary"
          @click="handleGenerateReport"
          size="small"
        >
          <el-icon>
            <Document />
          </el-icon>生成AI报告
        </el-button>
      </div>

      <el-table :data="healthRecords" border stripe style="width: 100%">
        <el-table-column prop="hr.name" label="姓名" width="180">
          <template #default="scope">{{scope.row.hr && scope.row.hr.name }}</template>
        </el-table-column>
        <el-table-column prop="hr.phone" label="手机号" width="180">
          <template #default="scope">{{ scope.row.hr && scope.row.hr.phone }}</template>
        </el-table-column>
        <el-table-column prop="systolicPressure" label="收缩压(mmHg)" width="150" />
        <el-table-column prop="diastolicPressure" label="舒张压(mmHg)" width="150" />
        <el-table-column prop="heartRate" label="心率(次/分钟)" width="150" />
        <el-table-column prop="fastingGlucose" label="空腹血糖(mmol/L)" width="180" />
        <el-table-column prop="weight" label="体重(KG)" width="120" />
        <el-table-column prop="remark" label="备注" width="200" />
        <el-table-column prop="measureTime" label="检测时间" width="180" />
        <el-table-column label="操作" width="200">
          <template #default="scope">
            <el-button size="small" type="primary" @click="handleUpdateHealthRecord(scope.row)">修改</el-button>
            <el-button size="small" @click="handleViewHealthRecord(scope.row)">查看详情</el-button>
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

    <!-- 引入健康信息添加组件 -->
    <HealthAdd
      v-model="showHealthRecordDialog"
      :form-data="healthRecordForm"
      :edit-mode="editMode"
      @submit="handleSubmit"
    />

    <!-- AI报告弹窗 -->
    <el-dialog v-model="showAiReportDialog" title="AI健康报告" width="800px">
      <div v-if="aiReport" style="white-space: pre-wrap; line-height: 1.8">{{ aiReport }}</div>
      <div v-else style="text-align: center; color: #999">报告生成中...</div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showAiReportDialog = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 健康数据明细弹窗 -->
    <el-dialog
      v-model="showDetailDialog"
      title="健康数据明细"
      width="900px"
      height="90vh"
      fullscreen="false"
    >
      <HealthDetail :visible="showDetailDialog" :user-id="detailUserId" />
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showDetailDialog = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { userStore } from "@/stores/user.js";
import dayjs from "dayjs";
import {
  getHealthRecords,
  addHealthRecord,
  updateHealthRecord,
  generateAiReport
} from "@/api/service/health.js";
import { Document, Plus } from "@element-plus/icons-vue";
import { ElMessage } from "element-plus";
import HealthAdd from "./components/health-add.vue";
import HealthDetail from "./components/health-detail.vue";

const store = userStore();
const isAdmin = computed(() => store.isAdmin);
const userInfo = computed(() => store.userInfo);

// 表格数据相关
const healthRecords = ref([]);
const total = ref(0);
const page = ref(1);
const size = ref(10);

// 搜索表单
const searchForm = ref({
  name: "",
  phone: ""
});

// 弹窗相关
const showHealthRecordDialog = ref(false);
const showAiReportDialog = ref(false);
const showDetailDialog = ref(false);
const aiReport = ref("");
const editMode = ref(false);

// 查看详情的用户ID
const detailUserId = ref(null);

// 表单数据
const healthRecordForm = ref({
  id: null,
  hrId: null,
  measureTime: null,
  systolicPressure: null,
  diastolicPressure: null,
  heartRate: null,
  fastingGlucose: null,
  weight: null,
  remark: ""
});

// 加载健康记录列表
const loadHealthRecords = () => {
  const params = {
    page: page.value,
    size: size.value,
    ...searchForm.value
  };

  getHealthRecords(params).then(res => {
    healthRecords.value = res.data;
    total.value = res.total;
  });
};

const paginationChange = (newPage, newSize) => {
  page.value = size.value === newSize ? newPage : 1;
  size.value = newSize;
  loadHealthRecords();
};

// 搜索
const handleSearch = () => {
  page.value = 1;
  loadHealthRecords();
};

// 重置
const handleReset = () => {
  searchForm.value = {
    name: "",
    phone: ""
  };
  page.value = 1;
  loadHealthRecords();
};

// 生成AI报告
const handleGenerateReport = () => {
  if (!userInfo.value?.id) {
    ElMessage.error("用户信息获取失败");
    return;
  }

  showAiReportDialog.value = true;
  aiReport.value = "";

  generateAiReport(userInfo.value.id).then(res => {
    aiReport.value = res.data;
  });
};

// 查看健康数据明细
const handleViewHealthRecord = row => {
  detailUserId.value = row.hrId;
  showDetailDialog.value = true;
};

// 打开上报健康信息弹窗（管理员从列表选择用户）
const handleAddHealthRecord = () => {
  editMode.value = false;
  healthRecordForm.value = {
    id: null,
    hrId: null,
    measureTime: dayjs().format("YYYY-MM-DD HH:mm:ss"),
    systolicPressure: null,
    diastolicPressure: null,
    heartRate: null,
    fastingGlucose: null,
    weight: null,
    remark: ""
  };
  showHealthRecordDialog.value = true;
};

// 打开修改健康信息弹窗
const handleUpdateHealthRecord = row => {
  editMode.value = true;
  healthRecordForm.value = {
    id: row.id,
    hrId: row.hrId,
    measureTime: dayjs(row.measureTime).format("YYYY-MM-DD HH:mm:ss"),
    systolicPressure: row.systolicPressure,
    diastolicPressure: row.diastolicPressure,
    heartRate: row.heartRate,
    fastingGlucose: row.fastingGlucose,
    weight: row.weight,
    remark: row.remark
  };
  showHealthRecordDialog.value = true;
};

// 提交健康信息
const handleSubmit = formData => {
  if (editMode.value) {
    updateHealthRecord(formData).then(res => {
      ElMessage.success("修改成功");
      showHealthRecordDialog.value = false;
      loadHealthRecords();
    });
  } else {
    addHealthRecord(formData).then(res => {
      ElMessage.success("新增成功");
      showHealthRecordDialog.value = false;
      loadHealthRecords();
    });
  }
};

// 初始化
onMounted(() => {
  store.initUser();
  loadHealthRecords();
});
</script>

<style scoped>
.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>