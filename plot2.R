## Title: Exploratory Analysis: Power Consumption
##PLOT 2

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

##making plot2"
plot(power$Global_active_power ~ as.POSIXct.POSIXlt(power$date_time),
     data = power,
     type = "l", 
     ylab = "Global Active Power (kilowatts)", 
     xlab = "")

##writing to plot2.png file
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()
