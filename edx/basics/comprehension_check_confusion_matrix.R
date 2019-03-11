# The following questions all ask you to work with the dataset described below.
#
# The reported_heights and heights datasets were collected from three classes taught in the Departments
# of Computer Science and Biostatistics, as well as remotely through the Extension School. The Biostatistics
# class was taught in 2016 along with an online version offered by the Extension School. On 2016-01-25 at
# 8:15 AM, during one of the lectures, the instructors asked student to fill in the sex and height 
# questionnaire that populated the reported_height dataset. The online students filled out the survey
# during the next few days, after the lecture was posted online. We can use this insight to define a
# variable which we will call type, to denote the type of student, inclass or online.
# 
# The code below sets up the dataset for you to analyze in the following exercises:

library(dslabs)
library(dplyr)
library(lubridate)

data("reported_heights")

dat <- mutate(reported_heights, date_time = ymd_hms(time_stamp)) %>%
  filter(date_time >= make_date(2016, 01, 25) & date_time < make_date(2016, 02, 1)) %>%
  mutate(type = ifelse(day(date_time) == 25 & hour(date_time) == 8 & between(minute(date_time), 15, 30), "inclass","online")) %>%
  select(sex, type)

y <- factor(dat$sex, c("Female", "Male"))
x <- dat$type

test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)


train_set <- heights[-test_index,]
test_set <- heights[test_index,]

dat
dat %>% group_by(type) %>%
  summarize(female_prevalence = mean(sex == "Female"), male_prevalence = mean(sex == "Male"))
  
probs <- seq(0, 1, 0.1)
guessing <- map_df(probs, function(x){
  y_hat <- sample(c("Male", "Female"), length(test_index), replace = TRUE, prob = c(x, 1 - x)) %>%
    factor(levels = levels(test_set$sex))
  list(method = "Guessing",
       FPR = 1-specificity(y_hat, test_set$sex),
       TPR = sensitivity(y_hat, test_set$sex),
       recall = sensitivity(y_hat, test_set$sex),
       precision = precision(y_hat, test_set$sex))
})
guessing
  