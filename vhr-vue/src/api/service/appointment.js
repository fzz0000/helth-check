import request from "@/utils/request.js";

export function loadAllAppointments(params) {
  return request({
    url: "/api/service-center/appointment",
    method: "get",
    params: params,
  });
}

export function getAppointmentById(id) {
  return request({
    url: "/api/service-center/appointment/" + id,
    method: "get",
  });
}

export function addAppointment(data) {
  return request({
    url: "/api/service-center/appointment",
    method: "post",
    data,
  });
}

export function updateAppointment(data) {
  return request({
    url: "/api/service-center/appointment",
    method: "put",
    data,
  });
}

export function cancelAppointmentById(id) {
  return request({
    url: `/api/service-center/appointment/cancel/${id}`,
    method: "delete",
  });
}

export function acceptAppointmentById(id) {
  return request({
    url: `/api/service-center/appointment/accept/${id}`,
    method: "put",
  });
}
