library(googledrive)
library(readr)
library(tidyverse)
library(scales)

# drive_find(n_max = 30)

df_meta <- drive_get("Blood_Pressure_Tracking")

drive_download("Blood_Pressure_Tracking", type = "csv", overwrite = TRUE)



df <- read_csv("Blood_Pressure_Tracking.csv")

df_1 <- 
  df %>% 
  mutate(Date2=as.Date(Date,"%m/%d/%Y"),
         Datetime_string=paste0(Date2," ",str_pad(coalesce(Hour,0),2,"left","0"),":",str_pad(coalesce(Minute,0),2,"left","0"),":00"),
         Datetime=as.POSIXct(Datetime_string)
  )

# temp <- spline(df_1$Systolic)
# length(unlist(spline(df_1$Systolic)))
# length(unlist(df_1$Systolic))
# 
# spline_int <- as.data.frame(spline(df_1$Datetime, df_1$Systolic))

  # ggplot() + 
  # geom_point(aes(x = hour, y = impressions, colour = cvr), size = 3) +
  # geom_line(data = spline_int, aes(x = x, y = y))
  # 

color_sys <- "darkblue"
color_dia <- "darkgreen"
color_pulse <- "orange"

xmin_df <- df_1 %>% select(Datetime) %>% unlist() %>% min() %>%  as.POSIXct(origin = '1970-01-01')
xmax_df <- df_1 %>% select(Datetime) %>% unlist() %>% max() %>%  as.POSIXct(origin = '1970-01-01')

refline_sys_high <-130 
refline_sys_low <- 110 
refline_dia_high <- 90
refline_dia_low <- 70  
refline_pulse_high <- 75
refline_pulse_low <- 55  

date_medication_1 <- as.POSIXct(as.Date("2020-12-01"),origin = '1970-01-01')
date_medication_2 <- as.POSIXct(as.Date("2021-01-08"),origin = '1970-01-01')
date_medication_1_label <- as.POSIXct(as.Date("2020-12-02"),origin = '1970-01-01')
date_medication_2_label <- as.POSIXct(as.Date("2021-01-09"),origin = '1970-01-01')

alpha <- 0.2

line_size <- 0.1

plot_1 <- 
  df_1 %>% 
  ggplot()+
  stat_smooth(aes(x=Datetime, y=Systolic, colour=color_sys), formula = y ~ s(x, k = 60), method = "gam", se = FALSE)+
  stat_smooth(aes(x=Datetime, y=Diastolic, colour="darkgreen"), formula = y ~ s(x, k = 40), method = "gam", se = FALSE)+
  stat_smooth(aes(x=Datetime, y=Pulse, colour="orange"), formula = y ~ s(x, k = 40), method = "gam", se = FALSE)+
  geom_line(aes(x=Datetime, y=Systolic), colour=color_sys, size=line_size)+
  geom_line(aes(x=Datetime, y=Diastolic), colour="darkgreen", size=line_size)+
  geom_line(aes(x=Datetime, y=Pulse), colour="orange", size=line_size)+  
  geom_point(aes(x=Datetime, y=Systolic), colour=color_sys)+
  geom_point(aes(x=Datetime, y=Diastolic), colour="darkgreen")+
  geom_point(aes(x=Datetime, y=Pulse), colour="orange")+
  scale_x_datetime( limits=c(xmin_df,xmax_df),  expand = c(0.05, 0.05), breaks = date_breaks("1 week"))+
  scale_y_continuous(breaks = seq(50, 180, by = 10), limits=c(50,185),  expand = c(0.05,0.0))+
  annotate("rect", xmin = xmin_df, xmax = xmax_df, ymin = refline_sys_low, ymax = refline_sys_high, alpha = alpha, fill=color_sys)+
  annotate("rect", xmin = xmin_df, xmax = xmax_df, ymin = refline_dia_low, ymax = refline_dia_high, alpha = alpha, fill=color_dia)+
  annotate("rect", xmin = xmin_df, xmax = xmax_df, ymin = refline_pulse_low, ymax = refline_pulse_high, alpha = alpha, fill=color_pulse)+
  annotate("segment", x = date_medication_1, xend = date_medication_1, y = 50, yend = 185, colour="black")+
  annotate("segment", x = date_medication_2, xend = date_medication_2, y = 50, yend = 165, colour="black")+
  annotate("text", x = date_medication_1_label, y = 185, hjust = 0, vjust= 1, label = c("Starting to take BP medication"), size=3.5)+
  annotate("text", x = date_medication_2_label, y = 165, hjust = 0, vjust= 1, label= c("Starting to take beta blockers \nIncreased dose of BP medication"),size=3.5)+
  theme(panel.border = element_blank(),
        panel.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x=element_text( size = 10 , angle=-45),
        axis.text.y=element_text( size = 10),
        title=element_text( size = 14),
        legend.text = element_text( size = 12),
        plot.margin=unit(c(2,1,2,1),"cm"),
        legend.position=c(.80,0.95),
        legend.justification='left'
        # legend.direction = "horizontal"      
        )+
  scale_color_identity(guide = "legend",
                       name = "",
                      # breaks = c("black", "red", "blue"),
                       labels = c("Systolic BP", "Diastolic BP", "Heart rate")
                       # guide = "legend"
                       )+
  # guides(color = guide_legend(order=1))+
  ggtitle("Blood pressure and heart rate tracking\n")

# plot_2
  
print(plot_1)

ggsave("plot_1.png", width = 12, height = 8)



