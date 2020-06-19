app <- ShinyDriver$new("../../", shinyOptions = list(port = 9000))
app$snapshotInit("hw_tests")

app$setInputs(`main_app-app_mainbody-edit_tables-chooseTable` = "mappings")
app$snapshot()
app$setInputs(`main_app-app_sidebar-mainSidebar` = "DailyFeed")
app$snapshot()
app$setInputs(`main_app-app_sidebar-mainSidebar` = "Summary")
app$snapshot()
