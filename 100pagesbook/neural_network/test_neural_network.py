# coding=utf-8
#!/usr/bin/env python

# Source Tut: https://towardsdatascience.com/how-to-build-your-own-neural-network-from-scratch-in-python-68998a08e4f6

import numpy as np

class NeuralNetwork:

	def __init__(self, x, y):
		self.input = x
		self.weights1 = np.random.rand(self.input.shape[1], 4) 
		self.weights2 = np.random.rand(4,1)
		self.y = y
		self.output = np.zeros(y.shape)

		def feedForward(self):
			self.layer1 = sigmoid(np.dot(self.input, self.weights1))
			self.output = sigmoid(np.dot(self.layer1, self.weights2))