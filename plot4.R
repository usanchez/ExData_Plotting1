library(magrittr)

# Read data
hpc_file <- file("../household_power_consumption.txt")
hpc_data <- read.table(hpc_file, na.strings = '?', header = TRUE, stringsAsFactors = FALSE, sep = ";")

# Get only dates between "2007-02-01" and "2007-02-02"
hpc_data$Date %<>% as.Date("%e/%m/%Y")
hpc_data %<>% subset(((Date >= as.Date("2007-02-01")) & (Date <= as.Date("2007-02-02"))))

# Check data
#str(hpc_data)

# Convert data and create a DateTime variable
hpc_data$DateTime <- paste(hpc_data$Date, hpc_data$Time)
hpc_data$DateTime %<>% strptime("%Y-%m-%d %H:%M:%S")
hpc_data$Date <- NULL
hpc_data$Time <- NULL
hpc_data <- hpc_data[,c(ncol(hpc_data), 1:(ncol(hpc_data)-1))]
hpc_data$Global_active_power %<>% as.double()
hpc_data$Global_reactive_power %<>% as.double()
hpc_data$Voltage %<>% as.double()
hpc_data$Global_intensity %<>% as.double()
hpc_data$Sub_metering_1 %<>% as.double()
hpc_data$Sub_metering_2 %<>% as.double()
hpc_data$Sub_metering_3 %<>% as.double()

# Re-check
#summary(hpc_data)

# Plot 4
par(mfrow = c(2,2), mar = c(4,4,2,1), oma = c(0,0,2,0))
with(hpc_data, {
  plot(DateTime, Global_active_power, type = "l", 
       ylab = "Global Active Power", xlab = "")
  plot(DateTime, Voltage, type = "l", ylab = "Voltage", xlab = "datetime")
  plot(DateTime, Sub_metering_1, type = "l", ylab = "Energy sub metering",
       xlab = "")
  lines(DateTime, Sub_metering_2, col = 'Red')
  lines(DateTime, Sub_metering_3, col = 'Blue')
  legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2, 
         bty = "n",
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(DateTime, Global_reactive_power, type = "l", 
       ylab = "Global_rective_power", xlab = "datetime")
})
dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()
