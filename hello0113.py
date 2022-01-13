#!/usr/bin/env python
# -*- coding: utf-8 -*-


def returnList(oroginalList):
	finalList=[]
	for data in oroginalList:
		finalList.append(data%3)
	return finalList

test=returnList([2,6,4,1,3,5])