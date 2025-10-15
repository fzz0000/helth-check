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
import { watch, ref, computed, onMounted } from "vue";
import { userStore } from "@/stores/user.js";
import dayjs from "dayjs";
import {
  getHealthRecords,
  addHealthRecord,
  updateHealthRecord,
  getHealthDataByDimension
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

// 定时器引用，用于在弹窗关闭时清理
defineExpose({
  showAiReportDialog,
  showDetailDialog
});

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
const controllerRef = ref(null);
// 存储当前活跃的定时器
const activeTimeouts = ref([]);

const handleGenerateReport = async () => {
  try {
    // 获取当前用户ID
    const userId = userInfo.value?.id;
    if (!userId) {
      ElMessage.error("获取用户信息失败");
      return;
    }

    showAiReportDialog.value = true;
    aiReport.value = "正在生成健康报告，请稍候...\n";

    // 清理之前的资源
    cleanupResources();

    // 获取三个维度的健康数据
    const [weekData, monthData, yearData] = await Promise.all([
      getHealthDataByDimension("week", userId),
      getHealthDataByDimension("month", userId),
      getHealthDataByDimension("year", userId)
    ]);

    // 构建提示词
    const prompt = buildPromptForAiReport(
      weekData.data,
      monthData.data,
      yearData.data
    );

    // 临时apiKey
    const apiKey =
      "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";

    // 创建新的控制器和超时处理
    controllerRef.current = new AbortController();
    const timeoutId = setTimeout(() => {
      if (controllerRef.current) {
        controllerRef.current.abort();
        throw new Error("请求超时，请检查网络连接后重试");
      }
    }, 120000); // 2分钟超时
    activeTimeouts.value.push(timeoutId);

    // 使用fetch API调用大模型，每次都是新的对话
    const response = await fetch(
      "https://openrouter.ai/api/v1/chat/completions",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${apiKey}`,
          "Content-Type": "application/json",
          "HTTP-Referer": window.location.href,
          "X-Title": "Chat Interface"
        },
        body: JSON.stringify({
          model: "mistralai/mistral-7b-instruct:free",
          messages: [
            {
              role: "assistant",
              content: " ",
              isStreaming: false
            },
            {
              role: "user",
              content: prompt
            }
          ],
          stream: true,
          temperature: 0.7
        }),
        signal: controllerRef.current.signal
      }
    );

    clearTimeout(timeoutId);
    // 从活跃定时器列表中移除已清除的定时器
    activeTimeouts.value = activeTimeouts.value.filter(
      timer => timer !== timeoutId
    );

    if (!response.ok) {
      throw new Error(`API调用失败: ${response.status} ${response.statusText}`);
    }

    const reader = response.body?.getReader();
    if (!reader) throw new Error("无法获取响应流");

    // 实时渲染AI返回的内容
    aiReport.value = "AI分析中...\n";
    let hasReceivedContent = false;

    // 设置等待反馈定时器
    const waitingFeedbackTimer = setInterval(() => {
      if (!hasReceivedContent && aiReport.value.endsWith("...\n")) {
        aiReport.value += "正在获取分析结果，请稍候...\n";
      }
    }, 5000);
    activeTimeouts.value.push(waitingFeedbackTimer);

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      const chunk = new TextDecoder().decode(value);
      const lines = chunk.split("\n").filter(line => line.startsWith("data: "));

      for (const line of lines) {
        try {
          const res = line.slice(6);
          if (res === "[DONE]") {
            break;
          }
          const data = JSON.parse(res);
          const content = data.choices[0]?.delta?.content || "";

          if (content) {
            hasReceivedContent = true;
            // 如果是首次收到内容，清空之前的提示信息
            if (
              aiReport.value === "AI分析中...\n" ||
              aiReport.value.includes("正在获取分析结果")
            ) {
              aiReport.value = "";
            }
            aiReport.value += content;
          }
        } catch (e) {
          console.error("解析流数据错误:", e);
          // 继续处理下一行数据，不中断整个流程
        }
      }
    }

    clearInterval(waitingFeedbackTimer);
    // 从活跃定时器列表中移除已清除的定时器
    activeTimeouts.value = activeTimeouts.value.filter(
      timer => timer !== waitingFeedbackTimer
    );

    // 确保至少有内容显示
    if (!hasReceivedContent) {
      aiReport.value =
        "已完成分析，但未获取到详细内容。\n\n" +
        "建议：\n" +
        "1. 确认您的健康数据是否完整\n" +
        "2. 稍后再次尝试生成报告\n" +
        "3. 如果问题持续，请联系系统管理员";
    }
  } catch (error) {
    if (error.name === "AbortError") {
      aiReport.value =
        "生成报告已取消或超时。\n\n" +
        "建议：\n" +
        "1. 检查网络连接\n" +
        "2. 等待片刻后重试\n" +
        "3. 减少分析维度或简化请求内容";
    } else {
      aiReport.value =
        "生成AI报告失败，请稍后重试。\n\n" +
        "错误信息: " +
        (error.message || "未知错误") +
        "\n\n" +
        "建议：\n" +
        "1. 检查您的网络连接\n" +
        "2. 确认您已录入足够的健康数据\n" +
        "3. 稍后再次尝试生成报告";
    }
  } finally {
    // 清理控制器引用
    controllerRef.current = null;
  }
};

// 清理所有资源（取消请求和清除定时器）
const cleanupResources = () => {
  // 取消正在进行的请求
  if (controllerRef.current) {
    controllerRef.current.abort();
    controllerRef.current = null;
  }

  // 清除所有定时器
  activeTimeouts.value.forEach(timerId => {
    clearTimeout(timerId);
    clearInterval(timerId);
  });
  activeTimeouts.value = [];
};

// 监听AI报告弹窗的关闭事件，确保清理所有资源
watch(showAiReportDialog, (newValue, oldValue) => {
  // 当弹窗从打开状态变为关闭状态时
  if (oldValue === true && newValue === false) {
    cleanupResources();
  }
});

// 构建AI报告提示词
const buildPromptForAiReport = (weekData, monthData, yearData) => {
  let prompt = `我需要你帮我分析我的健康数据，请分别按周、月、年三个维度进行分析并给出健康建议。\n\n`;

  // 添加周数据分析请求
  prompt += `### 周维度数据\n${JSON.stringify(weekData)}\n`;
  prompt += formatDimensionData(weekData, "周") + "\n\n";

  // 添加月数据分析请求
  prompt += `### 月维度数据\n${JSON.stringify(monthData)}\n`;
  prompt += formatDimensionData(monthData, "月") + "\n\n";

  // 添加年数据分析请求
  prompt += `### 年维度数据\n${JSON.stringify(yearData)}\n`;
  prompt += formatDimensionData(yearData, "年") + "\n\n";

  // 添加分析要求
  prompt += `请你基于以上数据，为我生成一份详细的健康分析报告，包括：\n`;
  prompt += `1. 各项健康指标（血压、心率、血糖、体重）的趋势分析\n`;
  prompt += `2. 不同时间维度的变化比较\n`;
  prompt += `3. 健康状况综合评估\n`;
  prompt += `4. 针对性的健康建议\n`;

  return prompt;
};

// 格式化维度数据
const formatDimensionData = (dimensionData, dimensionType) => {
  if (
    !dimensionData ||
    !dimensionData.labels ||
    dimensionData.labels.length === 0
  ) {
    return `暂无${dimensionType}维度的健康数据\n`;
  }

  let result = "";
  const { labels, series } = dimensionData;

  // 统计各指标的数据可用性
  const availableMetrics = [];
  if (
    series.systolicPressure &&
    series.systolicPressure.some(val => val !== null && val > 0)
  ) {
    availableMetrics.push("血压");
  }
  if (
    series.heartRate &&
    series.heartRate.some(val => val !== null && val > 0)
  ) {
    availableMetrics.push("心率");
  }
  if (
    series.fastingGlucose &&
    series.fastingGlucose.some(val => val !== null && val > 0)
  ) {
    availableMetrics.push("血糖");
  }
  if (series.weight && series.weight.some(val => val !== null && val > 0)) {
    availableMetrics.push("体重");
  }

  if (availableMetrics.length > 0) {
    result += `包含${availableMetrics.join("、")}等指标数据，共${
      labels.length
    }个${dimensionType}的数据\n`;
    result += `请分析这些指标在${dimensionType}维度的变化趋势和健康状况\n`;
  } else {
    result += `暂无有效的${dimensionType}维度健康指标数据\n`;
  }

  return result;
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