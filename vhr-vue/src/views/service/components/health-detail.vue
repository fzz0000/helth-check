<template>
  <div class="health-detail">
    <!-- 加载状态 -->
    <div v-if="loading" class="loading-container">
      <el-loading v-loading="loading" element-loading-text="正在加载健康数据..." />
    </div>

    <!-- 维度选择器 -->
    <div class="dimension-selector" v-if="visible">
      <div class="selector-wrapper">
        <h2 class="page-title">健康数据趋势分析</h2>
        <el-radio-group
          v-model="currentDimension"
          @change="handleDimensionChange"
          class="dimension-group"
        >
          <el-radio-button label="week">按周</el-radio-button>
          <el-radio-button label="month">按月</el-radio-button>
          <el-radio-button label="year">按年</el-radio-button>
        </el-radio-group>
      </div>
    </div>

    <!-- 数据概览卡片 -->
    <div class="overview-cards" v-if="visible && chartData.labels && chartData.labels.length > 0">
      <div class="card-item">
        <el-card class="stat-card">
          <div class="card-content">
            <div class="card-title">平均血压</div>
            <div class="card-value">{{ avgSystolicPressure }}/{{ avgDiastolicPressure }}</div>
            <div class="card-unit">mmHg</div>
          </div>
        </el-card>
      </div>
      <div class="card-item">
        <el-card class="stat-card">
          <div class="card-content">
            <div class="card-title">平均心率</div>
            <div class="card-value">{{ avgHeartRate }}</div>
            <div class="card-unit">次/分钟</div>
          </div>
        </el-card>
      </div>
      <div class="card-item">
        <el-card class="stat-card">
          <div class="card-content">
            <div class="card-title">平均血糖</div>
            <div class="card-value">{{ avgGlucose }}</div>
            <div class="card-unit">mmol/L</div>
          </div>
        </el-card>
      </div>
      <div class="card-item">
        <el-card class="stat-card">
          <div class="card-content">
            <div class="card-title">平均体重</div>
            <div class="card-value">{{ avgWeight }}</div>
            <div class="card-unit">KG</div>
          </div>
        </el-card>
      </div>
    </div>

    <!-- 图表展示区域 -->
    <div class="charts-container" v-if="visible && chartData.labels && chartData.labels.length > 0">
      <!-- 血压图表 -->
      <div class="chart-item">
        <div class="chart-header">
          <h3 class="chart-title">血压趋势</h3>
          <div class="chart-unit">(mmHg)</div>
        </div>
        <div ref="bloodPressureChart" class="chart"></div>
      </div>

      <!-- 心率图表 -->
      <div class="chart-item">
        <div class="chart-header">
          <h3 class="chart-title">心率趋势</h3>
          <div class="chart-unit">(次/分钟)</div>
        </div>
        <div ref="heartRateChart" class="chart"></div>
      </div>

      <!-- 血糖图表 -->
      <div class="chart-item">
        <div class="chart-header">
          <h3 class="chart-title">血糖趋势</h3>
          <div class="chart-unit">(mmol/L)</div>
        </div>
        <div ref="glucoseChart" class="chart"></div>
      </div>

      <!-- 体重图表 -->
      <div class="chart-item">
        <div class="chart-header">
          <h3 class="chart-title">体重趋势</h3>
          <div class="chart-unit">(KG)</div>
        </div>
        <div ref="weightChart" class="chart"></div>
      </div>
    </div>

    <!-- 暂无数据提示 -->
    <div class="no-data" v-if="visible && (!chartData.labels || chartData.labels.length === 0)">
      <el-empty description="暂无健康数据" image-size="120" />
      <div class="empty-tip">请先添加健康记录以查看趋势分析</div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from "vue";
import * as echarts from "echarts";
import { getHealthDataByDimension } from "@/api/service/health.js";
import { ElMessage } from "element-plus";

// Props
const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  },
  userId: {
    type: Number,
    required: true
  }
});

// 状态管理
const currentDimension = ref("week"); // 默认按周
const chartData = ref({ labels: [], series: {} });
const bloodPressureChart = ref(null);
const heartRateChart = ref(null);
const glucoseChart = ref(null);
const weightChart = ref(null);
const chartInstances = ref([]);
const loading = ref(false);
const avgSystolicPressure = ref("-");
const avgDiastolicPressure = ref("-");
const avgHeartRate = ref("-");
const avgGlucose = ref("-");
const avgWeight = ref("-");

// 加载健康数据
const loadHealthData = () => {
  if (!props.visible || !props.userId) {
    return;
  }

  loading.value = true;

  getHealthDataByDimension(currentDimension.value, props.userId)
    .then(res => {
      chartData.value = res.data || { labels: [], series: {} };
      calculateAverageValues();
      window.requestAnimationFrame(renderCharts);
    })
    .finally(() => {
      loading.value = false;
    });
};

// 计算平均值
const calculateAverageValues = () => {
  const { series } = chartData.value;

  // 计算平均收缩压和舒张压
  if (series.systolicPressure && series.systolicPressure.length > 0) {
    const validSystolic = series.systolicPressure.filter(val => val && val > 0);
    avgSystolicPressure.value =
      validSystolic.length > 0
        ? (
            validSystolic.reduce((sum, val) => sum + val, 0) /
            validSystolic.length
          ).toFixed(1)
        : "-";
  } else {
    avgSystolicPressure.value = "-";
  }

  if (series.diastolicPressure && series.diastolicPressure.length > 0) {
    const validDiastolic = series.diastolicPressure.filter(
      val => val && val > 0
    );
    avgDiastolicPressure.value =
      validDiastolic.length > 0
        ? (
            validDiastolic.reduce((sum, val) => sum + val, 0) /
            validDiastolic.length
          ).toFixed(1)
        : "-";
  } else {
    avgDiastolicPressure.value = "-";
  }

  // 计算平均心率
  if (series.heartRate && series.heartRate.length > 0) {
    const validHeartRate = series.heartRate.filter(val => val && val > 0);
    avgHeartRate.value =
      validHeartRate.length > 0
        ? Math.round(
            validHeartRate.reduce((sum, val) => sum + val, 0) /
              validHeartRate.length
          )
        : "-";
  } else {
    avgHeartRate.value = "-";
  }

  // 计算平均血糖
  if (series.fastingGlucose && series.fastingGlucose.length > 0) {
    const validGlucose = series.fastingGlucose.filter(val => val && val > 0);
    avgGlucose.value =
      validGlucose.length > 0
        ? (
            validGlucose.reduce((sum, val) => sum + val, 0) /
            validGlucose.length
          ).toFixed(1)
        : "-";
  } else {
    avgGlucose.value = "-";
  }

  // 计算平均体重
  if (series.weight && series.weight.length > 0) {
    const validWeight = series.weight.filter(val => val && val > 0);
    avgWeight.value =
      validWeight.length > 0
        ? (
            validWeight.reduce((sum, val) => sum + val, 0) / validWeight.length
          ).toFixed(1)
        : "-";
  } else {
    avgWeight.value = "-";
  }
};

// 渲染图表
const renderCharts = () => {
  const { labels, series } = chartData.value;
  if (!labels || labels.length === 0) {
    return;
  }

  // 确保图表容器存在再进行渲染
  if (
    bloodPressureChart.value &&
    heartRateChart.value &&
    glucoseChart.value &&
    weightChart.value
  ) {
    // 血压图表
    renderBloodPressureChart(labels, series);
    // 心率图表
    renderHeartRateChart(labels, series);
    // 血糖图表
    renderGlucoseChart(labels, series);
    // 体重图表
    renderWeightChart(labels, series);
  }
};

// 渲染血压图表
const renderBloodPressureChart = (labels, series) => {
  if (!bloodPressureChart.value) {
    return;
  }

  const instance = echarts.getInstanceByDom(bloodPressureChart.value);
  const chart = instance || echarts.init(bloodPressureChart.value);

  if (!chartInstances.value.includes(chart)) {
    chartInstances.value.push(chart);
  }

  const option = {
    tooltip: {
      trigger: "axis",
      backgroundColor: "rgba(255, 255, 255, 0.95)",
      borderColor: "#e0e0e0",
      borderWidth: 1,
      textStyle: {
        color: "#333"
      },
      formatter: function(params) {
        let result = `<div style="padding: 8px;"><strong>${params[0].axisValue}</strong><br/>`;
        params.forEach(param => {
          const name = param.seriesName === "收缩压" ? "收缩压" : "舒张压";
          const color = param.color;
          result += `<div style="margin-top: 4px;"><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background-color:${color};margin-right:5px;"></span>${name}: ${param.value ||
            "-"} mmHg</div>`;
        });
        result += "</div>";
        return result;
      }
    },
    legend: {
      data: ["收缩压", "舒张压"],
      top: 0,
      left: "center",
      textStyle: {
        fontSize: 12,
        color: "#666"
      },
      itemWidth: 10,
      itemHeight: 10
    },
    grid: {
      left: "5%",
      right: "5%",
      bottom: "10%",
      top: "15%",
      containLabel: true
    },
    xAxis: {
      type: "category",
      boundaryGap: false,
      data: labels,
      axisLine: {
        lineStyle: {
          color: "#e0e0e0"
        }
      },
      axisLabel: {
        color: "#666",
        fontSize: 11,
        rotate: currentDimension.value === "year" ? 0 : 45,
        interval: currentDimension.value === "year" ? 1 : 0
      }
    },
    yAxis: {
      type: "value",
      name: "mmHg",
      nameTextStyle: {
        color: "#666",
        fontSize: 11,
        padding: [0, 0, 0, 40]
      },
      axisLine: {
        lineStyle: {
          color: "#e0e0e0"
        }
      },
      axisLabel: {
        color: "#666",
        fontSize: 11
      },
      splitLine: {
        lineStyle: {
          color: "#f0f0f0",
          type: "dashed"
        }
      },
      min: function(value) {
        return Math.max(0, value.min - 10);
      },
      max: function(value) {
        return value.max + 10;
      }
    },
    series: [
      {
        name: "收缩压",
        type: "line",
        smooth: true,
        symbol: "circle",
        symbolSize: 6,
        itemStyle: {
          color: "#ff7875",
          borderColor: "#fff",
          borderWidth: 2
        },
        lineStyle: {
          width: 3,
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 1,
            y2: 0,
            colorStops: [
              { offset: 0, color: "#ff7875" },
              { offset: 1, color: "#ff4d4f" }
            ]
          }
        },
        areaStyle: {
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: "rgba(255, 120, 117, 0.3)" },
              { offset: 1, color: "rgba(255, 120, 117, 0.05)" }
            ]
          }
        },
        emphasis: {
          focus: "series",
          itemStyle: {
            symbolSize: 8
          }
        },
        data: series.systolicPressure || [],
        markLine: {
          silent: true,
          lineStyle: {
            color: "#ff4d4f",
            type: "dashed",
            width: 2
          },
          label: {
            formatter: "高血压警戒线 140",
            color: "#ff4d4f",
            fontSize: 10
          },
          data: [
            {
              yAxis: 140,
              name: "高血压警戒线"
            }
          ]
        }
      },
      {
        name: "舒张压",
        type: "line",
        smooth: true,
        symbol: "circle",
        symbolSize: 6,
        itemStyle: {
          color: "#91cc75",
          borderColor: "#fff",
          borderWidth: 2
        },
        lineStyle: {
          width: 3,
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 1,
            y2: 0,
            colorStops: [
              { offset: 0, color: "#91cc75" },
              { offset: 1, color: "#52c41a" }
            ]
          }
        },
        areaStyle: {
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: "rgba(145, 204, 117, 0.3)" },
              { offset: 1, color: "rgba(145, 204, 117, 0.05)" }
            ]
          }
        },
        emphasis: {
          focus: "series",
          itemStyle: {
            symbolSize: 8
          }
        },
        data: series.diastolicPressure || [],
        markLine: {
          silent: true,
          lineStyle: {
            color: "#ff4d4f",
            type: "dashed",
            width: 2
          },
          label: {
            formatter: "高血压警戒线 90",
            color: "#ff4d4f",
            fontSize: 10
          },
          data: [
            {
              yAxis: 90,
              name: "高血压警戒线"
            }
          ]
        }
      }
    ]
  };

  chart.setOption(option);
};

// 渲染心率图表
const renderHeartRateChart = (labels, series) => {
  if (!heartRateChart.value) {
    return;
  }

  const instance = echarts.getInstanceByDom(heartRateChart.value);
  const chart = instance || echarts.init(heartRateChart.value);

  if (!chartInstances.value.includes(chart)) {
    chartInstances.value.push(chart);
  }

  const option = {
    tooltip: {
      trigger: "axis",
      backgroundColor: "rgba(255, 255, 255, 0.95)",
      borderColor: "#e0e0e0",
      borderWidth: 1,
      textStyle: {
        color: "#333"
      },
      formatter: function(params) {
        const param = params[0];
        return (
          `<div style="padding: 8px;"><strong>${param.axisValue}</strong><br/>` +
          `<div style="margin-top: 4px;"><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background-color:${param.color};margin-right:5px;"></span>` +
          `心率: ${param.value || "-"} 次/分钟</div></div>`
        );
      }
    },
    grid: {
      left: "5%",
      right: "5%",
      bottom: "10%",
      top: "15%",
      containLabel: true
    },
    xAxis: {
      type: "category",
      boundaryGap: false,
      data: labels,
      axisLine: {
        lineStyle: {
          color: "#e0e0e0"
        }
      },
      axisLabel: {
        color: "#666",
        fontSize: 11,
        rotate: currentDimension.value === "year" ? 0 : 45,
        interval: currentDimension.value === "year" ? 1 : 0
      }
    },
    yAxis: {
      type: "value",
      name: "次/分钟",
      nameTextStyle: {
        color: "#666",
        fontSize: 11,
        padding: [0, 0, 0, 40]
      },
      axisLine: {
        lineStyle: {
          color: "#e0e0e0"
        }
      },
      axisLabel: {
        color: "#666",
        fontSize: 11
      },
      splitLine: {
        lineStyle: {
          color: "#f0f0f0",
          type: "dashed"
        }
      },
      min: function(value) {
        return Math.max(0, value.min - 10);
      },
      max: function(value) {
        return value.max + 10;
      }
    },
    series: [
      {
        name: "心率",
        type: "line",
        smooth: true,
        symbol: "circle",
        symbolSize: 6,
        itemStyle: {
          color: "#1890ff",
          borderColor: "#fff",
          borderWidth: 2
        },
        lineStyle: {
          width: 3,
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 1,
            y2: 0,
            colorStops: [
              { offset: 0, color: "#1890ff" },
              { offset: 1, color: "#096dd9" }
            ]
          }
        },
        areaStyle: {
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: "rgba(24, 144, 255, 0.3)" },
              { offset: 1, color: "rgba(24, 144, 255, 0.05)" }
            ]
          }
        },
        emphasis: {
          focus: "series",
          itemStyle: {
            symbolSize: 8
          }
        },
        data: series.heartRate || [],
        markLine: {
          silent: true,
          lineStyle: {
            color: "#ff4d4f",
            type: "dashed",
            width: 2
          },
          label: {
            formatter: "心率警戒线 100",
            color: "#ff4d4f",
            fontSize: 10
          },
          data: [
            {
              yAxis: 100,
              name: "心率警戒线"
            }
          ]
        }
      }
    ]
  };

  chart.setOption(option);
};

// 渲染血糖图表
const renderGlucoseChart = (labels, series) => {
  if (!glucoseChart.value) {
    return;
  }

  const instance = echarts.getInstanceByDom(glucoseChart.value);
  const chart = instance || echarts.init(glucoseChart.value);

  if (!chartInstances.value.includes(chart)) {
    chartInstances.value.push(chart);
  }

  const option = {
    tooltip: {
      trigger: "axis",
      backgroundColor: "rgba(255, 255, 255, 0.95)",
      borderColor: "#e0e0e0",
      borderWidth: 1,
      textStyle: {
        color: "#333"
      },
      formatter: function(params) {
        const param = params[0];
        return (
          `<div style="padding: 8px;"><strong>${param.axisValue}</strong><br/>` +
          `<div style="margin-top: 4px;"><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background-color:${param.color};margin-right:5px;"></span>` +
          `血糖: ${param.value || "-"} mmol/L</div></div>`
        );
      }
    },
    grid: {
      left: "5%",
      right: "5%",
      bottom: "10%",
      top: "15%",
      containLabel: true
    },
    xAxis: {
      type: "category",
      boundaryGap: false,
      data: labels,
      axisLine: {
        lineStyle: {
          color: "#e0e0e0"
        }
      },
      axisLabel: {
        color: "#666",
        fontSize: 11,
        rotate: currentDimension.value === "year" ? 0 : 45,
        interval: currentDimension.value === "year" ? 1 : 0
      }
    },
    yAxis: {
      type: "value",
      name: "mmol/L",
      nameTextStyle: {
        color: "#666",
        fontSize: 11,
        padding: [0, 0, 0, 40]
      },
      axisLine: {
        lineStyle: {
          color: "#e0e0e0"
        }
      },
      axisLabel: {
        color: "#666",
        fontSize: 11
      },
      splitLine: {
        lineStyle: {
          color: "#f0f0f0",
          type: "dashed"
        }
      },
      min: function(value) {
        return Math.max(0, value.min - 1);
      },
      max: function(value) {
        return value.max + 1;
      }
    },
    series: [
      {
        name: "血糖",
        type: "line",
        smooth: true,
        symbol: "circle",
        symbolSize: 6,
        itemStyle: {
          color: "#52c41a",
          borderColor: "#fff",
          borderWidth: 2
        },
        lineStyle: {
          width: 3,
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 1,
            y2: 0,
            colorStops: [
              { offset: 0, color: "#52c41a" },
              { offset: 1, color: "#389e0d" }
            ]
          }
        },
        areaStyle: {
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: "rgba(82, 196, 26, 0.3)" },
              { offset: 1, color: "rgba(82, 196, 26, 0.05)" }
            ]
          }
        },
        emphasis: {
          focus: "series",
          itemStyle: {
            symbolSize: 8
          }
        },
        data: series.fastingGlucose || [],
        markLine: {
          silent: true,
          lineStyle: {
            color: "#ff4d4f",
            type: "dashed",
            width: 2
          },
          label: {
            formatter: "血糖警戒线 6.1",
            color: "#ff4d4f",
            fontSize: 10
          },
          data: [
            {
              yAxis: 6.1,
              name: "血糖警戒线"
            }
          ]
        }
      }
    ]
  };

  chart.setOption(option);
};

// 渲染体重图表
const renderWeightChart = (labels, series) => {
  if (!weightChart.value) {
    return;
  }

  const instance = echarts.getInstanceByDom(weightChart.value);
  const chart = instance || echarts.init(weightChart.value);

  if (!chartInstances.value.includes(chart)) {
    chartInstances.value.push(chart);
  }

  const option = {
    tooltip: {
      trigger: "axis",
      backgroundColor: "rgba(255, 255, 255, 0.95)",
      borderColor: "#e0e0e0",
      borderWidth: 1,
      textStyle: {
        color: "#333"
      },
      formatter: function(params) {
        const param = params[0];
        return (
          `<div style="padding: 8px;"><strong>${param.axisValue}</strong><br/>` +
          `<div style="margin-top: 4px;"><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background-color:${param.color};margin-right:5px;"></span>` +
          `体重: ${param.value || "-"} KG</div></div>`
        );
      }
    },
    grid: {
      left: "5%",
      right: "5%",
      bottom: "10%",
      top: "15%",
      containLabel: true
    },
    xAxis: {
      type: "category",
      boundaryGap: false,
      data: labels,
      axisLine: {
        lineStyle: {
          color: "#e0e0e0"
        }
      },
      axisLabel: {
        color: "#666",
        fontSize: 11,
        rotate: currentDimension.value === "year" ? 0 : 45,
        interval: currentDimension.value === "year" ? 1 : 0
      }
    },
    yAxis: {
      type: "value",
      name: "KG",
      nameTextStyle: {
        color: "#666",
        fontSize: 11,
        padding: [0, 0, 0, 40]
      },
      axisLine: {
        lineStyle: {
          color: "#e0e0e0"
        }
      },
      axisLabel: {
        color: "#666",
        fontSize: 11
      },
      splitLine: {
        lineStyle: {
          color: "#f0f0f0",
          type: "dashed"
        }
      },
      min: function(value) {
        return Math.max(0, value.min - 5);
      },
      max: function(value) {
        return value.max + 5;
      }
    },
    series: [
      {
        name: "体重",
        type: "line",
        smooth: true,
        symbol: "circle",
        symbolSize: 6,
        itemStyle: {
          color: "#fa8c16",
          borderColor: "#fff",
          borderWidth: 2
        },
        lineStyle: {
          width: 3,
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 1,
            y2: 0,
            colorStops: [
              { offset: 0, color: "#fa8c16" },
              { offset: 1, color: "#d46b08" }
            ]
          }
        },
        areaStyle: {
          color: {
            type: "linear",
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: "rgba(250, 140, 22, 0.3)" },
              { offset: 1, color: "rgba(250, 140, 22, 0.05)" }
            ]
          }
        },
        emphasis: {
          focus: "series",
          itemStyle: {
            symbolSize: 8
          }
        },
        data: series.weight || []
      }
    ]
  };

  chart.setOption(option);
};

// 处理维度变化
const handleDimensionChange = () => {
  loadHealthData();
};

// 窗口大小变化时重绘图表
const handleResize = () => {
  chartInstances.value.forEach(chart => {
    chart.resize();
  });
};

// 监听visible属性变化
watch(
  () => props.visible,
  newVal => {
    if (newVal) {
      loadHealthData();
    }
  }
);

// 监听userId属性变化
watch(
  () => props.userId,
  () => {
    if (props.visible) {
      loadHealthData();
    }
  }
);

// 组件挂载时初始化
onMounted(() => {
  window.addEventListener("resize", handleResize);

  if (props.visible) {
    loadHealthData();
  }
});

// 组件卸载时销毁图表实例
onUnmounted(() => {
  window.removeEventListener("resize", handleResize);

  chartInstances.value.forEach(chart => {
    chart.dispose();
  });

  chartInstances.value = [];
});
</script>

<style scoped>
.health-detail {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

/* 加载状态 */
.loading-container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 400px;
}

/* 维度选择器 */
.dimension-selector {
  margin-bottom: 24px;
}

.selector-wrapper {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 16px;
  background: #fff;
  padding: 20px 24px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.page-title {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  color: #303133;
}

.dimension-group {
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 数据概览卡片 */
.overview-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 16px;
  margin-bottom: 24px;
}

.card-item {
  flex: 1;
  min-width: 200px;
}

.stat-card {
  height: 100%;
  background: linear-gradient(135deg, #fff 0%, #f9f9f9 100%);
  border: none;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
}

.card-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 24px 16px;
  text-align: center;
}

.card-title {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.card-value {
  font-size: 32px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 4px;
  line-height: 1.2;
}

.card-unit {
  font-size: 12px;
  color: #c0c4cc;
}

/* 图表容器 */
.charts-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.chart-item {
  background: #fff;
  border-radius: 12px;
  padding: 20px 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  transition: box-shadow 0.3s ease;
}

.chart-item:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
}

.chart-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
}

.chart-title {
  margin: 0;
  font-size: 16px;
  font-weight: 500;
  color: #303133;
}

.chart-unit {
  font-size: 12px;
  color: #909399;
}

.chart {
  width: 100%;
  height: 320px;
}

/* 暂无数据状态 */
.no-data {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #fff;
  border-radius: 12px;
  padding: 80px 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.empty-tip {
  margin-top: 16px;
  font-size: 14px;
  color: #909399;
}

/* 响应式布局 */
@media (max-width: 768px) {
  .health-detail {
    padding: 16px;
  }

  .selector-wrapper {
    flex-direction: column;
    align-items: stretch;
    text-align: center;
  }

  .page-title {
    font-size: 18px;
  }

  .overview-cards {
    grid-template-columns: 1fr;
  }

  .chart-item {
    padding: 16px;
  }

  .chart {
    height: 280px;
  }

  .no-data {
    padding: 60px 16px;
  }
}

@media (max-width: 480px) {
  .card-value {
    font-size: 24px;
  }

  .chart {
    height: 240px;
  }
}
</style>