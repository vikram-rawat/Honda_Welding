var dailyFeed = new Vue({
  el: "#dailyFeed",
  delimiters: ["{%%", "%%}"],
  data: {
    disable: {
      morningShift: "disable",
      noonShift: "disable",
      nightShift: "disable"
    },
    mainTheme: {
      stateTheme: {
        m6: false,
        l6: false,
        m12: true,
        l12: true
      }
    },
    show: {},
    inputValue: {},
    apiData: {
      Zones: ["Zone 1", "Zone 2", "Zone 3", "Zone 4"],
      Cars: ["Toyota", "Suzuki", "Honda", "SomeModal"],
      Defects: ["a", "b", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n"]
    }
  },
  methods: {
    morningShift: function() {
      this.disable.morningShift = "active";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "disabled";
      console.log("button Clicked Morning");
      Shiny.setInputValue("daily_data-Shifts", "Morning", {
        priority: "event"
      });
    },
    noonShift: function() {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "active";
      this.disable.nightShift = "disabled";
      console.log("button Clicked Noon");

      Shiny.setInputValue("daily_data-Shifts", "Noon", { priority: "event" });
    },
    nightShift: function() {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "active";
      console.log("button Clicked Night");

      Shiny.setInputValue("daily_data-Shifts", "Night", { priority: "event" });
    },
    shiftClearAll: function() {
      this.disable.morningShift = "active";
      this.disable.noonShift = "active";
      this.disable.nightShift = "active";
      Shiny.setInputValue("daily_data-Shifts", "", { priority: "event" });
    }
  },
  mounted: function() {},
  computed: {
    zoneLength: function() {
      if (this.apiData.Zones.length < 6) {
        return true;
      } else {
        return false;
      }
    },
    carLength: function() {
      if (this.apiData.Cars.length < 6) {
        return true;
      } else {
        return false;
      }
    }
  },
  watch: {}
});
