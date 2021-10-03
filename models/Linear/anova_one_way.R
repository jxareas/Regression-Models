# Load Packages & Data ----------------------------------------------------

library(dplyr)
library(ggplot2)
library(ggthemes)
library(car)
library(effects)
library(emmeans)

df <-
        as.data.frame(read.csv("./data/Baumann.csv")) |>
        select(group, post.test.3) |>
        rename(post_test = post.test.3)

# Exploring the Data ------------------------------------------------------

summary(df)

# all groups have the same number of observations
xtabs( ~ group, df)



# Density Curves by Group -------------------------------------------------

ggplot(data = df,
       mapping = aes(x = post_test,
                     fill = group, col = group)) +
        geom_density(alpha = .35) +
        labs(title = "Reading Score by Teaching Method",
             x = "Third Post-Test Score",
             y = "Density",
             fill = "Group") +
        theme_bw() +
        theme(
                plot.title = element_text(face = "bold", hjust = .5),
                legend.title = element_text(face = "bold"),
                legend.title.align = .5
        ) + guides(col = "none")


# Boxplots by Group -------------------------------------------------------

ggplot(data = df,
       mapping = aes(x = post_test,
                     y = group, fill = group)) +
        geom_jitter(col = "magenta") +
        stat_boxplot(geom = "errorbar") +
        geom_boxplot(col = "black", alpha = .8) +
        scale_x_continuous(breaks = seq(30, 60, by = 5)) +
        labs(title = "Reading Score by Teaching Method",
             x = "3rd Post-Test Score",
             y = "") +
        theme_hc() +
        theme(
                plot.title = element_text(face = "bold", hjust = .5),
                legend.position = "none"
        )


# Fitting a One-Way ANOVA Linear Regression -------------------------------

# The coefficients are the estimates for the difference in means
# with respect to the reference category
fit_anova <-
        lm(
                post_test ~ group,
                data = df
        )

fit_summary <-
        S(fit_anova)

fit <-
        list(
                "anova" = fit_anova,
                "summary" = fit_summary
        )
        
rm(list=c("fit_anova", "fit_summary"))

# Running an ANOVA Test on the Linear Model -------------------------------

# H0: identical means between groups
# H1: at least one pair of means have a considerable difference
aov_fit <-
        aov(formula = post_test ~ group, data = df)

# There's a significant difference between groups, the p-value for the
# test is less than the significance level (5%)
anova(aov_fit)

# Tukey's Honestly Significant Difference
# The Difference between DRTA-Basal is statistically significant
# at a 95% confidence level
tukey <-
        TukeyHSD(aov_fit)

# Computing the Estimated Marginal Means ----------------------------------

means <-
        emmeans(fit$anova, pairwise ~ group)


fit$emmeans <-
        means$emmeans

# only the difference in means between Basal & DRTA is significantly
# different from zero, with a p-value of less than 0.05
fit$diffs <-
        means$contrasts

rm("means")


# Plotting Predictor Effects of the ANOVA Test -----------------------------

plot(predictorEffects(fit$anova),
     main = "Group Predictor Effect Plot",
     xlab = "Group",
     ylab = "Post-Test Score",
     confint=list(style = "bars"),
     lwd = 2.5)

