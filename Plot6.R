##Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, 
#California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

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


#Subseting and merging motor vehicle emissions in Baltimore
SCC.vehicle<- SCC[grep("[Vv]eh",SCC$Short.Name),] #this will subset all 'veh'icles source at Short.Name
motor.baltimore<- NEI %>%
  subset(fips=="24510" & NEI$SCC %in% SCC.vehicle$SCC) %>%
  merge(y = SCC.vehicle,
        by.x="SCC",
        by.y="SCC") %>%
  group_by(year) %>%
  summarize(Vehicle.Emissions = sum(Emissions,na.rm=TRUE))
motor.baltimore1<- cbind(motor.baltimore,"City" = rep("Baltimore", 4))

#Vehicle emissions in Los Angeles
motor.angeles<- NEI %>%
  subset(fips=="06037" & NEI$SCC %in% SCC.vehicle$SCC) %>%
  merge(y = SCC.vehicle,
        by.x="SCC",
        by.y="SCC") %>%
  group_by(year) %>%
  summarize(Vehicle.Emissions = sum(Emissions,na.rm=TRUE))
motor.angeles1<- cbind(motor.angeles,"City" =rep("Los Angeles",4))

#Combining both
motor.comp <- rbind(motor.baltimore1, motor.angeles1)
motor.comp

#plotting 
City.comparison <- ggplot(motor.comp, aes(year,Vehicle.Emissions, col=City))
City.comparison <- City.comparison +
  geom_point(size=4, alpha=1/2,shape=16) +
  xlab("Years") +
  ylab("Emissions(Tons)") +
  ggtitle("Vehicle emissions in LA and Baltimore") +
  theme_economist()  #this theme is on the 'ggthemes' package 
  
City.comparison
png("plot6.png", width=500, height=500)
City.comparison
dev.off()