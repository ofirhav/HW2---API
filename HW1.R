install.packages("jsonlite")
install.packages('curl')
install.packages("ggmap")
require("jsonlite")
library(ggmap)

jsonData <- fromJSON("http://dev.virtualearth.net/REST/v1/Traffic/Incidents/50,2.5,58,9?key=AvrDZTCvZ5v_X0m6mAnLHx0shcIWojjs20aWvBWVpRnaoIUDokU1eth0Mon2o08h")
jsonData$resourceSets$estimatedTotal

data <- jsonData$resourceSets$resources
type <- table(data[[1]][[12]])
severity <- table(data[[1]][[8]])
barplot(type,main="Type Of Incident",names.arg = c("Accident","Congestion","DisabledVehicle","Miscellaneous","OtherNews", "PlannedEvent", "RoadHazard","Construction"),xlab = 'Type' , ylab = 'Number Of Incidents',col = c("aquamarine3", "coral","red", "blue"))
barplot(severity,xlab = 'Severity' ,names.arg = c("LowImpact", "Minor" ,"Moderate", "Serious"), ylab = 'Number Of Incidents', main = "Number of incidents by severity", col = c("blue", "orange", "black", "pink"))
barplot(table(data[[1]][[7]]),xlab = 'Type' , ylab = 'Number Of Incidents', col = c("black", "white"), main = "Road blocked?")


#map graph
long = sapply(data[[1]][[2]][[2]],function(v) v[[1]])
lata = sapply(data[[1]][[2]][[2]],function(v) v[[2]])
df = data.frame(long,lata)

# getting the map
map <- get_map(location = c(lon = mean(lata), lat = mean(long)) , zoom = 6, maptype = "satellite", scale = 2)
# plotting the map with some points on it
ggmap(map) +
  geom_point(data = df, aes(x = lata, y = long, color = "red", alpha = 0.1), size = 2, shape = 21) +  guides(fill=FALSE, alpha=FALSE, size=FALSE)
