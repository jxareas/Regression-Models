# %% Load Data & Packages
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from statsmodels.graphics.gofplots import qqplot
from statsmodels.formula.api import ols

df = pd.read_csv("./data/HeartRate.csv")

# %% Plotting the OLS Regression with Confidence Bands

sns.set_style("darkgrid")
sns.set_context("notebook")
sns.regplot(data=df, x="age", y="maxrate",
            scatter_kws={"color": "blue"}, line_kws={"color": "red"})
plt.title("Maximum Heart Rate vs Age", fontweight="bold")
plt.xlabel("Age (Years)")
plt.ylabel("Maximum Heart Rate")
plt.show()

#%% qqplot for the Linear Regression Model

qqplot(data=df.maxrate, line="q")
plt.title("Q-Q Plot: Maximum Heart Rate", fontweight="bold")
plt.show()

# %% Fitting a Linear Regression Model

fit = ols(formula="maxrate~age", data=df).fit()

print(fit.summary())
