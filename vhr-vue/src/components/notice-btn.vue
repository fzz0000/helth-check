  <template>
  <el-popover placement="left" width="300" trigger="click">
    <template #reference>
      <el-button type="danger" size="small" style="margin:0 10px">一键求助</el-button>
    </template>
    <div style="display: flex;">
      <el-input
        @keydown.enter.native="handleAdd"
        v-model="content"
        style="width: 300px"
        placeholder="请输入通知内容"
      />
      <el-button type="primary" @click="handleAdd">
        添加
        <el-icon class="el-icon--right">
          <Plus />
        </el-icon>
      </el-button>
    </div>
  </el-popover>
</template>

<script setup>
import { reactive, toRefs } from "vue";
import { addNotice } from "@/api/system/notice.js";
import { Plus } from "@element-plus/icons-vue";
import { ElMessage, ElMessageBox } from "element-plus";

const data = reactive({
  notices: [],
  total: 0,
  page: 1,
  size: 10,
  content: ""
});
const { content } = toRefs(data);

function handleAdd() {
  addNotice({ content: content.value }).then(res => {
    ElMessage.success("添加成功");
    content.value = "";
  });
}
</script>

<style scoped>
</style>



              