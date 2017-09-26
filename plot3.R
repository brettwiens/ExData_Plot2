sourceURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("PM25EmissionData.zip")){
  download.file(sourceURL, "PM25EmissionData.zip")
  unzip("PM25EmissionData.zip",overwrite=TRUE)
}

summarySCC <- readRDS("summarySCC_PM25.rds")
ClassCode <- readRDS("Source_Classification_Code.rds")
YearlyEmissions <- aggregate(Emissions ~ year, summarySCC, sum)
MergedData <- merge(summarySCC, ClassCode, by = "SCC")

# Plot 3 - Baltimore City Type Emissions
png("plot3.png", width = 480, height = 480)
BaltimoreType <- aggregate(Emissions ~ year + type, BaltimoreFIPS, sum)
names(BaltimoreType) <- c("year","Emission Type", "Emissions")
Plot <- ggplot(BaltimoreType, aes(year, Emissions, color = `Emission Type`))
Plot + geom_line() + labs(title = "Baltimore Emissions by Type", x = "Year", y = "PM 2.5 Emissions") + 
  theme(legend.position = "bottom", legend.title = element_text(face = "bold"), 
        axis.title = element_text(face = "bold"))
dev.off()