##Have total emissions from PM2.5 decreased in the Baltimore City, 
#Maryland (fips == "24510") 
#from 1999 to 2008? Use the base plotting system to make a plot answering this question.
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
baltimore.emissions<- NEI %>%
  subset(fips=="24510") %>% #this will subset only the codes related to Baltimore
  group_by(year) %>%
  summarize(Total = sum(Emissions,na.rm=TRUE))
baltimore.emissions

#plotting all years in Baltimore
png("plot2.png", width=480, height=480)
with(baltimore.emissions,
     plot(x=year,
          y=Total,
          main = "Emissions in Baltimore",
          xlab= "Years",
          ylab = "Total emission",
          cex=2,
          pch=20,
          col="darkgreen",
          lwd=3))
dev.off()