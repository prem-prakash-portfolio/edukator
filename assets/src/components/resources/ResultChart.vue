<template>
  <apexchart :options="options()" :series="series" type="radialBar" />
</template>
<script>
import VueApexCharts from "vue-apexcharts";
export default {
  components: {
    apexchart: VueApexCharts
  },
  props: {
    series: Array
  },
  data() {
    return {
      options: function() {
        return {
          plotOptions: {
            radialBar: {
              startAngle: -90,
              endAngle: 90,
              track: {
                background: "#e7e7e7",
                strokeWidth: "97%",
                margin: 5, // margin is in pixels
                shadow: {
                  enabled: true,
                  top: 2,
                  left: 0,
                  color: "#999",
                  opacity: 1,
                  blur: 2
                }
              },
              dataLabels: {
                name: {
                  show: false
                },
                value: {
                  offsetY: -15,
                  fontSize: "25px"
                }
              }
            }
          },
          fill: {
            type: "gradient",
            gradient: {
              shade: "light",
              shadeIntensity: 0.4,
              inverseColors: false,
              opacityFrom: 1,
              opacityTo: 1,
              stops: [0, 50, 53, 91]
            }
          },
          labels: this.labels,
          legend: {
            show: true,
            position: "bottom",
            offsetY: 10
          },
          colors: [this.userColor, "#0685F6"]
        };
      }
    };
  },
  computed: {
    isExamSession() {
      return this.series.length == 2;
    },
    labels() {
      if (this.isExamSession) {
        return ["Seu Resultado", "Média"];
      } else {
        return ["Seu Resultado"];
      }
    },
    userColor() {
      if (this.isExamSession) {
        if (this.series[0] < this.series[1]) {
          return "#F60618";
        } else return "#06F6AA";
      } else return "#0685F6";
    }
  }
};
</script>
