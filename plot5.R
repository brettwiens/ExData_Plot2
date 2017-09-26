sourceURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("PM25EmissionData.zip")){
  download.file(sourceURL, "PM25EmissionData.zip")
  unzip("PM25EmissionData.zip",overwrite=TRUE)
}

summarySCC <- readRDS("summarySCC_PM25.rds")
ClassCode <- readRDS("Source_Classification_Code.rds")
YearlyEmissions <- aggregate(Emissions ~ year, summarySCC, sum)
MergedData <- merge(summarySCC, ClassCode, by = "SCC")

# Plot 5 - Baltimore On-road
png("plot5.png", width = 480, height = 480)
BaltimoreRoad <- MergedData[MergedData$fips == "24510" & MergedData$type == "ON-ROAD",]
BaltimoreRoadYear <- aggregate(Emissions ~ year, BaltimoreRoad, sum)
plot(BaltimoreRoadYear$year, BaltimoreRoadYear$Emissions, main = "Baltimore Road Emissions", xlab = "Year", 
     ylab = "PM 2.5 Emissions")
lines(BaltimoreRoadYear$year, BaltimoreRoadYear$Emissions, col = "red")
dev.off()