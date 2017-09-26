sourceURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("PM25EmissionData.zip")){
  download.file(sourceURL, "PM25EmissionData.zip")
  unzip("PM25EmissionData.zip",overwrite=TRUE)
}

summarySCC <- readRDS("summarySCC_PM25.rds")
ClassCode <- readRDS("Source_Classification_Code.rds")
YearlyEmissions <- aggregate(Emissions ~ year, summarySCC, sum)
MergedData <- merge(summarySCC, ClassCode, by = "SCC")

# Plot 6 - Los Angeles vs Baltimore
png("plot6.png", width = 480, height = 480)
LosAngelesRoad <- MergedData[MergedData$fips == "06037" & MergedData$type == "ON-ROAD",]
LosAngelesRoadYear <- aggregate(Emissions ~ year, LosAngelesRoad, sum)
LosAngelesRoadYear[3] <- "Los Angeles"
BaltimoreRoadYear[3] <- "Baltimore"
LABA <- rbind(LosAngelesRoadYear,BaltimoreRoadYear)
names(LABA) <- c("year","Emissions","City")
LABAPLOT <- ggplot(LABA, aes(year, Emissions))
LABAPLOT + geom_area(aes(fill = City), alpha = 0.3) + labs(title = "Road Emissions by Year in Baltimore and Los Angeles",
                                                           x = "Year", y = "PM 2.5 Emissions") + theme(legend.position = "bottom",
                                                                                                      axis.title = element_text(face = "bold"))
dev.off()