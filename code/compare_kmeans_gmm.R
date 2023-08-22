library(ggplot2)
library(ggpubr)


## Load data
kmeans_results = read.csv('../data/kmeans_cutoffs_pancancer.csv', sep = ',', row.names = 1)
gmm_results = read.csv('../data/gmm_cutoffs_pancancer_v3.csv', sep = ',', row.names = 1)

merged_df <- merge(kmeans_results, gmm_results, by = "Project.ID")

## Correlation plot comparing cutoffs in the n2 case
corr_plot_n2 = ggplot(merged_df, aes(x = n2_cutoff.x, y = n2_cutoff.y )) +
  geom_point(aes(color = Project.ID)) +
  theme_bw()+
  labs(title = 'K-means and GMM n2 cutoffs', x  = 'K-means cutoff', y = 'GMM cutoff') + 
  geom_smooth(method = lm, formula = y ~ x, se = FALSE) +
  stat_cor(method = "pearson", label.x = 0, label.y = 30)



## Correlation plot comparing the cutoff in the n3 case between low and medium (lm) and medium and high (mh)
corr_plot_n3_lm = ggplot(merged_df, aes(x = n3_cutoff_lm.x, y = n3_cutoff_lm.y )) +
  geom_point(aes(color = Project.ID)) +
  theme_bw()+
  labs(title = 'K-means and GMM n3 cutoffs between Low and Medium', x  = 'K-means cutoff', y = 'GMM cutoff') + 
  geom_smooth(method = lm, formula = y ~ x, se = FALSE) +
  stat_cor(method = "pearson", label.x = 0, label.y = 30)

corr_plot_n3_mh = ggplot(merged_df, aes(x = n3_cutoff_mh.x, y = n3_cutoff_mh.y )) +
  geom_point(aes(color = Project.ID)) +
  theme_bw()+
  labs(title = 'K-means and GMM n3 cutoffs between Medium and High', x  = 'K-means cutoff', y = 'GMM cutoff') + 
  geom_smooth(method = lm, formula = y ~ x, se = FALSE) +
  stat_cor(method = "pearson", label.x = 0, label.y = 30)


print(corr_plot_n2)
print(corr_plot_n3_lm)
print(corr_plot_n3_mh)
ggsave('../data/figures/kmeans_gmm_cutoff_correlation_n2.png',corr_plot_n2,width = 8.63, height = 5.71)
ggsave('../data/figures/kmeans_gmm_cutoff_correlation_lm_n3.png',corr_plot_n3_lm,width = 8.63, height = 5.71)
ggsave('../data/figures/kmeans_gmm_cutoff_correlation_mh_n3.png',corr_plot_n3_mh,width = 8.63, height = 5.71)


## Correlation plot between the average silhouette coefficient in the n2 case
corr_plot_sil_n2 = ggplot(merged_df, aes(x = n2_silhouette_coef.x, y = n2_silhouette_coef.y )) +
  geom_point(aes(color = Project.ID)) +
  theme_bw()+
  labs(title = 'K-means and GMM, Average silhouette coef. comparison, n2', x  = 'K-means average silhouette coef.', y = 'GMM average silhouette coef.') + 
  geom_smooth(method = lm, formula = y ~ x, se = FALSE) +
  stat_cor(method = "pearson", label.x = 0.5, label.y = 0.7) +
  geom_abline(intercept = 0, slope = 1, linetype = 'dotted', color = 'red')


## Correlation plot between the average silhouette coefficient in the n3 case
corr_plot_sil_n3 = ggplot(merged_df, aes(x = n3_silhouette_coef.x, y = n3_silhouette_coef.y )) +
  geom_point(aes(color = Project.ID)) +
  theme_bw()+
  labs(title = 'K-means and GMM, Average silhouette coef. comparison, n3', x  = 'K-means average silhouette coef.', y = 'GMM average silhouette coef.') + 
  geom_smooth(method = lm, formula = y ~ x, se = FALSE) +
  stat_cor(method = "pearson", label.x = 0.5, label.y = 0.7) +
  geom_abline(intercept = 0, slope = 1, linetype = 'dotted', color = 'red')


print(corr_plot_sil_n2)
print(corr_plot_sil_n3)
ggsave('../data/figures/kmeans_gmm_silhouette_coef_correlation_n2.png',corr_plot_sil_n2,width = 8.63, height = 5.71)
ggsave('../data/figures/kmeans_gmm_silhouette_coef_correlation_n3.png',corr_plot_sil_n3,width = 8.63, height = 5.71)



k_hrd = read.csv('../data/kmeans_cutoffs_pancancer.csv', sep = ',', row.names = 1)
k_loh = read.csv('../data/LOH_kmeans_cutoff_pancancer.csv', sep = ',', row.names = 1)
k_lst = read.csv('../data/LST_kmeans_cutoff_pancancer.csv', sep = ',', row.names = 1)
k_tai = read.csv('../data/TAI_kmeans_cutoff_pancancer.csv', sep = ',', row.names = 1)

k_hrd <- k_hrd[k_hrd$Project.ID != 'TARGET-CCSK', ]
k_hrd[,'cutoff_sum'] = k_loh[,'n2_cutoff'] + k_lst[,'n2_cutoff'] + k_tai[,'n2_cutoff']


k_hrd$error <- k_hrd$cutoff_sum - k_hrd$n2_cutoff

# Step 2: Square the errors
k_hrd$squared_error <- k_hrd$error^2

# Step 3: Calculate mean squared error
mean_squared_error <- mean(k_hrd$squared_error)

# Step 4: Calculate RMSE
rmse <- sqrt(mean_squared_error)



corr_sum_cutoff_k_means = ggplot(k_hrd, aes(x = n2_cutoff, y = cutoff_sum )) +
  geom_point(aes(color = Project.ID)) +
  theme_bw()+
  labs(title = 'K-means, HRDsum and TAI+LST+LOH cutoff', x  = 'K-means cutoff', y = 'Sum cutoff') + 
  geom_smooth(method = lm, formula = y ~ x, se = FALSE) +
  stat_cor(method = "pearson", label.x = 0, label.y = 30)+
  geom_abline(intercept = 0, slope = 1, linetype = 'dotted', color = 'red')+
  annotate("text", x = 0, y = max(k_hrd$cutoff_sum), 
           label = paste0("RMSE relative to the identity line: ", round(rmse, 2)), 
           hjust = 0, vjust = 1)
print(corr_sum_cutoff_k_means)
ggsave('../data/figures/k_means_correlation_hrdcutoff_sumcutoff.png',corr_sum_cutoff_k_means,width = 8.63, height = 5.71)




##### Table for thesis

kmeans_new = kmeans_results[,c('Project.ID', 'n_cases', 'n2_cutoff', 'n2_n_low', 'n2_n_high')]

new_names = c('CancerType', 'NumCases', 'Cutoff', 'NumHRDlow', 'NumHRDhigh')
colnames(kmeans_new) <- new_names
write.csv(kmeans_new,'../data/table_kmeans_thesis.csv', row.names = FALSE)
