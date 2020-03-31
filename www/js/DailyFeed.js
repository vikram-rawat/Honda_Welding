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
      mappingData: [],
      Zones: [],
      Cars: [],
      Defects: []
    }
  },
  methods: {
    morningShift: function () {
      this.disable.morningShift = "active";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "disabled";

      Shiny.setInputValue("daily_data-Shifts", "Morning", {
        priority: "event"
      });
    },
    noonShift: function () {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "active";
      this.disable.nightShift = "disabled";

      Shiny.setInputValue("daily_data-Shifts", "Noon", {
        priority: "event"
      });
    },
    nightShift: function () {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "active";

      Shiny.setInputValue("daily_data-Shifts", "Night", {
        priority: "event"
      });
    },
    shiftClearAll: function () {
      this.disable.morningShift = "active";
      this.disable.noonShift = "active";
      this.disable.nightShift = "active";
      Shiny.setInputValue("daily_data-Shifts", "", {
        priority: "event"
      });
    },
    zoneClick: function (zone) {
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
    zoneClearAll: function () {
      for (x in this.apiData.Zones) {
        value = this.apiData.Zones[x];
        value.classes = "disabled";
      }
      Shiny.setInputValue("daily_data-Zones", "", {
        priority: "event"
      });
    },
    carClearAll: function () {
      for (x in this.apiData.Cars) {
        value = this.apiData.Cars[x];
        value.classes = "disabled";
      }
      Shiny.setInputValue("daily_data-Cars", "", {
        priority: "event"
      });
    },
    carClick: function (car) {
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
    submitValues: function () {
      Shiny.setInputValue(
        "daily_data-Defects",
        JSON.stringify(this.apiData.Defects), {
          priority: "event"
        }
      );
    },
    submitForm: function () {
      Shiny.setInputValue("daily_data-SubmitForm", "clicked", {
        priority: "event"
      });
    }
  },
  mounted: function () {},
  computed: {
    zoneLength: function () {
      if (this.apiData.Zones.length < 6) {
        return true;
      } else {
        return false;
      }
    },
    carLength: function () {
      if (this.apiData.Cars.length < 6) {
        return true;
      } else {
        return false;
      }
    }
  },
  watch: {
    mappingData: function (newValue, oldValue) {
      this.apiData.Zones = []
      $.each(newValue, (i, v) => {
        item = {}
        item["name"] = v.zones
        item["classes"] = "disabled"
        zones.push(this.apiData.Zones);
      });
    }
  }
});

// update data for Mapping
Shiny
  .addCustomMessageHandler('changeMapping', function (data) {
    dailyFeed.apiData.mappingData = data;
  });

// update data for Zones
// Shiny
//   .addCustomMessageHandler('changeZones', function (data) {
//     dailyFeed.apiData.Zones = data
//   });
// // update data for Cars
// Shiny
//   .addCustomMessageHandler('changeCars', function (data) {
//     dailyFeed.apiData.Cars = data
//   });
// // update data for defects
// Shiny
//   .addCustomMessageHandler('changeDefects', function (data) {
//     dailyFeed.apiData.Defects = data
//   });