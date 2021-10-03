# Loading Packages & Data -------------------------------------------------

library(dplyr)
library(ggplot2)
library(ggfortify)
library(ggthemes)
library(car)

df <-
        as.data.frame(read.csv("./data/Davis.csv"))


# Fitting a Simple Linear Regression Model --------------------------------

fit <-
        lm(
                formula = weight ~ repwt,
                data = Davis
        )

linear <-
        list(
                "fit" = fit,
                "summary" = S(fit)
        )

rm("fit")


# Confidence & Prediction Intervals ---------------------------------------

prediction <- 
        Predict(
                object = with(linear, fit),
                interval = "prediction",
                level = 0.95
        ) |> as.data.frame()

prediction <- cbind(prediction, "response" = linear$fit$model$weight)


confidence <-
        Confint(
                object = with(linear, fit),
                interval = "confidence",
                type = "terms",
                level = 0.95
        )


# Plotting the Linear Regression Fit --------------------------------------

ggplot(data = prediction) +
        geom_ribbon(
                mapping = aes(x = fit, y = response,
                              ymin = lwr, ymax = upr),
                alpha = 0.2, fill = "blue", color = "darkblue",
                linetype = "dashed"
        ) +
        geom_point(
                data = df,
                mapping = aes(x = repwt, y = weight, col = weight)
        )  +
        geom_smooth(method = lm, data = df,
                    mapping = aes(repwt, weight), formula = y ~ x,
                    color = "green", size = 1.25) +
        labs(
                title = "Simple Linear Fit",
                x = "Reported Weight",
                y = "Weight"
        ) +
        scale_color_gradient(low = "blue", high = "magenta") +
        theme(
                plot.title = element_text(face = "bold", hjust = .5),
                legend.position = "none"
        )



# Regression Diagnostic Plots ---------------------------------------------


autoplot(with(linear, fit), which = 1:6, colour = "darkblue",
         smooth.colour = "magenta", ad.colour = "black",
         label.n = 0, ncol = 3, size = 2
) +
        theme_stata() +
        theme(
                plot.title = element_text(face = "bold", hjust = .5),
                axis.title.x = element_text(face = "bold", color = "dimgrey"),
                axis.title.y = element_text(face = "bold", color = "dimgrey"),
        )


# Testing for Outliers: Leverage & Influence ------------------------------


# Calculating the Influence Measures: Dffits, Dbetas, Hat Values,
# Cook's Distance
influence <- 
        with(linear, fit) |> 
        influence.measures()


influence <- influence[[1]] |> 
        as.data.frame()

# Top 5 Influential Observations: Cook's Distance
influence |> 
        select(cook.d, dffit) |> 
        arrange(desc(cook.d)) |> 
        head(5)

# Top 5 Observations with the Highest Leverage
influence |> 
        select(hat) |> 
        arrange(desc(hat)) |> 
        head(5)


# Updating the Linear Model: Removing the 12th Observation ----------------

old_fit <- linear$fit

linear$fit <-
        update(
        linear$fit, 
        subset = -12
)

linear$summary <-
        S(linear$fit)

# The Standard Errors have been reduced after dropping the outlier
compareCoefs(old_fit, linear$fit)

# High Reduction of the Residual Standard Deviation
c(
        "old" = S(old_fit)$sigma,
        "new" = linear$summary$sigma
)

# Tremendous Increase in the Coefficient Of Determination
c(
        "old" = S(old_fit)$r.squared,
        "new" = linear$summary$r.squared
)





# Linear Hypothesis Test -------------------------------------------------------

linearHypothesis(
        linear$fit,
        diag(2),
        c(0, 1))

