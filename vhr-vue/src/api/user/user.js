import request from "@/utils/request.js";

/**
 * 获取用户列表
 * @param {Object} params - 查询参数
 * @param {number} params.page - 页码
 * @param {number} params.size - 每页条数
 * @param {string} [params.name] - 姓名（可选）
 * @param {string} [params.phone] - 手机号（可选）
 * @returns {Promise}
 */
export function getUserList(params) {
  return request({
    url: "/api/hr",
    method: "get",
    params,
  });
}

/**
 * 获取单个用户详情
 * @param {number} id - 用户ID
 * @returns {Promise}
 */
export function getUserById(id) {
  return request({
    url: `/api/hr/${id}`,
    method: "get",
  });
}

/**
 * 新增用户
 * @param {Object} user - 用户信息
 * @returns {Promise}
 */
export function addUser(user) {
  return request({
    url: "/api/hr",
    method: "post",
    data: user,
  });
}

/**
 * 修改用户
 * @param {Object} user - 用户信息
 * @returns {Promise}
 */
export function updateUser(user) {
  return request({
    url: "/api/hr",
    method: "put",
    data: user,
  });
}

/**
 * 删除用户
 * @param {number} id - 用户ID
 * @returns {Promise}
 */
export function deleteUser(id) {
  return request({
    url: `/api/hr/${id}`,
    method: "delete",
  });
}
