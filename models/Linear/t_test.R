# Loading Data & Packages -------------------------------------------------

library(ggplot2)
library(ggthemes)
library(dplyr)
library(reshape2)
library(car)

df <-
        as.data.frame(read.csv("./data/Dosage.csv"))


# Plotting the Density Functions by Dose ------------------------------------------

mu <- df %>% group_by(dose) %>% summarise(mean = mean(toxicity))

ggplot(data = df, mapping = aes(x = toxicity, fill = dose,
                                col = dose)) +
        geom_density(alpha = .7) +
        geom_vline(data = mu, aes(xintercept = mean, col = dose),
                   linetype = "dashed",  size = 1) +
        scale_x_continuous(n.breaks = 10) +
        labs(
                title = "Toxicity Level by Dose",
                x = "Toxicity",
                y = "Probability",
                fill = "Dose"
        ) +
        scale_color_viridis_d(option = "inferno", begin = .2, end = .5) +
        scale_fill_viridis_d(option = "inferno", begin = .2, end = .8) +
        theme_hc() +
        theme(
                plot.title = element_text(hjust = .5, face = "bold"),
                legend.position = "right"
        ) +
        guides(col = "none")

# T-Test for Difference in Means ------------------------------------------

t_test <-
        t.test(
                formula = toxicity ~ dose,
                data = df,
                alternative = "two.sided",
                mu = 0,
                paired = F,
                conf.level = .95
        )


# Linear Regression Fit for Difference in Means ---------------------------

fit <-
        lm(
                formula = toxicity ~ dose,
                data = df
        )

sumfit <-
        S(fit)
