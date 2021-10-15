# %% Load data & packages
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.formula.api import ols

df = pd.read_csv("./data/Hamburgers.csv")

# %% Visualizing the Density of the Dependent Variable (Sales)

sns.set_style("darkgrid")
sns.set_context("notebook")
sns.kdeplot(df.sales, fill=True, color="red")
plt.title("Density Plot of Sales", fontweight="bold")
plt.xlabel("Sales")
plt.ylabel("Probability")
plt.show()

# %% Q-Q Plot for the Distribution of Sales

sm.qqplot(df.sales, line='q')
plt.title("Q-Q Plot of Sales", fontweight="bold")
plt.show()

# %% Fitting a Multiple Linear Regression Model

fit = ols(formula="sales ~ price + advert", data=df).fit()
print(fit.summary())