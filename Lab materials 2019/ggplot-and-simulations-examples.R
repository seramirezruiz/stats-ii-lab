########################################
# randomly generated variables and ggplot2 examples
# stats II lab - spring 2019 - gabriel tarriba
########################################

library(tidyverse)

# In this file we generate random variables from  normal distributions and plot graphs using ggplot2
# NOTE: You may adapt the code for your assignments but please use different examples! Otherwise you won't get marks

################################
# Example 1: Salary, education and experience

# Let's assume that salary is an additive function of education and experience
exp <- rnorm(1000, 15, 4) # Mean experience is 15 years, std. dev = 5 years
educ <- rnorm(1000, 12, 2) # Mean educ = 12 years, std. dev = 2 years
salary <- 20000 + 100*(exp*educ) # Salary is 20,000 plus 100 times the product of experience and education
dat <- data.frame(exp, educ, salary) # We create a data frame with the variables created, and indicate that 

# Now we plot them in a scatter plot - no relationship!
ggplot(dat, aes(x = exp, y = educ)) +
  geom_point() + 
  xlab("Experience") + 
  ylab("Education") +
  geom_smooth(method='lm') # This adds a best-fit line (lm = linear model) with confidence intervals (95%)

# Now let's control for salary - we create a dataset with salaries around the mean
mean(dat$salary)
dat2 <- subset(dat, salary >= 37000 & salary < 38000)

# We plot once again the relationship between experience and education, for people with very similar salaries
# We have induced a negative relationship!
ggplot(dat2, aes(x = exp, y = educ)) +
  geom_point() + 
  xlab("Experience") + 
  ylab("Education") +
  geom_smooth(method='lm')

################################
# Example 2: Sex, height, weight

# Let's think of sex, height and weight as mutually related variables
sex <- rep(c("male", "female"), each = 500) # We create 500 "women" and 500 "men"...
height <- rnorm(500, 165, 7) + 10*as.numeric(sex == "male") # Height has a mean of 165 and std. dev. of 7, we add 7 if it's a male
weight <- (height - 100) + rnorm(500, 0, 7) # Weight is a function of height plus a random disturbance with mean 0 and std. dev. 7
dat3 <- data.frame(sex, height, weight)

# We plot them all together and spot a positive relationship...
ggplot(dat3, aes(x = weight, y = height)) +
  geom_point() + 
  xlab("Weight (kg)") + 
  ylab("Height (cm)") +
  geom_smooth(method='lm')

# Now we distinguish between men and women, but the relationship between weight and height persists within each group.
ggplot(dat3, aes(x = weight, y = height, color = sex)) +
  geom_point() + 
  xlab("Weight (kg)") + 
  ylab("Height (cm)") +
  geom_smooth(method='lm')

################################
# Example 3: Gender, shoe size, income

gender <- rep(c("male", "female"), each = 500) # We create 500 "women" and 500 "men"...
shoe_size <- rnorm(1000, 38, 2) + 4 * as.numeric(gender == "male") # Shoe size is a random number plus 4 if the subject is male
income = rnorm(1000, 25, 2) + 5 * as.numeric(gender == "male") # Income is a random number plus 5 if the subject is male
dat <- data.frame(gender, shoe_size, income, stringsAsFactors = FALSE)

# We plot the relationship between shoe size and income - there seems to be a positive relationship
ggplot(dat, aes(x = shoe_size, y = income)) +
  geom_point() +
  geom_smooth(method='lm') + 
  guides(color = FALSE) + 
  xlab("Shoe Size") + ylab("Income") + 
  theme(axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15)) 

# But if we condition on gender, the relationship disappears
ggplot(dat, aes(x = shoe_size, y = income, color = gender)) +
  geom_point() + 
  geom_smooth(method='lm') +
  guides(color = FALSE) + 
  xlab("Shoe Size") + ylab("Income") + 
  theme(axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15)) 
  


       