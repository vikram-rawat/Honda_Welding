var searchEngine = new Vue({
  el: "#dailyFeed",
  delimiters: ["{%%", "%%}"],
  data: {
    mainTheme: {
      shiftElevate: "shadow-lg",
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
    zoomShifts: function () {

    }
  },
  mounted: function () {

  },
  computed: {},
  watch: {}
});