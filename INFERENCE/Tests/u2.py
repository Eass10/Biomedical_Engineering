"""
Utility functions for Statistical Inference on "La Liga" and "Champions League" datasets

Enrique Almazán Sánchez
Víctor Miguel Álvarez Camarero
Matías Nevado

(2024)
"""
import utils as u

import pandas as pd
import numpy as np
from numpy import sqrt

import matplotlib.pyplot as plt
import seaborn as sns

import statsmodels.api as sm
import scipy.stats as stats
from scipy.stats import t, kstest, shapiro, wilcoxon
from statsmodels.stats.proportion import proportions_ztest




def visual_normality_test(x1, color, bins=20):
    """
    Performs visual normality test on a given dataset.

    Parameters:
    - x1 (array-like): Input data array.
    - color (str): Color for histogram.
    - bins (int, optional): Number of bins for histogram. Default is 20.

    Outputs:
    - Displays three plots:
        1. Normalized histogram of the input data with the fitted normal distribution curve.
        2. Boxplot of the input data.
        3. QQ Plot (Quantile-Quantile Plot) of the input data.
    """
    
    # Calculate mean and standard deviation of the input data
    mu1 = np.mean(x1)
    sigma1 = np.std(x1, ddof=1)  # unbiased std

    # Create a figure with multiple subplots
    plt.figure(figsize=(20, 4))

    # Plot 1: Normalized histogram with fitted normal distribution curve
    ax1 = plt.subplot(2, 3, 1)
    ax1.hist(x1, bins=bins, density=True, color=color)
    x1_axis = np.linspace(mu1 - 4 * sigma1, mu1 + 4 * sigma1, 100)
    ax1.plot(x1_axis, stats.norm.pdf(x1_axis, mu1, sigma1), 'r', linewidth=2)
    ax1.set_title('Normalized histogram')

    # Plot 2: Boxplot of the input data
    ax2 = plt.subplot(2, 3, 2)
    ax2.boxplot(x1)
    ax2.set_title('Boxplot')

    # Plot 3: QQ Plot (Quantile-Quantile Plot) of the input data
    ax3 = plt.subplot(2, 3, 3)
    stats.probplot(x1, dist="norm", plot=ax3)
    ax3.set_title('QQ Plot')

    # Display all plots
    plt.show()



def numerical_normality(x, return_p=None):
    """
    Tests if the given dataset x follows a normal distribution.
    
    Parameters:
    - x (array or dataframe): dataset to be tested.
    
    Outputs:
    - None (prints the result of the normality test)
    """
    
    # Check if the dataset size is greater than 50 for using KS test,
    # otherwise use Shapiro-Wilk test
    if x.shape[0] > 50:
        # Perform Kolmogorov-Smirnov test
        ks_statistic, p_value = kstest(x, 'norm', args=(x.mean(), x.std()))
        print('Kolmogorov-Smirnov statistic:', ks_statistic)
        print('p-value:', p_value)
    else:
        # Perform Shapiro-Wilk test
        sw_statistic, p_value = shapiro(x)
        print('Shapiro-Wilk Statistic:', sw_statistic)
        print('p-value:', p_value)
        
    # Interpret the p-value: if it's greater than 0.05, the data is likely normal
    if p_value > 0.05:
        print('The data follows a normal distribution.')
    else:
        print('The data does not follow a normal distribution.')

    if return_p:
        return p_value


def calculator(df, team, years, results=False, totals=False, points=False, percentages=False):
    """
    Calculate win, draw, and loss percentages for a specific team and year(s).

    Parameters:
    - df (DataFrame): DataFrame containing La Liga match data.
    - team (str): Name of the team to calculate percentages for.
    - years (int or list of ints): Year(s) to filter matches for.
    - results (bool, optional): Whether to return results. Defaults to False.
    - totals (bool, optional): Whether to return total results or home vs away. Default to Falase.
    - points (bool, optional): Whether to return the average points. Default to False
    - percentages (bool, optional): Whether to return percentages. Defaults to False.

    Outputs:
    - results (list): List with the number of winnings (home and away), draws and losses (home and away).
    - av_points (float): Average points won by the specified teams in the specified year(s).
    - win_percentage (float): Percentage of matches won by the specified team in the specified year(s).
    - draw_percentage (float): Percentage of matches drawn by the specified team in the specified year(s).
    - loss_percentage (float): Percentage of matches lost by the specified team in the specified year(s).
    """

    # Filter matches for the specified team
    team_matches = df[(df['HOME_TEAM'] == team) | (df['AWAY_TEAM'] == team)]

    # Filtering matches for the specified year(s)
    if type(years) == int:
        team_year_matches = team_matches[team_matches['DATE_TIME'].dt.year == years]
    else:
        team_year_matches = team_matches[team_matches['DATE_TIME'].dt.year.isin(years)]
    
    # Calculate the number of wins, home and away
    home_wins = ((team_year_matches['HOME_TEAM'] == team) & (team_year_matches['FTHG'] > team_year_matches['FTAG'])).sum()
    away_wins = ((team_year_matches['AWAY_TEAM'] == team) & (team_year_matches['FTAG'] > team_year_matches['FTHG'])).sum()
    total_wins = home_wins + away_wins

    # Calculate the number of draws
    home_draws = ((team_year_matches['HOME_TEAM'] == team) & (team_year_matches['FTHG'] == team_year_matches['FTAG'])).sum()
    away_draws = ((team_year_matches['AWAY_TEAM'] == team) & (team_year_matches['FTHG'] == team_year_matches['FTAG'])).sum()
    total_draws = home_draws + away_draws

    # Calculate the number of losses, home and away
    home_losses = ((team_year_matches['HOME_TEAM'] == team) & (team_year_matches['FTHG'] < team_year_matches['FTAG'])).sum()
    away_losses = ((team_year_matches['AWAY_TEAM'] == team) & (team_year_matches['FTAG'] < team_year_matches['FTHG'])).sum()
    total_losses = home_losses + away_losses

    # Calculate number of matches played by a specific team in (a) specific year(s)
    total_matches = total_wins + total_draws + total_losses

    # Calculate the average points for each match
    if points:
        av_points = (total_wins * 3 + total_draws) / total_matches

    # Calculate the percentage for each result
    if percentages:
        win_percentage = total_wins / total_matches * 100
        draw_percentage = total_draws / total_matches * 100
        loss_percentage = total_losses / total_matches * 100

    if results and points and percentages:
        if totals:
            return [total_wins, total_draws, total_losses], av_points, win_percentage, draw_percentage, loss_percentage
        else:
            return [home_wins, away_wins, home_draws, away_draws, home_losses, away_losses], av_points, win_percentage, draw_percentage, loss_percentage
        
    elif not results and points and percentages:
        return av_points, win_percentage, draw_percentage, loss_percentage
        
    elif results and not points and percentages:
       if totals:
            return [total_wins, total_draws, total_losses], win_percentage, draw_percentage, loss_percentage
       else:
            return [home_wins, away_wins, home_draws, away_draws, home_losses, away_losses], win_percentage, draw_percentage, loss_percentage
        
    elif  results and points and not percentages:
        if totals:
            return [total_wins, total_draws, total_losses], av_points
        else:
            return [home_wins, away_wins, home_draws, away_draws, home_losses, away_losses], av_points
        
    elif not results and not points and percentages:
        return win_percentage, draw_percentage, loss_percentage

    elif not results and points and not percentages:
        return av_points

    elif results and not points and not percentages:
        if totals:
            return [total_wins, total_draws, total_losses]
        else:
            return [home_wins, away_wins, home_draws, away_draws, home_losses, away_losses]

    else:
        print("You did not select anything for calculating")



def goals(df):
    """
    Analyzes the distribution of home and away goals scored by teams in football matches.
    
    Parameters:
    - df (DataFrame): match data with columns 'FTHG' (home goals) and 'FTAG' (away goals).
    
    Outputs:
    - None (plots a horizontal bar chart showing the mean number of home and away goals)
    """
    # Extract home goals (hg) and away goals (ag) from the DataFrame
    hg = df['FTHG']
    ag = df['FTAG']
    
    # Calculate the mean of home goals and away goals
    hg_mean = hg.mean()
    ag_mean = ag.mean()
    
    # Perform Wilcoxon signed-rank test to compare home goals and away goals
    result, p_value = wilcoxon(hg, ag)
    
    # Print the result of the Wilcoxon test and interpret the significance level
    if p_value < 0.05:
        print("There is a significant difference between the home goals and the away goals.")
        print("P-value:", p_value, "Wilcoxon test statistic:", result)

        # Compare the mean of home goals and away goals
        if hg_mean > ag_mean:
            print("Teams score more goals at home matches.")
        elif hg_mean < ag_mean:
            print("Teams score more goals at away matches.")
    else:
        print("There is no significant difference between home goals and away goals.")
        print("Wilcoxon test statistic:", result, "P-value:", p_value)
        
    # Plot a horizontal bar chart showing the mean number of home and away goals
    name = ['Home Goals Mean', 'Visitant Goals Mean']
    value = [hg_mean, ag_mean]
    
    # Create the horizontal bar chart
    plt.figure(figsize=(6, 2))
    bars = plt.barh(name, value, color=['blue', 'red'])
    
    # Add labels and title
    plt.xlabel('Mean Goals')
    plt.title('Mean Scored Goals by Team')
    plt.xlim(0, max(value) * 1.2)

    # Add value annotations to the bars
    for bar in bars:
        value = bar.get_width()
        plt.text(value, bar.get_y() + bar.get_height()/2, f'{value:.2f}', va='center')

    # Show the bar chart
    plt.show()



def season(season_selected, df):
    season_df = df[df['SEASON'] == season_selected]       
    season_hg = season_df['FTHG']
    season_vg = season_df['FTAG']

    print("Number of matches:", len(season_df))
    
    u.goals(season_df)



def season_os(season_selected, df):
    """
    Perform hypothesis testing to assess the impact of Real Madrid comebacks on its performance in a selected season.

    Parameters:
    - season_selected: The season for which the analysis is performed.
    - df: DataFrame containing the data for all seasons.

    Output:
    - Prints the number of comebacks, total number of matches, z-score, p-value, and the interpretation of the results.
    """
    
    season_df = df[df['Season'] == season_selected]       
    
    c = sum(season_df['comebacks'])
    
    total_obs = int(season_df['Matches'])

    pv_nt = numerical_normality(df['Season'], return_p=True)
    
    if pv_nt > 0.05:
        _, p_value = proportions_ztest(c, total_obs, value=0.05, alternative='two-sided')
    else:
        p_value = binom_test(c, total_obs, 0.2, alternative='two-sided')
    
    print(f"Comebacks: {c}")
    print(f"Total matches: {total_obs}")
    
    print(f"p-value: {p_value}")
    
    # Interpret the results
    if p_value < 0.05:
        print(f"\nReject the null hypothesis. Real Madrid comebacks has a statistically significant impact on its performance during {season_df['Season'].iloc[0]} season.")
    else:
        print(f"\nFail to reject the null hypothesis. Real Madrid comebacks has NOT a statistically significant impact on its performance during {season_df['Season'].iloc[0]} season.")




def season_ts(season_selected, df):
    """
    Perform hypothesis testing to compare the proportions of comebacks and failures in a selected season.

    Parameters:
    - season_selected: The season for which the analysis is performed.
    - df: DataFrame containing the data for all seasons.

    Output:
    - Prints the number of comebacks and failures, total number of matches, z-score, p-value, and the interpretation of the results.
    """
    
    season_df = df[df['Season'] == season_selected]       
    
    c = sum(season_df['comebacks'])
    f = sum(season_df['failures'])
    
    total_obs = c + f
    
    z_score, p_value = proportions_ztest([c, f], [total_obs, total_obs], alternative='two-sided')

    print(f"Comebacks: {c}")
    print(f"Failures: {f}")
    print(f"Total matches: {total_obs}")
    
    print(f"\nz-score: {z_score}")
    print(f"p-value: {p_value}")
    
    # Interpret the results
    if p_value < 0.05:
        print(f"\nReject the null hypothesis. There is a statistically significant difference between the proportion of comebacks and failures during {season_df['Season'].iloc[0]} season..")
        if f > c:
            print(f"It is clearly seen that failures ({f}) are way bigger compared to comebacks ({c}).")
        elif c > f:
            print(f"It is clearly seen that comebacks ({c}) are way bigger compared to failures ({f}).")
    else:
        print(f"\nFail to reject the null hypothesis. There is no statistically significant between the proportion of comebacks and failures during {season_df['Season'].iloc[0]} season..")




def plot_classification(df, season_selected):
    """
    Plot classification data for a selected season.

    Parameters:
    - df: DataFrame containing classification data for all seasons.
    - season_selected: Season to be analyzed.

    Output:
    - Display the classification data for the selected season, sorted by points in descending order,
      with columns for goal difference, and reindexed to start from 1.
    """
    
    # Filter the results for the selected season
    season_data = df[df['Season'] == season_selected].sort_values(by=['Points', 'Goals_Conceded'], ascending=False)
    
    # Eliminate columns not needed for plotting
    season_data = season_data.drop(columns=['Season'])
    
    # Reindex the DataFrame starting from 1
    season_data.reset_index(drop=True, inplace=True)
    
    # Adjust index to start from 1 instead of 0
    season_data.index = season_data.index + 1
    
    # Display the processed data
    display(season_data)




def lrh(x, y):
    """
    Perform linear regression using the Ordinary Least Squares (OLS) method.

    Parameters:
    - x: The independent variable.
    - y: The dependent variable.

    Output:
    - Returns the fitted linear regression model.
    """

    x = x.astype(float)
    y = y.astype(float)
    
    # Create a constant term to fit the intercept in the linear regression
    X = sm.add_constant(x)

    # Fit the linear regression model
    model = sm.OLS(y, X)
    r = model.fit()
    
    return r, X




def plt_lrh(x, y):
    """
    Generate a scatter plot with the regression line for the relationship between two variables.

    Parameters:
    - x: The independent variable.
    - y: The dependent variable.
    - X: The independent variable with added constant term.
    - r: The fitted linear regression model.

    Output:
    - Returns the prediction and displays the scatter plot with the regression line.
    """
    
    r, X = u.lrh(x, y)
    
    y_pred = r.predict(X)

    # Scatter plot with the regression line
    plt.figure(figsize=(10, 6))
    sns.scatterplot(x=x, y=y, color='blue', label='Data', alpha=0.5)
    plt.plot(x, y_pred, color='red', label='Regression Line')
    plt.xlabel('Goals')
    plt.ylabel('Points Earned')
    plt.title('Linear Regression: Goals vs Points Earned')
    plt.legend()
    plt.show()

    return y_pred




def season_lr(df, season_selected, goals):
    """
    Perform linear regression on the selected season's data to determine the relationship 
    between goals (scored or conceded) and points obtained.

    Parameters:
    - df: DataFrame containing the season data.
    - season_selected: The season for which the analysis is performed.
    - goals: A string specifying whether to analyze 'Goals_Conceded' or 'Goals_Scored'.

    Output:
    - Prints the result of the hypothesis test (relationship between goals and points).
    - Calls the plot_classification function to display the classification for the season.
    """
    
    # Filter the DataFrame for the selected season
    season_df = df[df['Season'] == season_selected]

    # Dependent variable: Points
    y = season_df['Points']
    
    # Independent variable: Goals Conceded or Goals Scored
    if goals == 'conceded':
        x = season_df['Goals_Conceded']
    elif goals == 'scored':
        x = season_df['Goals_Scored']
    elif goals == 'difference':
        x = season_df['Goals_Difference']
    else:
        print('Please, select a correct option: conceded, scored or difference')
        return

    # Ensure the data is of type float
    x = x.astype(float)
    y = y.astype(float)
    
    # Create a constant term to fit the intercept in the linear regression
    X = sm.add_constant(x)

    # Fit the linear regression model
    model = sm.OLS(y, X)
    r = model.fit()

    # Compute the p-value
    p_value = r.pvalues[1]

    # Check the hypothesis and print the result
    if p_value < 0.05:
        if goals == 'conceded':
            print("Reject the null hypothesis. There is a linear relationship between the number of goals conceded and the points obtained.")
        elif goals == 'scored':
            print("Reject the null hypothesis. There is a linear relationship between the number of goals scored and the points obtained.")
    else:
        if goals == 'conceded':
            print("Fail to reject the null hypothesis. There is no linear relationship between the number of goals conceded and the points obtained.")
        elif goals == 'scored':
            print("Fail to reject the null hypothesis. There is no linear relationship between the number of goals scored and the points obtained.")

    # Plot the classification for the selected season
    u.plot_classification(df, season_selected)
