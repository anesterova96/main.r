library(httr)
library(jsonlite)
library(plyr)
library(ggplot2)
library("car")

load_data <- function() { 
  json_data <- fromJSON('https://demo.ckan.org/api/action/package_search?facet.field=[%22tags%22]&facet.limit=10&rows=0')
  
  df <- data.frame(names=json_data$result$search_facets$tags$items$display_name, count=json_data$result$search_facets$tags$items$count)
  colnames(df)[2] <- "Частота использования"
  return(df)
}

printScatterPlot <- function() { 
  ggplot(df, aes(x=names, y=`Частота использования`)) +
    geom_point(shape=1) + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    scale_x_discrete(name ="Названия тегов") +
    labs(subtitle="используемых наборами данных на ckan.org", 
         title="Топ 10 тегов")
}

plotQq <- function() {
  qqPlot(df$`Частота использования`, ylab="Частота появления", xlab="Квантили", main="QQ - график для частоты появления тэгов")
}

df <- load_data()
printScatterPlot()
plotQq()