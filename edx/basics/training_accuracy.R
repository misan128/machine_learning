# Predict sex-- female or male-- using height.

library(dslabs)
library(caret)
library(magrittr)
library(dplyr)
library(purrr)
library(rerf)
data(heights)


# 'data.frame':	1050 obs. of  2 variables:
#  $ sex   : Factor w/ 2 levels "Female","Male": 2 2 2 2 2 1 1 1 1 2 ...
#  $ height: num  75 70 68 74 61 65 66 62 66 67 ...
str(heights)


y <- heights$sex # Categorical outcomes: male / female
x <- heights$height # Features

# Ultimately, a machine learning algorithm is evaluated on how it performs in the real world with others
# running the code.
# However, when developing an algorithm, we usually have a data set for which we know the outcomes as we
# do with the heights. We know the sex of every student.Therefore, to mimic the ultimate evaluation 
# process, we typically split the data into two and act as if we don't know the outcome for one of these
# two sets.
# We stop pretending we don't know the outcome to evaluate the algorithm, but only after we're done
# constructing it.

set.seed(2) # Seed for random

# The caret package includes the function createDataPartition that helps us generate indexes for randomly
# splitting the data into training and test sets.
# The argument times in functions is used to define how many random samples of indexes to return.
# The argument p is used to define what proportion of the index represented and the argument list is used
# to decide you want indexes to be returned as a list or not.

test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)


train_set <- heights[-test_index,]
test_set <- heights[test_index,]

y_hat <- sample(c("Male", "Female"), length(test_index), replace = TRUE) %>% factor(levels = levels(test_set$sex))
y_hat

mean(y_hat == y) # Around 50% because is guessing

# Exploratory data as it suggests we can because on average, males are slightly taller than females.

heights %>% group_by(sex) %>% summarize(mean(height), sd(height))

y_hat <- ifelse(x > 65, "Male", "Female") %>% factor(levels = levels(y))
y_hat

mean(y_hat == y) # Around 80% 

cutoff <- seq(61, 70) # Generate regular sequences
accuracy <- map_dbl(cutoff, function(x){
  y_hat <- ifelse(train_set$height > x, "Male", "Female") %>% factor(levels = levels(y))
  print(mean(y_hat == y)) # Around 80% 
})
cutoff
accuracy

plot(cutoff, accuracy, type = "o")

max(accuracy)

best_cutoff <- cutoff[which.max(accuracy)]
best_cutoff

y_hat <- ifelse(test_set$height > best_cutoff, "Male", "Female") %>% factor(levels = levels(y))
mean(y_hat == test_set$sex)


# If we study this table closely, it reveals a problem.

table(predicted = y_hat, actual = test_set$sex)

# If we compute the accuracy separately for each sex, we get the following. We get that we get a very
# high accuracy for males, 93%, but a very low accuracy for females.

test_set %>%
  mutate(y_hat = y_hat) %>% # añade la columna y_hat al test_set
  group_by(sex) %>% # agrupa por sexo
  summarize(accuracy = mean(y_hat == sex))

# There's an imbalance in the accuracy for males and females. Too many females are predicted to be male.
# In fact, we're calling close to half females males. How can our overall accuracy we so high, then?
# This is because of the prevalence. There are more males in the data sets than females.
# These heights were collected from three data science courses, two of which had more males enrolled.

prev <- mean(y == "Male")
prev

# At the end, we got that 77% of the students were male. So when computing overall accuracy, the high
# percentage of mistakes made for females is outweighted by the gains in correct calls for men.


confusionMatrix(data = y_hat, reference = test_set$sex)

