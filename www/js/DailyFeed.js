// Autocomplete Component
Vue.component(
  "vue-autocomplete", {
    template: "#vue-autocomplete",
    delimiters: ["{%%", "%%}"],
    props: ['value', 'placeholder', 'suggestions'],
    data() {
      return {
        userInput: '',
        fullInput: '',
        open: false,
        current: 0
      }
    },
    computed: {
      matches() {
        const escaped = this.escapeRegExp(this.userInput)
        const patt = new RegExp(`^(${escaped})`, 'i')
        return this.suggestions.filter((str) => {
          return str.match(patt) !== null
        })
      },
      openSuggestion() {
        return this.open &&
          this.matches.length != 0 &&
          this.userInput !== this.fullInput
      },
    },
    methods: {
      up() {
        this.current--
        if (this.current < 0) {
          this.current = 0
        }
        if (!this.open) this.current = 0
        this.start()
      },
      down() {
        this.current++
        if (this.current >= this.matches.length) {
          this.current = this.matches.length - 1
        }
        if (!this.open) this.current = 0
        this.start()
      },
      stop() {
        this.open = false
      },
      start() {
        this.open = true
        this.setFullInput()
      },
      select(index) {
        this.current = index
        this.start()
        this.enter()
      },
      enter() {
        this.$emit('input', this.fullInput)
      },
      change(event) {
        const n = event.target.value
        const b = this.userInput.length < n.length

        this.userInput = event.target.value

        if (b) {
          this.current = 0
          this.start()
        } else {
          this.stop()
          this.fullInput = this.userInput
        }
      },
      setFullInput() {
        if (this.open === false) {
          return
        }

        var match = this.matches[this.current] || this.userInput
        this.fullInput = match

        setTimeout(() => {
          this.$refs.inp.setSelectionRange(
            this.userInput.length, this.fullInput.length
          )
        }, 0)
      },
      escapeRegExp(str) {
        return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
      }
    },
    watch: {
      value: function (n) {
        this.userInput = n
        this.fullInput = n
        this.setFullInput()
        this.stop()
      }
    },
    mounted() {
      this.userInput = this.value
      this.fullInput = this.value
      this.setFullInput()
      this.stop()
    }
  });

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
    inputValue: {
      Chassis: "",
      Shift: "",
      Zone: "",
      Car: "",
      Submit: ""
    },
    apiData: {
      Chassis: [],
      mappingData: [],
      Zones: [],
      Cars: [],
      Defects: []
    }
  },
  methods: {
    submitChassis: function () {
      Shiny.setInputValue("daily_data-Chassis", this.inputValue.Chassis, {
        priority: "event"
      });
    },
    morningShift: function () {
      this.disable.morningShift = "active";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "disabled";

      this.inputValue.Shift = "morning";

      Shiny.setInputValue("daily_data-Shifts", "morning", {
        priority: "event"
      });
    },
    noonShift: function () {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "active";
      this.disable.nightShift = "disabled";

      this.inputValue.Shift = "noon";

      Shiny.setInputValue("daily_data-Shifts", "noon", {
        priority: "event"
      });
    },
    nightShift: function () {
      this.disable.morningShift = "disabled";
      this.disable.noonShift = "disabled";
      this.disable.nightShift = "active";

      this.inputValue.Shift = "night";

      Shiny.setInputValue("daily_data-Shifts", "night", {
        priority: "event"
      });
    },
    shiftClearAll: function () {
      this.disable.morningShift = "active";
      this.disable.noonShift = "active";
      this.disable.nightShift = "active";

      this.inputValue.Shift = "";

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

      this.inputValue.Zone = zone.name;

      Shiny.setInputValue("daily_data-Zones", zone.name, {
        priority: "event"
      });
    },
    zoneClearAll: function () {
      for (x in this.apiData.Zones) {
        value = this.apiData.Zones[x];
        value.classes = "disabled";
      }

      this.inputValue.Zone = "";

      Shiny.setInputValue("daily_data-Zones", "", {
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

      this.inputValue.Car = car.name;

      Shiny.setInputValue("daily_data-Cars", car.name, {
        priority: "event"
      });
    },
    carClearAll: function () {
      for (x in this.apiData.Cars) {
        value = this.apiData.Cars[x];
        value.classes = "disabled";
      }

      this.inputValue.Car = "";

      Shiny.setInputValue("daily_data-Cars", "", {
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
      uniqueCars.sort()

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
      uniqueDefects.sort()

      $.each(uniqueDefects, (i, v) => {
        item = {};
        item["defect"] = v;
        item["counts"] = 0;
        this.apiData.Defects.push(item);
      });
    },
    "inputValue.Submit": function (newValue, oldValue) {
      Shiny.setInputValue(
        "daily_data-Defects",
        null, {
          priority: "event"
        }
      );
      this.carClearAll();
    }
  }
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
  $('[data-toggle="tooltip"]').tooltip('enable');
});