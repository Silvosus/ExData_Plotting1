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
png(filename = "plot4.png", width = 480, height = 480, units = "px")
plot.new()
par(mfrow=c(2,2))
plot(mydata$Global_active_power,type='l',axes=FALSE,ylab='Global Active Power (kilowatts)',xlab='')
v1 <- c(0,1440,2880)
axis(side = 1,at = v1,labels = c("Thu", "Fri", "Sat"))
box()
axis(2)
plot(mydata$Voltage,type='l',axes=FALSE,ylab='Voltage',xlab='datetime')
v1 <- c(0,1440,2880)
axis(side = 1,at = v1,labels = c("Thu", "Fri", "Sat"))
box()
axis(2)
plot(mydata$Sub_metering_1,type='l',axes=FALSE,ylab='Energy sub metering',xlab='')
lines(mydata$Sub_metering_2,col='red')
lines(mydata$Sub_metering_3,col = 'blue')
v1 <- c(0,1440,2880)
axis(side = 1,at = v1,labels = c("Thu", "Fri", "Sat"))
box()
axis(2)
legend("topright", cex = 0.7, c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), horiz=FALSE, lty=c(1,1,1), lwd=c(2,2,2), col=c("black","red","blue"))
plot(mydata$Global_reactive_power,type='l',axes=FALSE,ylab='Global_reactive_power',xlab='datetime')
v1 <- c(0,1440,2880)
axis(side = 1,at = v1,labels = c("Thu", "Fri", "Sat"))
box()
axis(2)
dev.off()