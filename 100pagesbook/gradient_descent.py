#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

def predict(w, x, b):
    return  [i * w + b for i in x]

def update_w_and_b(X, Y, w, b, alpha):
	dl_dw = 0.0
	dl_db = 0.0
	N = len(X)

	for i in range(N):
		dl_dw += -2 * X[i] * (Y[i] - ((w * X[i]) + b))
		dl_db += -2 * (Y[i] - ((w * X[i]) + b))

	w = w - ((1/float(N)) * dl_dw * alpha)
	b = b - ((1/float(N)) * dl_db * alpha)

	return w, b


def train_data(spendings, sales, w, b, alpha, epochs, err_log = True, err_period = 400, show_graph = True, num_graphs = 6):
	plot_count = 0

	if show_graph:
		max_x = max(spendings)
		min_x = min(spendings)

		t1 = np.arange(min_x, max_x)

		num_graphs_t = num_graphs
		grap_period = epochs/(num_graphs - 1) # -2 to include result
		graph_rows, graph_cols, is_prime = find_factors(num_graphs_t)

		while is_prime:
			num_graphs_t += 1
			graph_rows, graph_cols, is_prime = find_factors(num_graphs_t)

		plt.figure(1)

	for e in range(epochs):
		w, b = update_w_and_b(spendings, sales, w, b, alpha)
		print 'w: {0}\tb: {1}'.format(w, b)

		if err_log and (e % err_period == 0 or e == epochs - 1):
			print("epoch:", e, "loss: ", avg_loss(spendings, sales, w, b))

		if show_graph:
			if (e % grap_period == 0 and plot_count < num_graphs - 1) or e == epochs - 1:
				plot_count += 1
				plt.subplot(graph_rows, graph_cols, plot_count)
				plt.plot(spendings, sales, '.', t1, predict(w,t1,b), 'r')
				plt.title('Graph # {0} - iter: {1}'.format(plot_count, e + 1))
				#plt.grid(True)

	if show_graph:
		plt.show()

	return w, b


def avg_loss(spendings, sales, w, b):
	N = len(spendings)
	total_error = 0.0
	for i in range(N):
		total_error += (sales[i] - ((w * spendings[i]) + b)) ** 2

	return total_error / float(N)


def find_factors(num):
	factors = []
	is_prime = True
	num_t = num

	nrow, ncol = 1, 1

	if(num_t > 1):
		while num_t > 1:
			for i in range(2, num + 1):
				if num_t % i == 0:

					num_t = num_t/i
					factors.append(i)
					break
		
		if factors[len(factors) - 1] != num:
			is_prime = False	

		ncol = max(np.prod(factors[0:-1]), factors[-1])
		nrow = min(np.prod(factors[0:-1]), factors[-1])

	#print nrow, ncol, is_prime
	return nrow, ncol, is_prime


def test_gradient_descent(X, Y, test_values = False, show_test_log = True, show_test_plot = True, w = 0.0, b = 0.0, alpha = 0.001, epochs = 1000, show_log = True, logs_period = 100, show_train_graphs = True, num_train_graphs = 10):
	w, b = train_data(X, Y, w, b, alpha, epochs, show_log, logs_period, show_train_graphs, num_train_graphs)

	if show_test_plot:
		max_x = max(X)
		min_x = min(X)

		t1 = np.arange(min_x, max_x)

		plt.figure(2)
		plt.subplot(1,1,1)
		plt.plot(X, Y, 'b.', t1, predict(w,t1,b), 'c')

	type_test_values = type(test_values)

	if type_test_values == list or type_test_values == int or type_test_values == float:
		if(type_test_values == int or type_test_values == float):
			test_values = [test_values]

		
		predict_values = predict(w, test_values, b)

		for i, value in enumerate(test_values):

			if show_test_plot:
				plt.plot(test_values[i], predict_values[i], 'ro')
				plt.text(test_values[i] + 3, predict_values[i], '{0}, {1}'.format(test_values[i], predict_values[i]))


			if show_test_log:
				print 'Input: {0}\tPrediction: {1}'.format(value, predict_values[i])

				
	if show_test_plot:
		plt.grid(True)
		plt.show()

def plot_input_output(X, Y):
	plt.figure("Input - Output Graph")
	plt.suptitle("Input - Output Graph")

	plt.subplot(3,1,1)
	plt.plot(range(len(X)), X, 'b')
	plt.title("Inputs")

	plt.subplot(3,1,2)
	plt.plot(range(len(Y)), Y, 'r')
	plt.title("Outputs")

	plt.subplot(3,1,3)
	plt.plot(range(len(Y)), Y, 'r', range(len(X)), X, 'b')
	plt.title("Inputs | Outputs")

	plt.show()