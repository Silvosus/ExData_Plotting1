if (!exists('mydata')) {
	myfile <- "./household_power_consumption.txt"
	if (!file.exists(myfile)) {
		url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
		zipfile <- "./household_power_consumption.zip"
		if (!file.exists(zipfile)){
			download.file(url, destfile=zipfile)
		}
		unzip(zipfile, exdir=".")
	}
	# read the data sets
	mysql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'"
	if (!('sqldf' %in% installed.packages())) {install.packages('sqldf')}
	library(sqldf)
	mydata <- read.csv.sql(myfile, mysql,sep=';',header=TRUE)
	mydata$Date <- strptime(mydata$Date, tz="",format="%d/%m/%Y")
	mydata$Time <- as.POSIXct(paste(mydata$Date,mydata$Time), tz="",format="%Y-%m-%d %H:%M:%S")
}
png(filename = "plot1.png", width = 480, height = 480, units = "px")
plot.new()
par(mfrow=c(1,1))
hist(mydata$Global_active_power, col='red',xlab='Global Active Power (kilowatts)',main='Global Active Power')
dev.off()