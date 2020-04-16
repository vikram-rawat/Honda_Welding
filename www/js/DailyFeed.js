// Function for finding unique array
function unique(array) {
  return $.grep(array, function (el, index) {
    return index === $.inArray(el, array);
  });
}

// Vue main App for entire app
var dailyFeed = new Vue({
  el: "#dailyFeed",
  delimiters: ["{%%", "%%}"],
  data: {
    disable: {
      morningShift: "disable",
      noonShift: "disable",
      nightShift: "disable",
    },
    mainTheme: {
      Chassis: {
        Select: "active",
        Type: "",
      },
      stateTheme: {
        m6: false,
        l6: false,
        m12: true,
        l12: true,
      },
    },
    show: {
      Chassis: "select",
    },
    inputValue: {
      Chassis: "",
      Shift: "",
      Zone: "",
      Car: "",
      Submit: "",
    },
    apiData: {
      Chassis: [],
      mappingData: [],
      Zones: [],
      Cars: [],
      Defects: [],
    },
  },
  methods: {
    selectClickChassis: function () {
      this.show.Chassis = "select";
      this.mainTheme.Chassis.Select = "active"
      this.mainTheme.Chassis.Type = ""
    },
    typeClickChassis: function () {
      this.show.Chassis = "type";
      this.mainTheme.Chassis.Select = ""
      this.mainTheme.Chassis.Type = "active"
    },
    submitChassis: function () {
      Shiny.setInputValue("daily_data-Chassis", this.inputValue.Chassis, {
        priority: "event",
      });
    },
    morningShift: function () {
      this.disable.morningShift = "active";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "disabled";

      this.inputValue.Shift = "morning";

      Shiny.setInputValue("daily_data-Shifts", "morning", {
        priority: "event",
      });
    },
    noonShift: function () {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "active";
      this.disable.nightShift = "disabled";

      this.inputValue.Shift = "noon";

      Shiny.setInputValue("daily_data-Shifts", "noon", {
        priority: "event",
      });
    },
    nightShift: function () {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "active";

      this.inputValue.Shift = "night";

      Shiny.setInputValue("daily_data-Shifts", "night", {
        priority: "event",
      });
    },
    shiftClearAll: function () {
      this.disable.morningShift = "active";
      this.disable.noonShift = "active";
      this.disable.nightShift = "active";

      this.inputValue.Shift = "";

      Shiny.setInputValue("daily_data-Shifts", "", {
        priority: "event",
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

      this.inputValue.Zone = zone.name;

      Shiny.setInputValue("daily_data-Zones", zone.name, {
        priority: "event",
      });
    },
    zoneClearAll: function () {
      for (x in this.apiData.Zones) {
        value = this.apiData.Zones[x];
        value.classes = "disabled";
      }

      this.inputValue.Zone = "";

      Shiny.setInputValue("daily_data-Zones", "", {
        priority: "event",
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

      this.inputValue.Car = car.name;

      Shiny.setInputValue("daily_data-Cars", car.name, {
        priority: "event",
      });
    },
    carClearAll: function () {
      for (x in this.apiData.Cars) {
        value = this.apiData.Cars[x];
        value.classes = "disabled";
      }

      this.inputValue.Car = "";

      Shiny.setInputValue("daily_data-Cars", "", {
        priority: "event",
      });
    },
    submitValues: function () {
      Shiny.setInputValue(
        "daily_data-Defects",
        JSON.stringify(this.apiData.Defects), {
          priority: "event",
        }
      );
    },
    submitForm: function () {
      Shiny.setInputValue("daily_data-SubmitForm", "clicked", {
        priority: "event",
      });
    },
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
    },
  },
  watch: {
    "inputValue.Shift": function (newValue, oldValue) {},
    "apiData.mappingData": function (newValue, oldValue) {
      this.apiData.Zones = [];
      zones = [];

      $.each(newValue, (i, v) => {
        zones.push(v.zones);
      });

      zones = unique(zones);
      zones.sort();

      $.each(zones, (i, v) => {
        item = {};
        item["name"] = v;
        item["classes"] = "disabled";
        this.apiData.Zones.push(item);
      });
    },
    "inputValue.Zone": function (newValue, oldValue) {
      this.apiData.Cars = [];
      cars = [];

      $.each(this.apiData.mappingData, (i, v) => {
        item = {};
        if (v.zones == this.inputValue.Zone) {
          item["name"] = v.cars;
          cars.push(item);
        }
      });

      uniqueCars = [];
      $.each(cars, (i, v) => {
        uniqueCars.push(v.name);
      });

      uniqueCars = unique(uniqueCars);
      uniqueCars.sort();

      $.each(uniqueCars, (i, v) => {
        item = {};
        item["name"] = v;
        item["classes"] = "disabled";
        this.apiData.Cars.push(item);
      });
    },
    "inputValue.Car": function (newValue, oldValue) {
      this.apiData.Defects = [];
      defects = [];

      $.each(this.apiData.mappingData, (i, v) => {
        item = {};
        if (v.zones == this.inputValue.Zone && v.cars == this.inputValue.Car) {
          item["defect"] = v.problems;
          defects.push(item);
        }
      });

      uniqueDefects = [];
      $.each(defects, (i, v) => {
        uniqueDefects.push(v.defect);
      });

      uniqueDefects = unique(uniqueDefects);
      uniqueDefects.sort();

      $.each(uniqueDefects, (i, v) => {
        item = {};
        item["defect"] = v;
        item["counts"] = 0;
        this.apiData.Defects.push(item);
      });
    },
    "inputValue.Submit": function (newValue, oldValue) {
      Shiny.setInputValue("daily_data-Defects", null, {
        priority: "event",
      });
      this.carClearAll();
    },
  },
});

// update data for Mapping
Shiny.addCustomMessageHandler("changeMapping", function (data) {
  dailyFeed.apiData.mappingData = data;
});

// update data for Chassis Autocomplete
Shiny.addCustomMessageHandler("ChassisValue", function (data) {
  dailyFeed.apiData.Chassis = data;
});

// update dataSubmit on submit click so to reset all input values
Shiny.addCustomMessageHandler("dataSubmit", function (data) {
  dailyFeed.inputValue.Submit = data;
});

// initializing Tooltips from bootstrap 4
$(document).ready(function () {
  $('[data-toggle="tooltip"]').tooltip("enable");
  $().button("toggle");
  $().button("dispose");
});