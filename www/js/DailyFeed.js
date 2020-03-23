var searchEngine = new Vue({
  el: "#dailyFeed",
  delimiters: ["{%%", "%%}"],
  data: {
    disable: {
      morningShift: "active",
      noonShift: "active",
      nightShift: "active"
    },
    mainTheme: {
      stateTheme: {
        m6: false,
        l6: false,
        m12: true,
        l12: true
      }
    },
    show: {
      SubmitBtns: false,
      Services: false,
      Locations: false
    },
    disable: {
      SubmitBtns: false,
      Services: false,
      Locations: false
    },
    inputValue: {
      States: "",
      Locations: "",
      Services: ""
    },
    apiData: {
      Zones: ["Zone 1", "Zone 2", "Zone 3", "Zone 4"],
      Cars: ["Toyota", "Suzuki", "Honda", "SomeModal"],
      Defects: ["a", "b", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n"]
    }
  },
  methods: {
    morningShift: function () {
      this.disable.morningShift = "active"
      this.disable.noonShift = "disabled"
      this.disable.nightShift = "disabled"
    },
    noonShift: function () {
      this.disable.morningShift = "disabled"
      this.disable.noonShift = "active"
      this.disable.nightShift = "disabled"
    },
    nightShift: function () {
      this.disable.morningShift = "disabled"
      this.disable.noonShift = "disabled"
      this.disable.nightShift = "active"
    },
    shiftClearAll: function () {
      this.disable.morningShift = "active"
      this.disable.noonShift = "active"
      this.disable.nightShift = "active"
    }
  },
  mounted: function () {

  },
  computed: {},
  watch: {}
});