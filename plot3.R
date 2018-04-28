## Title: Exploratory Analysis: Power Consumption
##PLOT 3

library(sqldf)

##Downloading file if file "DataCleanProject.zip" does not exist
dlMeth <- "curl" # sets default for OSX / Linux
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(substr(Sys.getenv("OS"),1,7) == "Windows") dlMeth <- "wininet"
if(!file.exists("powerConsumption.zip")) {
    download.file(url,
                  "powerConsumption.zip",  # stores file in R working directory
                  method=dlMeth, # use OS-appropriate method
                  mode="w") # "w" means "write," and is used for text files
}
unzip(zipfile = "powerConsumption.zip")
fl <- "household_power_consumption.txt"

##reading data from 02/01/2007 - 02/02/2007
sqlStatement <- "select * from file where Date = '1/2/2007' or Date = '2/2/2007' "
power <- read.csv.sql(fl, sql = sqlStatement, sep = ";")

##cleaning NA values if needed 
power[power == "?"] = NA

##formatting Date and Time variables
power$date_time <- strptime(paste(power$Date, power$Time),
                            "%e/%m/%Y %T")

##"plot3.R"
plot(power$Sub_metering_1 ~ as.POSIXct.POSIXlt(power$date_time),
     data = power,
     type = "l", 
     ylab = "Energy Submetering", 
     xlab = "")
lines(power$Sub_metering_2 ~ as.POSIXct.POSIXlt(power$date_time),
      col = "red")
lines(power$Sub_metering_3 ~ as.POSIXct.POSIXlt(power$date_time),
      col = "blue")
legText <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
legCol <- c("black", "red", "blue")
legend("topright", legend = legText, lwd = 1, col = legCol)

##writing to plot3.png file
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()
