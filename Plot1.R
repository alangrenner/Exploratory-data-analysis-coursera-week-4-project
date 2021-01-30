##Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Using the base plotting system, make a plot showing the total PM2.5 emission from all 
#sources for each of the years 1999, 2002, 2005, and 2008.
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
emissions<- NEI %>%
  group_by(year) %>%
  summarize(Total = sum(Emissions,na.rm=TRUE))
emissions

#plotting all years
png("plot1.png", width=480, height=480)
with(emissions,
     plot(x=year,
          y=Total,
          main = "Total emissions per year in the US",
          xlab= "Year",
          ylab = "Emissions",
          cex=2,
          pch=20,
          col="darkgrey",
          lwd=3))
dev.off()