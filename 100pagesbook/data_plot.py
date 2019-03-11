#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

from gradient_descent import *
from import_file import *

def f(w, x, b):
    return  [i * w + b for i in x]


X, Y = getdata_x_y("Advertising.csv")

max_x = max(X)
min_x = min(X)
max_y = max(Y)
min_y = min(Y)

print max_x, min_x, max_y, min_y

t1 = np.arange(min_x, max_x)
t2 = np.arange(min_y, max_y)

w = 0.0
b = 0.0
alpha = 0.001
epochs = 15000

#w, b = train_data(X, Y, w, b, alpha, epochs)
w,b = 0.16116352909, 0.00193861502514

##print w, b

##print X
##print f(w,X,b)

plt.figure(1)
plt.subplot(1,1,1)
plt.plot(X, Y, '.', t1, f(w,t1,b), 'r')

# plt.subplot(212)
# plt.plot(X, f(w, X, b), 'bo')

#plt.plot(X, Y, 'ro')
#plt.axis([0, 6, 0, 20])
plt.show()