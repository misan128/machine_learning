# When comparing two or more methods
  # for example, guessing versus using a height cutoff in our predict sex with height example
# we looked at accuracy and F1.

# The second method, the one that used height, clearly outperformed. However, while for the second method
# we consider several cutoffs, for the first one we only considered one approach, guessing with equal
# probability.

# Note that guessing male with higher probability would give us higher accuracy due to the bias in the
# sample.

library(dslabs)
library(gplots)
data(heights)

y <- heights$sex # Categorical outcomes: male / female
x <- heights$height # Features

set.seed(2) # Seed for random

test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)

train_set <- heights[-test_index,]
test_set <- heights[test_index,]

p <- 0.9
y_hat <- sample(c("Male", "Female"), length(test_index), replace = TRUE, prob = c(p, 1 - p)) %>%
  factor(levels = levels(test_set$sex))

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

# By guessing 90% of the time, we make our accuracy go up to 0.69.
# But as previously described, this would come at a cost of lower sensitivity.

mean(y_hat == test_set$sex) # 0.69 -> 69%

# Note that for each of these parameters, we can get a different sensitivity and specificity.
# For this reason, a very common approach to evaluating methods is to compare them graphically by 
# plotting both.
# A widely used plot that does this is the Receiver Operating Characteristic or ROC curve.

cutoff <-  c(50, seq(60, 75), 80)
height_cutoff <- map_df(cutoff, function(x){
  y_hat <- ifelse(test_set$height > x, "Male", "Female") %>%
    factor(levels = c("Female", "Male"))
  list(method = "Height cutoff",
       FPR = 1-specificity(y_hat, test_set$sex),
       TPR = sensitivity(y_hat, test_set$sex),
       recall = sensitivity(y_hat, test_set$sex),
       precision = precision(y_hat, test_set$sex))
})
height_cutoff

## Sensitivity vs 1-Specificity

plot(height_cutoff$FPR, height_cutoff$TPR,
     type = "o",
     xlab = "1 - Specificity",
     ylab = "Sensitivity",
     col = "navy")
text(height_cutoff$FPR, height_cutoff$TPR, labels=cutoff, cex= 0.7, pos = 3)
lines(guessing$FPR, guessing$TPR,
      type = "o",
      col = "olivedrab")
legend(0.45, 0.3, legend = c("Height cutoff","Guessing"),
       col = c("navy", "olivedrab"), lty = 1:1)

## recall vs precision
plot(height_cutoff$recall, height_cutoff$precision,
     type = "o",
     xlab = "Recall",
     ylab = "Precision",
     col = "navy")
text(height_cutoff$recall, height_cutoff$precision, labels=cutoff, cex= 0.7, pos = 3)
lines(guessing$recall, guessing$precision,
      type = "o",
      col = "olivedrab")
legend(0.45, 0.17, legend = c("Recall","Precision"),
       col = c("navy", "olivedrab"), lty = 1:1)


