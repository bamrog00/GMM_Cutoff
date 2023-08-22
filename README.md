Inferring thresholds between HRD-Low and HRD-High for different cohorts using Gaussian Mixture Model with either two or three components. 
With three components a third type, HRD-Medium is introduced


## Python
### GMM_cutoff
Can be run on all cohorts or single cohorts. Runs the GMM model with either n_components = 2 (n2 case) or 3 (n3 case). Using the model, it predicts the label for numbers between 0 and max(HRD) per cohort to extract the cutoffs between HRD-high and HRD-low (n2 case) or between HRD-low and HRD-Medium, HRD-Medium and HRD-High (n3 case). All results and metrics are saved. Additional function can be run to get the metrics fro each cohort for 2 to 6 components.

### k_means_cutoff
Has the same functions as GMM_cutoff but uses K-means to infer the cutoffs. Meaning, it can be run for singel or all cohorts, 2 or 3 cluster and gets the corresponding cutoffs per cohort with some metrics

## R

### plot_statistics
Plots the metrics from the GMM for number of components between 2 and 6. Plots need to be adjusted some bit (bars overlap)

### compare_kmeans_gmm
Plot correlation plots to show the correlation between the cutoffs from GMM and k-means. In the same way, the average silhouette coefficient is plotted, which shows that the k-means performs better for the n2 and n3 case.


## How to use
To infer cutoffs using GMM and K-means use Gmm_cutoff and  k-means_cutoff notebooks. In case of GMM run the function runGMMCutoff and for K-means the function runKmenasCutoff. The script compare_kmeans_gmm.R can be used to compare the two methods.
