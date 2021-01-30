#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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


#Subseting and merging motor vehicle emissions
SCC.vehicle<- SCC[grep("[Vv]eh",SCC$Short.Name),] #this will subset all 'veh'icles source at Short.Name
motor.baltimore<- NEI %>%
  subset(fips=="24510" & NEI$SCC %in% SCC.vehicle$SCC) %>%
  merge(y = SCC.vehicle,
        by.x="SCC",
        by.y="SCC") %>%
  group_by(year) %>%
  summarize(Vehicle.Emissions = sum(Emissions,na.rm=TRUE))
motor.baltimore


#plotting 
Balt.vehicle <- ggplot(motor.baltimore, aes(year,Vehicle.Emissions))
Balt.vehicle <- Balt.vehicle +
  geom_point(shape=21,
             col="black",
             fill="darkred",
             size=4) +
  xlab("Years") +
  ylab("Emissions(Tons)") +
  ggtitle("Emission by Vehicles in Baltimore") +
  theme_economist()  #this theme is on the 'ggthemes' package 

Balt.vehicle
png("plot5.png", width=500, height=500)
Balt.vehicle
dev.off()