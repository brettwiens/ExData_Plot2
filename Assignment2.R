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

# Plot 3 - Baltimore City Type Emissions
png("plot3.png", width = 480, height = 480)
BaltimoreType <- aggregate(Emissions ~ year + type, BaltimoreFIPS, sum)
names(BaltimoreType) <- c("year","Emission Type", "Emissions")
Plot <- ggplot(BaltimoreType, aes(year, Emissions, color = `Emission Type`))
Plot + geom_line() + labs(title = "Baltimore Emissions by Type", x = "Year", y = "PM 2.5 Emissions") + 
        theme(legend.position = "bottom", legend.title = element_text(face = "bold"), 
        axis.title = element_text(face = "bold"))
dev.off()

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

# Plot 5 - Baltimore On-road
png("plot5.png", width = 480, height = 480)
BaltimoreRoad <- MergedData[MergedData$fips == "24510" & MergedData$type == "ON-ROAD",]
BaltimoreRoadYear <- aggregate(Emissions ~ year, BaltimoreRoad, sum)
plot(BaltimoreRoadYear$year, BaltimoreRoadYear$Emissions, main = "Baltimore Road Emissions", xlab = "Year", 
     ylab = "PM 2.5 Emissions")
lines(BaltimoreRoadYear$year, BaltimoreRoadYear$Emissions, col = "red")
dev.off()

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