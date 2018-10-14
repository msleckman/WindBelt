
# TEXT ANALYSIS IDEAS

install.packages("httr")
install.packages("easypackages")
library(easypackages)
packages("jsonlite", "lubridate", "httr", "rvest")

url = read_html("https://www.google.com/search?hl=en&authuser=0&biw=2166&bih=1161&tbm=nws&ei=9reiW6yEK-eG0wKpuKiQCA&q=%22wind+power%22+%26+%22Bloom+Wind+power%22+%26+%22Kansas%22&oq=%22wind+power%22+%26+%22Bloom+Wind+power%22+%26+%22Kansas%22&gs_l=psy-ab.3...47265.59416.0.60487.10.10.0.0.0.0.91.662.10.10.0....0...1c.1.64.psy-ab..0.0.0....0.FtukcbPk6W4")
url = read_html("https://www.google.com/search?rlz=1C1GGRV_enUS763US763&biw=1600&bih=1089&tbm=nws&ei=DtmuW_vKIr7L0PEPxcaVgA8&q=%22Meadow+Lake+Wind+Farm%22+AND+%22EDP+Renewables+North+America+LLC%22&oq=%22Meadow+Lake+Wind+Farm%22+AND+%22EDP+Renewables+North+America+LLC%22&gs_l=psy-ab.3...7254.9605.0.9892.7.7.0.0.0.0.79.366.6.7.0....0...1c.1.64.psy-ab..0.5.309.0..0.46.jgsHO1kMv9U")
selector_name<-".r"
selector_text <- ".g"
selector_source <- ".f"
fnames<-html_nodes(x = url, css = selector_name) %>%
  html_text()
ftext<-html_nodes(x = url, css = selector_text) %>%
  html_text()
fsource <-html_nodes(x = url, css = selector_source) %>%
  html_text()

fnames
ftext
fsource
########
install_packages("googleAuthR", "searchConsoleR")
packages("googleAuthR", "searchConsoleR")
?list_websites()
scr_auth()

?searchConsoleR

search_analytics("https://www.google.com/search?hl=en&tbm=nws&authuser=0&q=wind+power")


# gbr_desktop_queries <-
#   search_analytics("http://google.com", 
#                                     "2015-07-01", "2015-07-31", 
#                                     c("query", "page"), 
#                                     dimensionFilterExp =c("device==DESKTOP", "country==GBR"), 
#                                     searchType = "web", rowLimit = 100)

?rvest::read_html
