# coding=utf-8
#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt

def sigmoid(x):
	return [1/(1 + np.exp(-1 * i)) for i in x]


x = np.arange(-10, 10)
# print sigmoid(x)

# plt.figure(1)
# plt.plot(x, sigmoid(x))
# plt.show()


def tanH(x):
	return [(np.exp(i) - np.exp(-1 * i))/(np.exp(i) + np.exp(-1 * i)) for i in x]

print tanH(x)

plt.figure(1)
plt.plot(x, tanH(x))
plt.show()