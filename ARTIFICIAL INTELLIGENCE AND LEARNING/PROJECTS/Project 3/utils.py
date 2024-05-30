import time

import pandas as pd
import numpy as np
from scipy import stats

# Visualizing
import matplotlib.pyplot as plt
import plotly.express as px
import seaborn as sns

# Preprocessing
from sklearn.utils import shuffle
from sklearn.preprocessing import (
    MinMaxScaler, 
    StandardScaler, 
    RobustScaler
)

# Figures of merit
from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    confusion_matrix,
    auc, 
    roc_auc_score, 
    roc_curve, 
    confusion_matrix, 
    classification_report, 
    r2_score, 
    mean_absolute_error, 
    mean_squared_error
)

# Cross-validation
from sklearn.model_selection import (
    GridSearchCV,
    cross_val_score,
    cross_validate,
    StratifiedKFold,
    RepeatedKFold,
    KFold
)

from sklearn.multiclass import OneVsRestClassifier




def normalizing(tp, X_train, X_test, y_train, y_test):
    """
    Normalizes the input datasets using the specified scaler type.

    Parameters:
    - tp (str): Type of normalization to apply.
    - X_train (DataFrame): Training feature dataset.
    - X_test (DataFrame): Testing feature dataset.
    - y_train (Series): Training target variable.
    - y_test (Series): Testing target variable.

    Outputs:
    - X_train (DataFrame): Normalized training feature dataset.
    - y_train (Series): Training target variable.
    - X_test (DataFrame): Normalized testing feature dataset.
    - y_test (Series): Testing target variable.
    """

    if tp == "ss":
        # Dataset Normalization using StandardScaler for 'Status'
        scaler = StandardScaler()
    elif tp == "mm":
        # Dataset Normalization using MinMaxScaler for 'Status'
        scaler = MinMaxScaler()
    elif tp == "rs":
        # Dataset Normalization using RobustScaler for 'Status'
        scaler = RobustScaler()

    # Fitting the scaler with the X_train subset and normalizing it
    X_train_norm = scaler.fit_transform(X_train)
    # Normalizing the X_test subset with respect to the values taken from X_train, as the scaler was trained with it
    X_test_norm = scaler.transform(X_test)
    # Shuffle the normalized sets
    X_train_norm, y_train = shuffle(X_train_norm, y_train, random_state=20)
    X_test_norm, y_test = shuffle(X_test_norm, y_test, random_state=20)

    return X_train_norm, y_train, X_test_norm, y_test


def apply_norm(tp, X_train, X_test, y_train, y_test):
    """
    Apply normalization to the features in the training and testing datasets.

    Parameters:
    - tp (str): Type of normalization to apply.
    - X_train (DataFrame): Training feature dataset.
    - X_test (DataFrame): Testing feature dataset.
    - y_train (Series): Training target variable.
    - y_test (Series): Testing target variable.

    Outputs:
    - X_train (DataFrame): Normalized training feature dataset.
    - y_train (Series): Training target variable.
    - X_test (DataFrame): Normalized testing feature dataset.
    - y_test (Series): Testing target variable.
    """

    # Extracting column names for later use
    columns = X_train.columns

    # Normalizing both training and testing datasets
    X_train, y_train, X_test, y_test = normalizing(tp, X_train, X_test, y_train, y_test)

    # Converting the normalized arrays back to DataFrames
    X_train = pd.DataFrame(X_train)
    X_train.columns = columns

    X_test = pd.DataFrame(X_test)
    X_test.columns = columns
    
    return X_train, y_train, X_test, y_test



# Óscar´s function
def get_metrics(confmat):
    '''
    Unravel confusion matrix and calculate performance metrics.

    Parameters:
    - confmat (array-like): Confusion matrix in the form of a 2D array or list.

    Outputs:
    - acc (float): Accuracy.
    - sen (float): Sensitivity (True Positive Rate).
    - esp (float): Specificity.
    - ppv (float): Positive Predictive Value (Precision).
    - fsc (float): F1 Score.
    '''

    # Unravel the confusion matrix
    if confmat.shape != (2,2):
        tn, fp, fn, tp = 0, 0, 0, confmat[0][0] 
    else:
        tn, fp, fn, tp = confmat.ravel()
    
    # Calculate performance metrics
    # Accuracy
    acc = (tp+tn)/(tn + fp + fn + tp)        
    
    # Sensitivity (True Positive Rate)
    if tp == 0 and fn == 0:
        sen = 0
    else:
        sen = tp/(tp+fn)
    
    # Specificity
    if tn == 0 and fp == 0:
        esp = 0
    else:
        esp = tn/(tn+fp)
    
    # Positive Predictive Value (recall)
    if tp == 0 and fp == 0:
        ppv = 0
    else:
        ppv = tp/(tp+fp)
    
    # F1 Score    
    if sen == 0 and ppv == 0:
        fsc = 0
    else:
        fsc = 2*(sen*ppv)/(sen+ppv)
    
    # Output the calculated metrics
    return acc, sen, esp, ppv, fsc


# Óscar´s function
def print_performance_metrics(confmat_train, *confmat_test):
    '''
    Print performance metrics based on confusion matrices.

    Parameters:
    - confmat_train (array-like): Confusion matrix for the training set.
    - *confmat_test (array-like, optional): Confusion matrix for the test set. Multiple test sets can be provided.

    Outputs:
    - None: Metrics are printed to the console.
    '''

    # Check if there is a test confusion matrix provided
    if not confmat_test:
        # If no test confusion matrix, calculate and print metrics for the training set only
        acc, sen, esp, ppv, fsc = get_metrics(confmat_train)
        print('TRAINING SET METRICS')
        print('ACC: %2.2f' % (100 * acc))
        print('SEN: %2.2f' % (100 * sen))
        print('ESP: %2.2f' % (100 * esp))
        print('PPV: %2.2f' % (100 * ppv))
        print('F1: %2.2f' % (100 * fsc))
    else:
        # If test confusion matrix(es) provided, calculate and print metrics for both training and test sets
        acc_train, sen_train, esp_train, ppv_train, fsc_train = get_metrics(confmat_train)
        acc_test, sen_test, esp_test, ppv_test, fsc_test = get_metrics(confmat_test[0])

        print('PERFORMANCE METRICS')
        print('\tTRAIN\tTEST')
        print('ACC:\t%2.2f\t%2.2f' % (100 * acc_train, 100 * acc_test))
        print('SEN:\t%2.2f\t%2.2f' % (100 * sen_train, 100 * sen_test))
        print('ESP:\t%2.2f\t%2.2f' % (100 * esp_train, 100 * esp_test))
        print('PPV:\t%2.2f\t%2.2f' % (100 * ppv_train, 100 * ppv_test))
        print('F1:\t%2.2f\t%2.2f' % (100 * fsc_train, 100 * fsc_test))
        
        
# Óscar´s function
def plot_confusion_matrix(confmat_train, *confmat_test):
    '''
    Plot confusion matrix.
    - A single confusion matrix
    - Comparing two confusion matrices, if provided.

    Parameters:
    - confmat_train (array-like): Confusion matrix for the training set.
    - *confmat_test (array-like, optional): Confusion matrix for the test set. Multiple test sets can be provided.

    Outputs:
    - None: Confusion matrix plot is displayed.
    '''
    
    if not confmat_test:
        fig, ax = plt.subplots(figsize=(3, 3))
        ax.matshow(confmat_train, cmap=plt.cm.Blues, alpha=0.5)
        for i in range(confmat_train.shape[0]):
            for j in range(confmat_train.shape[1]):
                ax.text(x=j, y=i, s=confmat_train[i, j], va='center', ha='center')

        plt.xlabel('predicted label')
        plt.ylabel('true label')

        plt.tight_layout()
        plt.show()
        
    else:
        fig, ax = plt.subplots(1,2,figsize=(6, 6))
        ax[0].matshow(confmat_train, cmap=plt.cm.Blues, alpha=0.5)
        for i in range(confmat_train.shape[0]):
            for j in range(confmat_train.shape[1]):
                ax[0].text(x=j, y=i, s=confmat_train[i, j], va='center', ha='center')

        ax[1].matshow(confmat_test[0], cmap=plt.cm.Blues, alpha=0.5)
        for i in range(confmat_test[0].shape[0]):
            for j in range(confmat_test[0].shape[1]):
                ax[1].text(x=j, y=i, s=confmat_test[0][i, j], va='center', ha='center')
    
        ax[0].set_xlabel('predicted label')
        ax[0].set_ylabel('true label')
        ax[0].set_title('TRAIN')
        
        ax[1].set_xlabel('predicted label')
        ax[1].set_ylabel('true label')
        ax[1].set_title('TEST')
    
        plt.tight_layout()
        plt.show()
        
        
# Óscar´s function
def analyze_train_test_performance(clf, X_train, X_test, y_train, y_test):
    '''
    Analyze Train and Test Performance for a Classifier.

    Parameters:
    - clf: Classifier object (already trained).
    - X_train (DataFrame): Feature dataset for training.
    - X_test (DataFrame): Feature dataset for testing.
    - y_train (Series): Target variable for training.
    - y_test (Series): Target variable for testing.

    Outputs:
    - None: Displays performance metrics, confusion matrices, and ROC curve plot.
    '''
    
    # get predictions
    y_pred_train = clf.predict(X_train)
    y_pred_test  = clf.predict(X_test)
    
    # get confusion matrices
    confmat_train = confusion_matrix(y_train, y_pred_train)
    confmat_test  = confusion_matrix(y_test, y_pred_test)
    
    # Plot confusion matrices and provide metrics
    print_performance_metrics(confmat_train, confmat_test)
    plot_confusion_matrix(confmat_train, confmat_test)

    # Plot ROC curve
    y_prob = clf.predict_proba(X_test)[:,1]
    plot_roc_curve(y_test,y_prob)
    
    
# Óscar´s function
def plot_roc_curve(y,y_prob):
    '''
    Plot ROC-AUC Curve and target probability.

    Parameters:
    - y (array-like): True labels.
    - y_prob (array-like): Predicted probabilities for the positive class.

    Outputs:
    - None: Displays ROC-AUC curve and target probability density plots.
    '''
    
    ejex, ejey, _ = roc_curve(y, y_prob)
    roc_auc = auc(ejex, ejey)

    plt.figure(figsize = (12,4))
    
    # ROC-AUC CURVE
    plt.subplot(1,2,1)
    plt.plot(ejex, ejey, color='darkorange',lw=2, label='AUC = %0.2f' % roc_auc)
    plt.plot([0, 1], [0, 1], color=(0.6, 0.6, 0.6), linestyle='--')
    plt.plot([0, 0, 1],[0, 1, 1],lw=2, linestyle=':',color='black',label='Perfect classifier')
    plt.xlim([-0.05, 1.05])
    plt.ylim([-0.05, 1.05])
    plt.xlabel('FPR (1-ESP)')
    plt.ylabel('SEN')
    plt.legend(loc="lower right")
    
    # PROB DENSITY 
    idx_0 = (y==0)
    idx_1 = (y==1)
    
    plt.subplot(1,2,2)
    plt.hist(y_prob[idx_0],density=1,bins = 20, label='y=0',alpha=0.5)
    plt.hist(y_prob[idx_1],density=1,bins = 20, facecolor='red',label='y=1',alpha=0.5)
    plt.legend()
    plt.xlabel('target probability')
    
    plt.show()
    
    
# Óscar´s function
def hyper_parameters_search(clf, X, y, param_grid, scorer='accuracy', cv=5):
    '''
    Perform hyperparameter search using GridSearchCV.

    Parameters:
    - clf: Classifier object.
    - X (DataFrame): Feature dataset.
    - y (Series): Target variable.
    - param_grid (dict): Dictionary of hyperparameter values for the grid search.
    - scorer (str, optional): Scoring metric for cross-validation. Default is 'accuracy'.
    - cv (int, optional): Number of cross-validation folds. Default is 5.

    Outputs:
    - grid: GridSearchCV object containing the results of the hyperparameter search.
    '''
        
    grid = GridSearchCV(clf, param_grid = param_grid, scoring = scorer, cv = cv)
    grid.fit(X, y)

    print("best mean cross-validation score: {:.3f}".format(grid.best_score_))
    print("best parameters: {}".format(grid.best_params_))
    
    return grid


# Óscar´s function
def plot_cv_scoring(grid, hyper_parameter, scorer='accuracy', plot_errors=False, log=False):
    '''
    Plot cross-validated scores over a hyperparameter grid.

    Parameters:
    - grid: GridSearchCV object containing the results of the hyperparameter search.
    - hyper_parameter (str): Name of the hyperparameter to plot.
    - scorer (str, optional): Scoring metric for cross-validation. Default is 'f1'.
    - plot_errors (bool, optional): If True, plot error bars based on the standard deviation of scores. Default is False.
    - log (bool, optional): If True, plot hyperparameter values on a logarithmic scale. Default is False.

    Outputs:
    - None: Displays the plot.
    '''
    
    scores = np.array(grid.cv_results_['mean_test_score'])
    std_scores = grid.cv_results_['std_test_score']
        
    params = grid.param_grid[hyper_parameter]
    
    if log:
        params = np.log10(params)
    
    if plot_errors:
        #print(len(params))
        #print(len(scores))
        plt.errorbar(params,scores,yerr=std_scores, fmt='o-',ecolor='g')
    else:
        plt.plot(params,scores, 'o-')
    plt.xlabel(hyper_parameter,fontsize=14)
    plt.ylabel(scorer)
    plt.show()
    
    
def crossValidate(model, x, y, scoring=None):
    """Calculates the mean of each given metric for each of the given models through cross-validation.
    
    Arguments:
    model -- model or list of models for cross-validation
    x -- 2D array with the dataset features
    y -- 1D array with the target variable ("status") of the dataset
    scoring -- string or list containing the metrics to be used
    
    Returns:
    result -- list with the means of each metric for each fold of the dataset
    """
    
    # Using StratifiedKFold ensures that each fold in which the dataset is divided
    strat_k_fold = StratifiedKFold(n_splits=10, shuffle=True, random_state=20)
    
    # Use the cross_validate module to calculate metrics
    cv = cross_validate(model, x, y, cv=strat_k_fold, scoring=scoring)
    
    # Save the means of each metric in a dictionary
    result = {}                                        # Create a dictionary
    for score in cv:                                   # Iterate over each metric calculated in cv
        result[score] = round(cv[score].mean(), 3)     # Save the result in a dictionary that is then returned
    
    # Return the result
    return result


def crossValidate2(model, x, y, scoring):
    """Returns a list of model performance scores through cross-validation.
    
    Arguments:
    model -- model or list of models for cross-validation
    x -- 2D array with the dataset features
    y -- 1D array with the target variable ("status") of the dataset
    scoring -- string with the metric to be used
    
    Returns:
    scores -- result of the metric for each model
    """
    
    # Using RepeatedKFold ensures that each fold in which the dataset is divided
    cv = RepeatedKFold(n_splits=10, n_repeats=3, random_state=20)
    
    # Using cross_val_score to assess the suitability of the models
    scores = cross_val_score(
        model,
        x,
        y,
        scoring=scoring,
        cv=cv,
        n_jobs=-1,
        error_score="raise",
    )
    return scores


def evaluate_models(model_dict, phase):
    '''
    Visualize the performance of different models on training, cross-validation, or testing data.

    Parameters:
    - model_dict (dict): Dictionary containing model performance metrics.
    - phase (str): Specifies the phase to evaluate ('training', 'cross_validation', or 'testing').

    Outputs:
    - None: Displays bar charts representing the performance of each model.
    '''

    # Representamos el rendimiento de cada modelo
    plt.figure(figsize=(18, 6))
    a = 1
    colors = ['b', 'r', 'y', 'g', 'k', 'c']

    for name in model_dict:                                                      # Iteramos sobre el nombre de los modelos

        labels = list(model_dict[name][phase].keys())                   # Guardamos los nombres de cada métrica
        values = list(model_dict[name][phase].values())
        

        # Separar los valores
        if phase == 'training':
            training_scores = []
            test_scores = []
            for item in values:
                training_scores.append(item[0])
                test_scores.append(item[1])            # Guardamos los valores de cada métrica
                
        elif phase == 'cross_validation':
            labels = labels[2:]
            test_scores = values[2:]

        plt.subplot(2,3,a)                                                       # Iniciamos la representación
        plt.bar(labels, test_scores, color=colors)                                   # Hacemos un gráfico de barras para cada métrica

        # Anotamos el valor de cada métrica en el gráfico
        for i,j in zip([0, 1, 2, 3, 4], test_scores):
            #print(name,i,j)
            plt.annotate(round(j, 3), xy=(i-0.2,j), fontsize=15)

        # Ponemos los títulos
        plt.title("{} performance:".format(name))
        plt.suptitle(f"Performances of Various Models.{phase}", fontsize=16)

        plt.ylim(0,1)

        a = a + 1

    plt.tight_layout()
    plt.show()
    
    
def top_features(features_dict, n):
    """
    Get the top N features based on their importance scores.

    Parameters:
    - features_dict (dict): Dictionary containing feature names as keys and their importance scores as values.
    - n (int): Number of top features to retrieve.

    Returns:
    List of the top N features.
    """
    
    sorted_keys = sorted(features_dict, key=features_dict.get, reverse=True)
    return sorted_keys[:n]


def plot_importances(importances, feat_names):
    '''
    Plot feature importances.

    Parameters:
    - importances (array-like): Feature importances.
    - feat_names (array-like): Names of the features.

    Outputs:
    - None: Displays a bar chart of feature importances.
    '''
    
    df_importances = pd.Series(importances, index=feat_names)
    
    plt.figure()
    df_importances.plot.bar()
    plt.ylabel("Feature Importance")
    plt.show()
    
    
def train_test_division(X, y, train_index, test_index):
    
    # Adding 1 to the indexes in order to coincide with the patient identifier 
    train_index = [i + 1 for i in train_index]
    test_index = [i + 1 for i in test_index]

    # Division between train and test
    X_train, X_test = X[X['Patient Identifier'].isin(train_index)], X[X['Patient Identifier'] == test_index[0]]
    y_train, y_test = y[y['Patient Identifier'].isin(train_index)], y[y['Patient Identifier'] == test_index[0]]

    # Dropping the Patient Identifier feature in order to avoid overfitting
    X_train, X_test = X_train.drop(['Patient Identifier'], axis=1), X_test.drop(['Patient Identifier'], axis=1)
    y_train, y_test = y_train.drop(['Patient Identifier'], axis=1), y_test.drop(['Patient Identifier'], axis=1)

    # Transforming y_train and y_test in 1D arrays
    y_train, y_test = np.array(y_train['Status']), np.array(y_test['Status'])

    # Normalize the data
    #scaler = StandardScaler()
    #X_train_scaled = scaler.fit_transform(X_train)
    #X_test_scaled = scaler.transform(X_test)
    
    return X_train, X_test, y_train, y_test