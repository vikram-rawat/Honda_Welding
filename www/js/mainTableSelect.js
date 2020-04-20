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
            Chassis: ""
        },
        apiData: {
            Chassis: []
        },
    },
    methods: {
        SelectDate: function () {
            this.show.Select = "type";
            this.mainTheme.Select.Chassis = ""
            this.mainTheme.Select.Date = "active"
        },
        SelectChassis: function () {
            this.show.Select = "Chassis";
            this.mainTheme.Select.Chassis = "active"
            this.mainTheme.Select.Date = ""
        },
        submitSelect: function () {
            Shiny.setInputValue("daily_data-Select", this.inputValue.Select, {
                priority: "event",
            });
        }
    },
    mounted: function () {},
    computed: {},
    watch: {}
});

// update data for Select Autocomplete
Shiny.addCustomMessageHandler("SelectValue", function (data) {
    dailyFeed.apiData.Select = data;
});

// update dataSubmit on submit click so to reset all input values
Shiny.addCustomMessageHandler("dataSubmit", function (data) {
    dailyFeed.inputValue.Submit = data;
});