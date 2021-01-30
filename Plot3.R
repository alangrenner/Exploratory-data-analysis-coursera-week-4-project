#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of 
#these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? 
#Use the ggplot2 plotting system to make a plot answer this question.

library(ggplot2)
library(dplyr)

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


#Grouping by years
emissions.type <- NEI %>%
  subset(fips == "24510") %>%
  group_by(year,type) %>%
  summarize(Total = sum(Emissions, na.rm=TRUE))
  

#plotting 
em1<- ggplot(emissions.type, aes(year, Total))
em1<- em1 +
  geom_point(color="purple",
             size = 3,
             alpha = 0.5,
             shape = 10) +
  facet_grid(.~type) +
  xlab("Years") +
  ylab("Total Emissions") +
  ggtitle("Annual Emissions in Baltimore by year") +
  theme_light()
em1
png("plot3.png", width=480, height=480)
em1
dev.off()