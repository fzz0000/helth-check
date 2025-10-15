import request from "@/utils/request";

// 获取健康记录列表
export function getHealthRecords(params) {
  return request({
    url: "/api/service-center/health",
    method: "get",
    params: params,
  });
}

// 新增健康信息
export function addHealthRecord(data) {
  return request({
    url: "/api/service-center/health",
    method: "post",
    data: data,
  });
}

// 修改健康信息
export function updateHealthRecord(data) {
  return request({
    url: "/api/service-center/health",
    method: "put",
    data: data,
  });
}

// 生成AI健康报告
export function generateAiReport(userId) {
  return request({
    url: "/api/service-center/health/ai-report/" + userId,
    method: "get",
  });
}

// 获取用户最新健康记录
export function getLatestHealthRecord(userId) {
  return request({
    url: "/api/service-center/health/latest/" + userId,
    method: "get",
  });
}

// 获取健康数据明细，按指定维度聚合
export function getHealthDataByDimension(dimension, userId) {
  return request({
    url: "/api/service-center/health/dimension",
    method: "get",
    params: {
      dimension,
      userId,
    },
  });
}
