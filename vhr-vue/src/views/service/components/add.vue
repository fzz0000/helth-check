<template>
  <el-dialog v-model="visible" :title="dialogTitle" width="400px" :before-close="handleClose">
    <div>
      <div style="margin-bottom: 20px">
        <el-form-item label="预约项目" prop="content">
          <el-select
            v-model="form.content"
            multiple
            filterable
            placeholder="请选择预约项目"
            style="width: 100%"
            @change="handleContentChange"
          >
            <el-option
              v-for="item in healthMetricsOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
      </div>
      <div style="margin-bottom: 10px">
        <el-form-item label="预约时间" prop="appointmentTime">
          <el-date-picker
            v-model="form.appointmentTime"
            type="datetime"
            style="width: 100%"
            placeholder="选择预约时间"
            :disabled-date="disabledDate"
            :disabled-time="disabledTime"
          />
        </el-form-item>
      </div>
    </div>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="handleCancel">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { reactive, toRefs, computed, watch } from "vue";
import { dayjs, ElMessage } from "element-plus";
import { healthMetrics } from "@/utils/lookup.js";

// Props
const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  editAppointment: {
    type: Object,
    default: null
  }
});

// Emits
const emit = defineEmits(["update:modelValue", "success"]);

// 健康指标选项
const healthMetricsOptions = computed(() => {
  return Object.entries(healthMetrics).map(([key, value]) => ({
    value: key,
    label: value
  }));
});

const data = reactive({
  form: {
    id: "", // 添加id字段用于修改
    content: [], // 存储选中的健康指标ID数组
    appointmentTime: ""
  },
  rules: {
    content: [
      {
        required: true,
        message: "请至少选择一项预约项目",
        trigger: "change"
      }
    ],
    appointmentTime: [
      {
        required: true,
        message: "请选择预约时间",
        trigger: "change"
      }
    ]
  }
});

const { form, rules } = toRefs(data);

// 计算属性 - 可见性
const visible = computed({
  get() {
    return props.modelValue;
  },
  set(value) {
    emit("update:modelValue", value);
  }
});

// 计算属性 - 对话框标题
const dialogTitle = computed(() => {
  return props.editAppointment ? "修改预约" : "发起预约";
});

// 监听可见性变化，根据editAppointment填充表单数据
watch(
  () => props.modelValue,
  newVal => {
    if (newVal) {
      if (props.editAppointment) {
        // 修改模式：填充表单数据
        data.form.id = props.editAppointment.id;
        data.form.content = props.editAppointment.content.split(",");
        data.form.appointmentTime = new Date(
          props.editAppointment.appointmentTime
        );
      } else {
        // 新增模式：重置表单
        resetForm();
      }
    }
  }
);

// 监听editAppointment变化
watch(
  () => props.editAppointment,
  (newVal, oldVal) => {
    if (newVal && props.modelValue) {
      // 修改模式：填充表单数据
      data.form.id = newVal.id;
      data.form.content = newVal.content.split(",");
      data.form.appointmentTime = new Date(newVal.appointmentTime);
    }
  }
);

// 处理内容变化
function handleContentChange(values) {
  form.value.content = values;
}

// 禁用过去的日期
function disabledDate(time) {
  // 不允许选择今天之前的日期
  return time.getTime() < Date.now() - 8.64e7;
}

// 禁用当前时间之前的时间
function disabledTime(date) {
  const now = new Date();
  const isToday =
    date &&
    date.getFullYear() === now.getFullYear() &&
    date.getMonth() === now.getMonth() &&
    date.getDate() === now.getDate();

  if (isToday) {
    return {
      disabledHours: () => {
        return Array.from({ length: now.getHours() }, (_, i) => i);
      },
      disabledMinutes: selectedHour => {
        if (selectedHour === now.getHours()) {
          return Array.from({ length: now.getMinutes() + 1 }, (_, i) => i);
        }
        return [];
      },
      disabledSeconds: () => {
        return [];
      }
    };
  }
  return {};
}

// 重置表单
function resetForm() {
  data.form = {
    id: "",
    content: [],
    appointmentTime: ""
  };
}

// 处理关闭
function handleClose(done) {
  resetForm();
  done();
}

// 处理取消
function handleCancel() {
  resetForm();
  visible.value = false;
}

// 处理提交
function handleSubmit() {
  // 表单验证
  if (!form.value.content || form.value.content.length === 0) {
    ElMessage.warning("请至少选择一项预约项目");
    return;
  }

  if (!form.value.appointmentTime) {
    ElMessage.warning("请选择预约时间");
    return;
  }

  // 格式化数据并提交
  const submitData = {
    content: form.value.content.join(","), // 将数组转换为逗号分隔的字符串
    appointmentTime: dayjs(form.value.appointmentTime).format(
      "YYYY-MM-DD HH:mm:ss"
    )
  };

  // 如果存在id，则为修改模式，添加id到提交数据中
  if (form.value.id) {
    submitData.id = form.value.id;
  }

  emit("success", submitData);

  // 提交成功后重置并关闭
  resetForm();
  visible.value = false;
}
</script>

<style scoped>
.selected-content-text {
  font-size: 12px;
  color: #606266;
  margin-top: 5px;
  line-height: 1.5;
}
</style>