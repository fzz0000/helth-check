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
 * 通知表
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
public class Notice implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 通知内容
     */
    private String content;

    private LocalDateTime createDate;

    private Boolean enabled;

    /**
     * 创建人ID
     */
    @TableField("hr_id")
    private Integer hrId;

    /**
     * 通知受理状态(0:待处理,1:已处理,2:紧急)
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

    public Boolean getEnabled() {
        return enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
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
        return "Notice{" +
                "id = " + id +
                ", content = " + content +
                ", createDate = " + createDate +
                ", enabled = " + enabled +
                ", hrId = " + hrId +
                ", status = " + status +
                "}";
    }
}
