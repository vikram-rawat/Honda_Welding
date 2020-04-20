// Vue main App for entire app
var mainTableSelect = new Vue({
    el: "#mainTableSelect",
    delimiters: ["{%%", "%%}"],
    data: {
        disable: {},
        mainTheme: {
            Select: {
                Date: "active",
                Chassis: ""
            }
        },
        show: {
            Select: "Date"
        },
        inputValue: {
            Chassis: "",
            Date: ""
        },
        apiData: {
            Chassis: []
        },
    },
    methods: {
        SelectDate: function () {
            this.show.Select = "Date";
            this.mainTheme.Select.Chassis = ""
            this.mainTheme.Select.Date = "active"
        },
        SelectChassis: function () {
            this.show.Select = "Chassis";
            this.mainTheme.Select.Chassis = "active"
            this.mainTheme.Select.Date = ""
        },
        submitData: function () {

            if (this.mainTheme.Select.Chassis == "active") {
                if (this.inputValue.Chassis != "") {
                    Shiny.setInputValue("gttable-FilterParams",
                        JSON.stringify({
                            Chassis: this.inputValue.Chassis,
                            Date: null
                        }), {
                            priority: "event",
                        });
                } else {
                    Shiny.setInputValue("gttable-RaiseFlag",
                        "Chassis", {
                            priority: "event",
                        });
                }
            } else {
                if (this.inputValue.Date != "") {
                    Shiny.setInputValue("gttable-FilterParams",
                        JSON.stringify({
                            Chassis: null,
                            Date: this.inputValue.Date
                        }), {
                            priority: "event",
                        });
                } else {
                    Shiny.setInputValue("gttable-RaiseFlag",
                        "Date", {
                            priority: "event",
                        });
                }
            }
        }
    },
    mounted: function () {},
    computed: {},
    watch: {}
});

// update data for Select Autocomplete
Shiny.addCustomMessageHandler("ChassisValues", function (data) {
    mainTableSelect.apiData.Chassis = data;
});