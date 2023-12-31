# Load required libraries
library(reshape2)
library(ggplot2)

# Load your data from the CSV file
data <- read.csv("D:\\N learn\\2nd year\\projects\\R project\\HR_Analytics.csv")

# Check the data types
str(data)

# Remove non-numeric variables
data_numeric <- data[, sapply(data, is.numeric)]

# Compute the correlation matrix
cormat <- round(cor(data_numeric), 2)

# Melt the correlation matrix
melted_cormat <- melt(cormat)

# Create a clearer heatmap using ggplot2
ggplot(data = melted_cormat, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                       midpoint = 0, limits = c(-1, 1), name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, size = 10, hjust = 1)) +
  coord_fixed(ratio = 1) +
  theme(legend.position="right") +
  labs(title = "Correlation Matrix Heatmap")

# Optional: Add correlation coefficients on the heatmap
ggplot(data = melted_cormat, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                       midpoint = 0, limits = c(-1, 1), name = "Correlation") +
  geom_text(aes(label = value), color = "black", size = 2.5) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, size = 10, hjust = 1)) +
  coord_fixed(ratio = 1) +
  theme(legend.position="right") +
  labs(title = "Correlation Matrix Heatmap with Coefficients")
