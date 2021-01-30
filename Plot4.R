#Across the United States, how have emissions from coal 
#combustion-related sources changed from 1999–2008?


library(ggplot2)
library(dplyr)
library(ggthemes)

#Downloading and reading into R
url<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destFile <- "destfile.zip"
if(!file.exists(destFile)){
  download.file(url,
                destfile = destFile,
                method = "curl")
  unzip(destFile,exdir=".")
}

NEI<- readRDS("summarySCC_PM25.rds")
SCC<- readRDS("Source_Classification_Code.rds")


#Subseting and merging COAL emission
SCC.coal<- SCC[grep("[Cc]oal",SCC$EI.Sector),] #this will subset all 'coal' related pollutions
NEI.coal.sub<- subset(NEI,
                  NEI$SCC %in% SCC.coal$SCC)
NEI.coal <- merge(x=NEI.coal.sub,
                  y=SCC,
                  by.x="SCC",
                  by.y="SCC")
#Grouping by year
NEI.total.coal <- NEI.coal %>%
  group_by(year) %>%
  summarize(Total = sum(Emissions, na.rm=TRUE))

#plotting 
Coal <- ggplot(NEI.total.coal, aes(year,Total))
Coal <- Coal +
  geom_point(shape=21,
             col="black",
             fill="darkred",
             size=4) +
  xlab("Years") +
  ylab("Emissions") +
  ggtitle("Coal Emissions by Year in the US") +
  theme_economist() #this theme is on the 'ggthemes' package

Coal
png("plot4.png", width=480, height=480)
Coal
dev.off()