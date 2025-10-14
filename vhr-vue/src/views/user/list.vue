<template>
  <div class="user-list-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>用户管理</span>
          <el-button type="primary" @click="handleAddUser">新增用户</el-button>
        </div>
      </template>

      <!-- 搜索条件 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="姓名">
          <el-input v-model="searchForm.name" placeholder="请输入姓名" style="width: 180px;"></el-input>
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="searchForm.phone" placeholder="请输入手机号" style="width: 180px;"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 用户列表 -->
      <el-table :data="userList" stripe style="width: 100%">
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="name" label="姓名"></el-table-column>
        <el-table-column prop="gender" label="性别"></el-table-column>
        <el-table-column prop="age" label="年龄" width="80"></el-table-column>
        <el-table-column prop="phone" label="手机号码"></el-table-column>
        <el-table-column prop="telephone" label="住宅电话"></el-table-column>
        <el-table-column prop="address" label="联系地址"></el-table-column>
        <el-table-column prop="enabled" label="状态" width="80">
          <template #default="scope">
            <el-tag
              :type="scope.row.enabled ? 'success' : 'danger'"
            >{{ scope.row.enabled ? '启用' : '禁用' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="username" label="用户名"></el-table-column>
        <el-table-column label="操作" width="240" fixed="right">
          <template #default="scope">
            <el-button type="primary" size="small" @click="handleViewUser(scope.row.id)">查看</el-button>
            <el-button size="small" @click="handleEditUser(scope.row.id)">修改</el-button>
            <el-button type="danger" size="small" @click="handleDeleteUser(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          background
          @change="paginationChange"
          layout="sizes,prev, pager, next, jumper, ->, total"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
        ></el-pagination>
      </div>
    </el-card>

    <!-- 引入用户表单对话框组件 -->
    <ModifyDialog
      :visible="dialogVisible"
      :dialogType="dialogType"
      :dialogTitle="dialogTitle"
      :userId="selectedUserId"
      @close="handleDialogClose"
      @success="handleDialogSuccess"
    />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import {
  getUserList,
  getUserById,
  addUser,
  updateUser,
  deleteUser
} from "@/api/user/user.js";
import ModifyDialog from "./components/modify.vue";

// 定义响应式数据
const userList = ref([]);
const total = ref(0);
const page = ref(1);
const size = ref(10);
const searchForm = reactive({
  name: "",
  phone: ""
});
const dialogVisible = ref(false);
const dialogTitle = ref("");
const dialogType = ref(""); // 'add', 'edit', 'view'
const selectedUserId = ref(null);

// 加载用户列表
const loadUserList = async () => {
  const params = {
    page: page.value,
    size: size.value,
    ...searchForm
  };
  // request.js已经处理了响应，getUserList返回的就是RespPageBean对象
  const respPageBean = await getUserList(params);
  userList.value = respPageBean.data || [];
  total.value = respPageBean.total || 0;
};

// 分页改变
const paginationChange = (newPage, newSize) => {
  page.value = size.value === newSize ? newPage : 1;
  size.value = newSize;
  loadUserList();
};

// 搜索
const handleSearch = () => {
  page.value = 1;
  loadUserList();
};

// 重置搜索
const resetSearch = () => {
  searchForm.name = "";
  searchForm.phone = "";
  loadUserList();
};

// 新增用户
const handleAddUser = () => {
  dialogType.value = "add";
  dialogTitle.value = "新增用户";
  selectedUserId.value = null;
  dialogVisible.value = true;
};

// 查看用户
const handleViewUser = id => {
  dialogType.value = "view";
  dialogTitle.value = "查看用户";
  selectedUserId.value = id;
  dialogVisible.value = true;
};

// 修改用户
const handleEditUser = id => {
  dialogType.value = "edit";
  dialogTitle.value = "修改用户";
  selectedUserId.value = id;
  dialogVisible.value = true;
};

// 处理对话框关闭
const handleDialogClose = () => {
  dialogVisible.value = false;
  selectedUserId.value = null;
};

// 处理对话框成功
const handleDialogSuccess = () => {
  // 当对话框操作成功时，重新加载用户列表
  loadUserList();
};

// 删除用户
const handleDeleteUser = async id => {
  try {
    await ElMessageBox.confirm("确定要删除该用户吗？", "提示", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning"
    });

    await deleteUser(id);
    ElMessage.success("删除成功");
    loadUserList();
  } catch (error) {
    // 用户取消删除或其他错误
    if (error !== "cancel") {
      console.error("删除失败:", error);
    }
  }
};

// 组件挂载时加载用户列表
onMounted(() => {
  loadUserList();
});
</script>

<style scoped>
.user-list-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-form {
  margin-bottom: 20px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
