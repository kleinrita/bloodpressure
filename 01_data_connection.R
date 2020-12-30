library("googledrive")
library(readr)
library(tidyverse)

drive_find(n_max = 30)

df_meta <- drive_get("Blood_Pressure_Tracking")
drive_download("Blood_Pressure_Tracking", type = "csv")



df <- read_csv("Blood_Pressure_Tracking.csv")

df_1 <- 
  df %>% 
  mutate(Date2=as.Date(Date,"%m/%d/%Y"),
         Datetime_string=paste0(Date2," ",str_pad(coalesce(Hour,0),2,"left","0"),":",str_pad(coalesce(Minute,0),2,"left","0"),":00"),
         Datetime=as.POSIXct(Datetime_string)
  )

temp <- spline(df_1$Systolic)
length(unlist(spline(df_1$Systolic)))
length(unlist(df_1$Systolic))

spline_int <- as.data.frame(spline(df_1$Datetime, df_1$Systolic))

  ggplot(d) + 
  geom_point(aes(x = hour, y = impressions, colour = cvr), size = 3) +
  geom_line(data = spline_int, aes(x = x, y = y))



df_1 %>% 
  ggplot()+
  stat_smooth(aes(x=Datetime, y=Systolic), formula = y ~ s(x, k = 60), method = "gam", se = FALSE,colour="darkblue")+
  stat_smooth(aes(x=Datetime, y=Diastolic), formula = y ~ s(x, k = 40), method = "gam", se = FALSE,colour="darkgreen")+
  stat_smooth(aes(x=Datetime, y=Pulse), formula = y ~ s(x, k = 40), method = "gam", se = FALSE,colour="orange")+
  geom_line(aes(x=Datetime, y=Systolic), colour="darkblue")+
  geom_line(aes(x=Datetime, y=Diastolic), colour="darkgreen")+
  geom_line(aes(x=Datetime, y=Pulse), colour="orange")+  
  geom_point(aes(x=Datetime, y=Systolic), colour="darkblue")+
  geom_point(aes(x=Datetime, y=Diastolic), colour="darkgreen")+
  geom_point(aes(x=Datetime, y=Pulse), colour="orange")+
  scale_y_continuous(breaks = seq(50, 190, by = 10))
  



