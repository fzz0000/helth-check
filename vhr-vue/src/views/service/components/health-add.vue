<template>
  <el-dialog
    :model-value="modelValue"
    @update:model-value="handleDialogClose"
    :title="editMode ? '修改健康信息' : '上报健康信息'"
    width="500px"
  >
    <el-form :model="healthRecordForm" :rules="rules" ref="healthRecordFormRef" label-width="150px">
      <el-form-item label="用户" prop="hrId">
        <el-input
          :value="getUserNameById(healthRecordForm.hrId)"
          disabled
          placeholder="当前用户"
          style="width: 100%;"
        />
      </el-form-item>
      <el-form-item label="收缩压(mmHg)" prop="systolicPressure">
        <el-input v-model.number="healthRecordForm.systolicPressure" placeholder="请输入收缩压" />
      </el-form-item>
      <el-form-item label="舒张压(mmHg)" prop="diastolicPressure">
        <el-input v-model.number="healthRecordForm.diastolicPressure" placeholder="请输入舒张压" />
      </el-form-item>
      <el-form-item label="心率(次/分钟)" prop="heartRate">
        <el-input v-model.number="healthRecordForm.heartRate" placeholder="请输入心率" />
      </el-form-item>
      <el-form-item label="空腹血糖(mmol/L)" prop="fastingGlucose">
        <el-input v-model.number="healthRecordForm.fastingGlucose" placeholder="请输入空腹血糖" />
      </el-form-item>
      <el-form-item label="体重(KG)" prop="weight">
        <el-input v-model.number="healthRecordForm.weight" placeholder="请输入体重" />
      </el-form-item>
      <el-form-item label="备注">
        <el-input v-model="healthRecordForm.remark" type="textarea" placeholder="请输入备注" />
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="handleCancel">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确认</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, defineProps, defineEmits, watch, onMounted } from "vue";
import { ElMessage } from "element-plus";
import { getUserList } from "@/api/user/user.js";

// 定义props
const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  formData: {
    type: Object,
    default: () => ({
      id: null,
      hrId: null,
      systolicPressure: null,
      diastolicPressure: null,
      heartRate: null,
      fastingGlucose: null,
      weight: null,
      remark: ""
    })
  },
  editMode: {
    type: Boolean,
    default: false
  }
});

// 定义emits
const emit = defineEmits(["update:modelValue", "submit"]);

// 表单引用
const healthRecordFormRef = ref(null);

// 表单数据
const healthRecordForm = ref({ ...props.formData });

// 用户列表
const userList = ref([]);

// 加载用户列表
const loadUserList = async () => {
  try {
    const params = {
      page: 1,
      size: 1000 // 加载足够多的用户，实际项目中可能需要分页加载或搜索功能
    };
    const result = await getUserList(params);
    userList.value = result.data || [];
  } catch (error) {
    ElMessage.error("加载用户列表失败");
    console.error("加载用户列表失败:", error);
  }
};

// 表单验证规则
const rules = {
  systolicPressure: [
    { required: true, message: "请输入收缩压", trigger: "blur" },
    { type: "number", message: "请输入有效的数值", trigger: "blur" }
  ],
  diastolicPressure: [
    { required: true, message: "请输入舒张压", trigger: "blur" },
    { type: "number", message: "请输入有效的数值", trigger: "blur" }
  ],
  heartRate: [
    { required: true, message: "请输入心率", trigger: "blur" },
    { type: "number", message: "请输入有效的数值", trigger: "blur" }
  ],
  fastingGlucose: [
    { required: true, message: "请输入空腹血糖", trigger: "blur" },
    { type: "number", message: "请输入有效的数值", trigger: "blur" }
  ],
  weight: [
    { required: true, message: "请输入体重", trigger: "blur" },
    { type: "number", message: "请输入有效的数值", trigger: "blur" }
  ]
};

// 监听表单数据变化
watch(
  () => props.formData,
  newValue => {
    healthRecordForm.value = { ...newValue };
  },
  { deep: true }
);

// 组件挂载时加载用户列表
onMounted(() => {
  loadUserList();
});

// 处理取消
const handleCancel = () => {
  handleDialogClose(false);
};

// 处理对话框关闭
const handleDialogClose = value => {
  emit("update:modelValue", value);
};

// 根据用户ID获取用户名
const getUserNameById = userId => {
  const user = userList.value.find(item => item.id === userId);
  return user ? user.name : "";
};

// 处理提交
const handleSubmit = () => {
  healthRecordFormRef.value.validate(valid => {
    if (valid) {
      emit("submit", { ...healthRecordForm.value });
    }
  });
};

// 监听弹窗显示状态，重置表单
watch(
  () => props.modelValue,
  newValue => {
    if (newValue) {
      healthRecordForm.value = { ...props.formData };
      // 重置表单验证状态
      if (healthRecordFormRef.value) {
        healthRecordFormRef.value.clearValidate();
      }
    }
  }
);
</script>

<style scoped>
.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>