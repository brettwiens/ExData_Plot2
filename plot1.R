sourceURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("PM25EmissionData.zip")){
  download.file(sourceURL, "PM25EmissionData.zip")
  unzip("PM25EmissionData.zip",overwrite=TRUE)
}

summarySCC <- readRDS("summarySCC_PM25.rds")
ClassCode <- readRDS("Source_Classification_Code.rds")
YearlyEmissions <- aggregate(Emissions ~ year, summarySCC, sum)
MergedData <- merge(summarySCC, ClassCode, by = "SCC")

## Plot 1 - Total Emissions Decreased from 1999 to 2008
png("plot1.png", width = 480, height = 480)
plot(YearlyEmissions$year, YearlyEmissions$Emissions, main = "Total Emissions from all Sources", xlab = "Year", 
     ylab = "Total Emissions", pch = 21, col = "blue", bg = "red")
lines(YearlyEmissions$year, YearlyEmissions$Emissions, col = "red")
dev.off()