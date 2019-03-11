#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

from import_file import *

def train(x, y):
	from sklearn.linear_model import LinearRegression
	model = LinearRegression().fit(x,y)
	return model


X, Y = getdata_x_y("Advertising.csv")

print np.reshape(X, (-1, 1))

print np.reshape(Y, (-1, 1))


model = train(np.reshape(X, (-1, 1)), np.reshape(Y, (-1, 1)))

x_new = np.reshape([23.0], (-1, 1))
y_new = model.predict(x_new)

print y_new