# coding=utf-8
#!/usr/bin/env python

import csv
import math
import numpy as np
import matplotlib.pyplot as plt

from gradient_descent import *
from import_file import *

def gaus_fn(X, u, sd):
	return [ 1/(sd * math.sqrt(2 * math.pi)) * math.exp( -1 * (math.pow((i - u), 2)) /( 2 * math.pow(sd, 2))) for i in X]

X = []
Y = []

X, Y = getdata_x_y("Advertising.csv")

# media y desviación estandar inicial para tipificacion
u = np.mean(X)
sd = math.sqrt(sum([math.pow(math.fabs( i - u ), 2) for i in X])/len(X))


tip_x = [(i - u)/sd for i in X]

ran = np.arange(min(tip_x) - 1, max(tip_x) + 1, 0.1)
print len(ran)

# count, bins, ig = plt.hist(tip_x, 20, normed = True)

# media y desviacion estandar para distribución
u = np.mean(tip_x)
sd = math.sqrt(sum([math.pow(math.fabs( i - u ), 2) for i in tip_x])/len(tip_x))
print 'sd: {0}'.format(sd)
#print tip_x

#gX = gaus_fn(tip_x, u, sd)

#plt.figure("Gaussian Normal Dist")
#plt.suptitle("Gaussian Normal Dist")
plt.plot(ran, gaus_fn(ran, u, sd))

plt.show()



# mu, sigma = 0.5, 0.1
# s = np.random.normal(mu, sigma, 1000)

# print len(s)

# # Create the bins and histogram
# count, bins, ignored = plt.hist(s, 20, normed=True)

# # Plot the distribution curve
# plt.plot(bins, 1/(sigma * np.sqrt(2 * np.pi)) *
#     np.exp( - (bins - mu)**2 / (2 * sigma**2) ),       linewidth=3, color='y')
# plt.show()




#plot_input_output(X, Y)

## test_gradient_descent(X, Y, epochs = 15000, logs_period = 500, num_train_graphs = 8, test_values = 23.0)


