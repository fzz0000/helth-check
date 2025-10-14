<template>
  <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px" @close="handleCancel">
    <el-form
      ref="userFormRef"
      :model="userForm"
      :rules="formRules"
      label-width="80px"
      :disabled="dialogType === 'view'"
    >
      <el-form-item label="姓名" prop="name">
        <el-input v-model="userForm.name" placeholder="请输入姓名"></el-input>
      </el-form-item>
      <el-form-item label="性别" prop="gender">
        <el-radio-group v-model="userForm.gender">
          <el-radio label="男">男</el-radio>
          <el-radio label="女">女</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="年龄" prop="age">
        <el-input v-model.number="userForm.age" placeholder="请输入年龄" type="number"></el-input>
      </el-form-item>
      <el-form-item label="手机号码" prop="phone">
        <el-input v-model="userForm.phone" placeholder="请输入手机号码"></el-input>
      </el-form-item>
      <el-form-item label="住宅电话">
        <el-input v-model="userForm.telephone" placeholder="请输入住宅电话"></el-input>
      </el-form-item>
      <el-form-item label="联系地址" prop="address">
        <el-input v-model="userForm.address" placeholder="请输入联系地址" type="textarea"></el-input>
      </el-form-item>
      <el-form-item label="用户名" prop="username">
        <el-input
          v-model="userForm.username"
          placeholder="请输入用户名"
          :disabled="dialogType === 'view' || dialogType === 'edit'"
        ></el-input>
      </el-form-item>
      <el-form-item label="密码" prop="password">
        <el-input v-model="userForm.password" placeholder="请输入密码" type="password"></el-input>
      </el-form-item>
      <!-- <el-form-item label="状态" prop="enabled">
        <el-switch v-model="userForm.enabled"></el-switch>
      </el-form-item>-->
    </el-form>
    <template #footer v-if="dialogType !== 'view'">
      <span class="dialog-footer">
        <el-button @click="handleCancel">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, watch } from "vue";
import { ElMessage } from "element-plus";
import { getUserById, addUser, updateUser } from "@/api/user/user.js";

// 定义表单引用
const userFormRef = ref(null);

// 定义 props
const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  },
  dialogType: {
    type: String,
    default: ""
  },
  dialogTitle: {
    type: String,
    default: ""
  },
  userId: {
    type: [Number, String, null],
    default: null
  }
});

// 定义 emits
const emit = defineEmits(["close", "success"]);

// 定义响应式数据
const dialogVisible = ref(false);
const userForm = reactive({
  id: null,
  name: "",
  gender: "男",
  age: null,
  phone: "",
  telephone: "",
  address: "",
  username: "",
  password: "",
  enabled: true
});
const formRules = reactive({
  name: [
    { required: true, message: "请输入姓名", trigger: "blur" },
    {
      min: 2,
      max: 20,
      message: "姓名长度在 2 到 20 个字符",
      trigger: "blur"
    }
  ],
  age: [
    { required: true, message: "请输入年龄", trigger: "blur" },
    {
      type: "number",
      min: 0,
      max: 150,
      message: "年龄在 0 到 150 之间",
      trigger: "blur"
    }
  ],
  phone: [
    { required: true, message: "请输入手机号码", trigger: "blur" },
    {
      pattern: /^1[3-9]\d{9}$/,
      message: "请输入正确的手机号码",
      trigger: "blur"
    }
  ],
  address: [
    { required: true, message: "请输入联系地址", trigger: "blur" },
    { min: 5, message: "地址长度至少 5 个字符", trigger: "blur" }
  ],
  username: [
    { required: true, message: "请输入用户名", trigger: "blur" },
    {
      min: 2,
      max: 20,
      message: "用户名长度在 2 到 20 个字符",
      trigger: "blur"
    }
  ],
  password: [
    { required: true, message: "请输入密码", trigger: "blur" },
    { min: 3, message: "密码长度至少 3 个字符", trigger: "blur" }
  ]
});

// 监听 visible 变化
watch(
  () => props.visible,
  newVal => {
    dialogVisible.value = newVal;
    if (newVal && props.userId) {
      loadUserData(props.userId);
    } else if (newVal && props.dialogType === "add") {
      resetForm();
    }
  }
);

// 加载用户数据
const loadUserData = async id => {
  const { data } = (await getUserById(id)) || {};
  // 重置用户表单
  Object.keys(userForm).forEach(key => {
    userForm[key] = null;
  });
  // 填充用户数据
  Object.assign(userForm, data);
};

// 重置表单
const resetForm = () => {
  Object.assign(userForm, {
    id: null,
    name: "",
    gender: "男",
    age: null,
    phone: "",
    telephone: "",
    address: "",
    username: "",
    password: "",
    enabled: true
  });
  if (userFormRef.value) {
    userFormRef.value.resetFields();
  }
};

// 处理取消
const handleCancel = () => {
  dialogVisible.value = false;
  emit("close");
};

// 提交表单
const handleSubmit = async () => {
  await userFormRef.value.validate();
  if (props.dialogType === "add") {
    await addUser(userForm);
    ElMessage.success("添加成功");
  } else if (props.dialogType === "edit") {
    await updateUser(userForm);
    ElMessage.success("修改成功");
  }

  dialogVisible.value = false;
  emit("success");
  emit("close");
};
</script>

<style scoped>
.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>