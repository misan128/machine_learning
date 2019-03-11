#!/usr/bin/env python

import csv

def getdata_x_y(file_path):
	X = []
	Y = []

	with open(file_path) as csv_file:
		csv_reader = csv.reader(csv_file, delimiter = ',')
		line_count = 0
		for row in csv_reader:
			if line_count == 0:
				# print '{0}\t{1}\t{2}\t{3}\t{4}'.format(row[0], row[1], row[2], row[3], row[4])
				line_count += 1
			else:
				##media_gasto = (float(row[1]) + float(row[2]) + float(row[3]))
				##X.append(media_gasto)
				X.append(float(row[2]))
				Y.append(float(row[4]))
				# print '{0}\t{1}\t{2}\t{3}\t{4}'.format(row[0], row[1], row[2], row[3], row[4])
				line_count += 1

	return X, Y
