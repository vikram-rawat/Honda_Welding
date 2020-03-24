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
      Zones: [
        { name: "Zone 1", classes: "disabled" },
        { name: "Zone 2", classes: "disabled" },
        { name: "Zone 3", classes: "disabled" },
        { name: "Zone 4", classes: "disabled" }
      ],
      Cars: [
        { name: "Maruti", classes: "disabled" },
        { name: "Maruti2", classes: "disabled" },
        { name: "Maruti3", classes: "disabled" },
        { name: "Maruti4", classes: "disabled" },
        { name: "Maruti5", classes: "disabled" },
        { name: "Maruti6", classes: "disabled" }
      ],
      Defects: [
        { defect: "defect1", counts: 0 },
        { defect: "defect2", counts: 0 },
        { defect: "defect3", counts: 0 },
        { defect: "defect3", counts: 0 },
        { defect: "defect4", counts: 0 },
        { defect: "defect5", counts: 0 }
      ]
    }
  },
  methods: {
    morningShift: function() {
      this.disable.morningShift = "active";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "disabled";

      Shiny.setInputValue("daily_data-Shifts", "Morning", {
        priority: "event"
      });
    },
    noonShift: function() {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "active";
      this.disable.nightShift = "disabled";

      Shiny.setInputValue("daily_data-Shifts", "Noon", { priority: "event" });
    },
    nightShift: function() {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "active";

      Shiny.setInputValue("daily_data-Shifts", "Night", { priority: "event" });
    },
    shiftClearAll: function() {
      this.disable.morningShift = "active";
      this.disable.noonShift = "active";
      this.disable.nightShift = "active";
      Shiny.setInputValue("daily_data-Shifts", "", { priority: "event" });
    },
    zoneClick: function(zone) {
      for (x in this.apiData.Zones) {
        value = this.apiData.Zones[x];
        if (value.name != zone.name) {
          value.classes = "disabled";
        } else {
          value.classes = "active";
        }
      }
      Shiny.setInputValue("daily_data-Zones", zone.name, {
        priority: "event"
      });
    },
    zoneClearAll: function() {
      for (x in this.apiData.Zones) {
        value = this.apiData.Zones[x];
        value.classes = "disabled";
      }
      Shiny.setInputValue("daily_data-Zones", "", {
        priority: "event"
      });
    },
    carClearAll: function() {
      for (x in this.apiData.Cars) {
        value = this.apiData.Cars[x];
        value.classes = "disabled";
      }
      Shiny.setInputValue("daily_data-Cars", "", {
        priority: "event"
      });
    },
    carClick: function(car) {
      for (x in this.apiData.Cars) {
        value = this.apiData.Cars[x];
        if (value.name != car.name) {
          value.classes = "disabled";
        } else {
          value.classes = "active";
        }
      }
      Shiny.setInputValue("daily_data-Cars", car.name, {
        priority: "event"
      });
    },
    submitValues: function() {
      Shiny.setInputValue(
        "daily_data-Defects",
        JSON.stringify(this.apiData.Defects),
        {
          priority: "event"
        }
      );
    },
    submitForm: function() {
      Shiny.setInputValue("daily_data-SubmitForm", "clicked", {
        priority: "event"
      });
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
