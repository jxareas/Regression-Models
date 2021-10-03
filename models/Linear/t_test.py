# %% Loading Data & Packages

import statsmodels.formula.api as smf
import pandas as pd
from scipy.stats import ttest_ind

df = pd.read_csv("./data/Evaluation.csv")

# %% Defining the independent variable for the Hypothesis Test

df["female"] = df["gender"] == "female"

# %% Fitting a t-test for Difference in Means as a Simple Linear Regression Model

lm = smf.ols("score ~ female", data=df).fit()

predictions = lm.predict()

lm.summary()

# %% Applying a t-test Difference in Mean as a Hypothesis Test

t_test = ttest_ind(
    a=df.query("female").score,
    b=df.query("not female").score,  # Male
    equal_var=True)

# %% Comparing both Approaches

print("P-values: ", [round(x[1], 4) for x in [lm.pvalues, t_test]])

print("F-Statistic: ", [round(x, 4) for x in [lm.tvalues[1], t_test[0]]])
