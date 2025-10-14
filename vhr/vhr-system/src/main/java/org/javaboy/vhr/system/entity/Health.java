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
 * 健康管理记录表
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Health implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 健康记录ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 关联用户ID
     */
    private Integer hrId;

    /**
     * 收缩压(mmHg)
     */
    private Integer systolicPressure;

    /**
     * 舒张压(mmHg)
     */
    private Integer diastolicPressure;

    /**
     * 心率(次/分钟)
     */
    private Integer heartRate;

    /**
     * 空腹血糖(mmol/L)
     */
    private Double fastingGlucose;

    /**
     * 体重(KG)
     */
    private Double weight;

    /**
     * 备注信息
     */
    private String remark;

    /**
     * 创建时间
     */
    private LocalDateTime createDate;

    /**
     * 关联的用户信息
     */
    @TableField(exist = false)
    private Hr hr;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getHrId() {
        return hrId;
    }

    public void setHrId(Integer hrId) {
        this.hrId = hrId;
    }

    public Integer getSystolicPressure() {
        return systolicPressure;
    }

    public void setSystolicPressure(Integer systolicPressure) {
        this.systolicPressure = systolicPressure;
    }

    public Integer getDiastolicPressure() {
        return diastolicPressure;
    }

    public void setDiastolicPressure(Integer diastolicPressure) {
        this.diastolicPressure = diastolicPressure;
    }

    public Integer getHeartRate() {
        return heartRate;
    }

    public void setHeartRate(Integer heartRate) {
        this.heartRate = heartRate;
    }

    public Double getFastingGlucose() {
        return fastingGlucose;
    }

    public void setFastingGlucose(Double fastingGlucose) {
        this.fastingGlucose = fastingGlucose;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public LocalDateTime getCreateDate() {
        return createDate;
    }

    public void setCreateDate(LocalDateTime createDate) {
        this.createDate = createDate;
    }

    public Hr getHr() {
        return hr;
    }

    public void setHr(Hr hr) {
        this.hr = hr;
    }

    @Override
    public String toString() {
        return "Health{" +
                "id = " + id +
                ", hrId = " + hrId +
                ", systolicPressure = " + systolicPressure +
                ", diastolicPressure = " + diastolicPressure +
                ", heartRate = " + heartRate +
                ", fastingGlucose = " + fastingGlucose +
                ", weight = " + weight +
                ", remark = " + remark +
                ", createDate = " + createDate +
                "}";
    }
}