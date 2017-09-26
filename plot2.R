sourceURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("PM25EmissionData.zip")){
  download.file(sourceURL, "PM25EmissionData.zip")
  unzip("PM25EmissionData.zip",overwrite=TRUE)
}

summarySCC <- readRDS("summarySCC_PM25.rds")
ClassCode <- readRDS("Source_Classification_Code.rds")
YearlyEmissions <- aggregate(Emissions ~ year, summarySCC, sum)
MergedData <- merge(summarySCC, ClassCode, by = "SCC")

## Plot 2 - Baltimore City, Maryland Emissions
png("plot2.png", width = 480, height = 480)
BaltimoreFIPS <- subset(summarySCC, fips == "24510")
BaltimoreYearly <- aggregate(Emissions ~ year, BaltimoreFIPS,sum)
plot(BaltimoreYearly$year, BaltimoreYearly$Emissions, main = "Total Emissions in Baltimore", xlab = "Year", 
     ylab = "Total Emissions")
lines(BaltimoreYearly$year, BaltimoreYearly$Emissions, col = "red")
# lines(smooth.spline(BaltimoreYearly$year, BaltimoreYearly$Emissions), col = "black")  # Add a trend line for fun
points(BaltimoreYearly$year, BaltimoreYearly$Emissions, pch = 21, bg = "yellow")
dev.off()