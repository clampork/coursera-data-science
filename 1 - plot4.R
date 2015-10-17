# Download dataset if it does not exist in working directory
df_zip_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
df_zip <- "exdata_data_household_power_consumption.zip"

if(!file.exists(df_zip)) {
    download.file(url = df_zip_url, destfile = df_zip)
}

# Unzip and load data frame
df_filename <- "household_power_consumption.txt"
df_file <- unz(df_zip, filename = df_filename)
df_full <- read.table(df_file, header = TRUE, sep = ";", na.strings = "?")
df <- subset(df_full, df_full$Date == "1/2/2007" | df_full$Date == "2/2/2007")

# Convert date and time variables to datetime
datetime <- paste(df$Date, df$Time)
df$Datetime <- strptime(datetime, "%d/%m/%Y %H:%M:%S")

# Plot and save histogram as PNG
# Note: Discrepancy between instructions for 480x480 PNG and original 504x504 PNG
png(filename = "plot4.png", width = 480, height = 480, bg = "transparent")
par(mfrow = c(2, 2))
with(df, {
    # Top left plot
    plot(Datetime, Global_active_power,
         type = "l",
         xlab = "",
         ylab = "Global Active Power")
    # Top right plot
    plot(Datetime, Voltage,
         type = "l",
         xlab = "datetime",
         ylab = "Voltage")
    # Bottom left plot
    plot(Datetime, Sub_metering_1, 
         type = "l", 
         xlab = "",
         ylab="Energy sub metering")
    lines(Datetime, Sub_metering_2,
          col = "red")
    lines(Datetime, Sub_metering_3,
          col="blue")
    legend(x = "topright",
           c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           lty = 1,
           col = c("black", "red", "blue"),
           bty = "n")
    # Bottom right plot
    plot(Datetime, Global_reactive_power,
         type = "l",
         xlab = "datetime")
})
dev.off()