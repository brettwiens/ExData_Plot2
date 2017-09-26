sourceURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("PM25EmissionData.zip")){
  download.file(sourceURL, "PM25EmissionData.zip")
  unzip("PM25EmissionData.zip",overwrite=TRUE)
}

summarySCC <- readRDS("summarySCC_PM25.rds")
ClassCode <- readRDS("Source_Classification_Code.rds")
YearlyEmissions <- aggregate(Emissions ~ year, summarySCC, sum)
MergedData <- merge(summarySCC, ClassCode, by = "SCC")

# Plot 4 - American Coal Combustion
png("plot4.png", width = 480, height = 480)
CoalCases <- c(grep("coal", MergedData$Short.Name, ignore.case = TRUE) 
               , grep("coal", MergedData$EI.Sector, ignore.case =TRUE))
CoalCases <- sort(unique(CoalCases))
CoalClasses <- MergedData[CoalCases,]
CoalEmissions <- aggregate(Emissions ~ year, CoalClasses,sum)
Plot <- ggplot(CoalEmissions, aes(year, Emissions))
Plot + geom_area(fill = "red", alpha = 0.1, color = "black") + labs(title = "Coal-related Emissions by Year"
                                                                    , x = "Year", y = "PM 2.5 Emissions")
dev.off()