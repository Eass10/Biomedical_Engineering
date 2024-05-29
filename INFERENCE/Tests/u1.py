"""
Utility functions for Statistical Inference on "La Liga" and "Champions League" datasets

Enrique Almazán Sánchez
Víctor Miguel Álvarez Camarero
Matías Nevado

(2024)
"""

import pandas as pd
import numpy as np
from numpy import sqrt

import matplotlib.pyplot as plt
import seaborn as sns

import statsmodels.api as sm
from scipy.stats import t, sem, norm, shapiro, wilcoxon, ttest_1samp, ttest_rel, mannwhitneyu, chi2_contingency, chi2

from bioinfokit.analys import stat




import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats





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
    ax1.set_title('Normalized histogram home wins')

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



