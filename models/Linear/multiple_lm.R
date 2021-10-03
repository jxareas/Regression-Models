# Loading Packages & Data -------------------------------------------------

library(car)
library(effects)

df <- 
        as.data.frame(read.csv("./data/Prestige.csv"))


# Scatterplot Matrix ------------------------------------------------------

scatterplotMatrix (~ prestige + log(income) + education + women,
                  data=Prestige, col = "deeppink")

# Fitting a Multiple Linear Regression  -----------------------------------

# coefficient for women is not statistically significant
fit <-
        lm(
                formula = prestige ~ log(income) + education + women,
                data = df
        )

linear <-
        list(
                "fit" = fit,
                "summary" = S(fit)
        )

rm("fit")


# Predictor Effects Plot --------------------------------------------------

plot(predictorEffects(linear$fit, residuals=T),
     partial.residuals=list(cex = 0.8, col=gray(0.5), lty=5, pch = 20),
     confint = list(style="bands")
     )

