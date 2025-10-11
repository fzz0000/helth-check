package org.javaboy.vhr.system.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.javaboy.vhr.framework.entity.Hr;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * <p>
 * 预约表
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
public class Appointment implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 预约内容（健康数据表字段任意指标拼接）
     */
    private String content;

    /**
     * 创建时间
     */
    private LocalDateTime createDate;

    /**
     * 预约时间
     */
    private LocalDateTime appointmentTime;

    /**
     * 创建人ID
     */
    @TableField("hr_id")
    private Integer hrId;

    /**
     * 预约状态(0:待受理,1:已受理)
     */
    private Integer status;

    /**
     * 完整的人员信息，非数据库字段
     */
    @TableField(exist = false)
    @JsonIgnoreProperties(value = { "roles" }, allowSetters = true)
    private Hr hr;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getCreateDate() {
        return createDate;
    }

    public void setCreateDate(LocalDateTime createDate) {
        this.createDate = createDate;
    }

    public LocalDateTime getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(LocalDateTime appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public Integer getHrId() {
        return hrId;
    }

    public void setHrId(Integer hrId) {
        this.hrId = hrId;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Hr getHr() {
        return hr;
    }

    public void setHr(Hr hr) {
        this.hr = hr;
    }

    @Override
    public String toString() {
        return "Appointment{" +
                "id = " + id +
                ", content = " + content +
                ", createDate = " + createDate +
                ", appointmentTime = " + appointmentTime +
                ", hrId = " + hrId +
                ", status = " + status +
                "}";
    }
}