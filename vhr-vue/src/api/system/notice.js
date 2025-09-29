import request from "@/utils/request.js";

export function loadAllNotices(params) {
  return request({
    url: "/api/system/basic/notice",
    method: "get",
    params: params,
  });
}
export function getNoticeById(id) {
  return request({
    url: "/api/system/basic/notice/" + id,
    method: "get",
  });
}

export function deleteNoticeById(id) {
  return request({
    url: "/api/system/basic/notice/" + id,
    method: "delete",
  });
}

export function updateNotice(data) {
  return request({
    url: "/api/system/basic/notice",
    method: "put",
    data: data,
  });
}

export function addNotice(data) {
  return request({
    url: "/api/system/basic/position",
    method: "post",
    data: data,
  });
}
