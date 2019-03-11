# One metric that is preferred over overall accuracy is the average of specificity and sensitivity, referred
# to as the balanced accuracy.

# In general, sensitivity is defined as the ability of an algorithm to predict a positive outcome when the
# actual outcome is positive. If an algorithm is capable of predict every outcome of a certain category,
# the algorithm has high sensitivity to that category, even if all the other outcomes for other category
# are wrong.

# Specificity is the ability of an algorithm to not predict the positive, so y hat equals 0, when the
# actual outcome is not a positive.

# High sensitivity means y equals 1 implies y hat equals 1.
# High specificity means y equals 0 implies y hat equals 0.

# there's another way to define specificity, and it's by the proportion of positive calls that are
# actually positive.

# high specificity is defined as y hat equals 1 implies y equals 1.

# Because specificity and sensitivity are raised, it is more appropriate to compute the harmonic average of
# specificity with the F1 score, a widely used one number summary, is the harmonic average of precision and
# recall.
# f1_score = 1 / ((1/2) * ((1/recall) + (1/precision)))


# Note that depending on the context, some types of errors are more costly than others.
# For example, in the case of plane safety, it is much more important to maximize sensitivity over
# specificity. Failing to predict a plane will malfunction before it crashes is a much more costly
# error than grounding a plane when in fact the plane is in perfect condition.


# The F1 score can be adopted to weigh specificity and sensitivity differently. To do this, we define
# beta to represent how much more important sensitivity is compared to specificity, and consider a
# weighted harmonic average using this formula.
# weighted_f1 = 1 / ((((beta^2)/(1+beta^2))*(1/recall)) + ((1/(1+beta^2))*(1/precision)))

cutoff <- seq(61,70)
F_1 <- map_dbl(cutoff, function(x){
  y_hat <- ifelse(train_set$height > x, "Male", "Female") %>%
    factor(levels = levels(test_set$sex))
  F_meas(data = y_hat, reference = factor(train_set$sex))
})
F_1
plot(F_1, type = "o")

max(F_1) # 0.6142322

best_cutoff <- cutoff[which.max(F_1)]
best_cutoff

y_hat <- ifelse(test_set$height > best_cutoff, "Male", "Female") %>%
  factor(levels = levels(test_set$sex))
confusionMatrix(data = y_hat, reference = test_set$sex)
