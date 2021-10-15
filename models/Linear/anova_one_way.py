#%% Loading Data & Packages

import pandas as pd, numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from statsmodels.formula.api import ols
from statsmodels.stats.anova import anova_lm


df = pd.read_csv("./data/FolateLevels.csv")

# Converting the group variable to a factor
df.group = [str(x) for x in df.group]

#%% Visualizing the Groups

sns.boxplot(data=df, x="group", y="folate_level")
plt.title("Folate Levels by Group")
plt.xlabel("Group")
plt.ylabel("Folate Levels")
plt.show()

#%% Fitting a Ordinary Least Squares Regression

fit = ols(formula="folate_level ~ group", data=df).fit()

fit.summary()

#%% Getting the ANOVA Results from the OLS Regression


anovaResults = anova_lm(fit)
print(anovaResults)

# P-value is less than 0.05. We reject, at a significance level of 5%,
# the Null Hypothesis that all the data are sampled from populations
# with the same mean (although, we barely reject it, as p ~ 0.04).

