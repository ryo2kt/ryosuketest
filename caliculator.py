
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import tkinter as tk

firstNum=0
secondNum=0

def button1Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='1'
	else:
		displayNumber['text']=displayNumber['text']+'1'

def button2Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='2'
	else:
		displayNumber['text']=displayNumber['text']+'2'

def button3Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='3'
	else:
		displayNumber['text']=displayNumber['text']+'3'

def button4Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='4'
	else:
		displayNumber['text']=displayNumber['text']+'4'

def button5Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='5'
	else:
		displayNumber['text']=displayNumber['text']+'5'

def button6Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='6'
	else:
		displayNumber['text']=displayNumber['text']+'6'

def button7Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='7'
	else:
		displayNumber['text']=displayNumber['text']+'7'

def button8Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='8'
	else:
		displayNumber['text']=displayNumber['text']+'8'

def button9Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='9'
	else:
		displayNumber['text']=displayNumber['text']+'9'

def button0Pushed():

	if displayNumber['text']=='0':
		displayNumber['text']='0'
	else:
		displayNumber['text']=displayNumber['text']+'0'

def buttonPlusPushed():

	global firstNum
	global symbol

	firstNum=displayNumber['text']
	displayNumber['text']='0'
	symbol='+'

def buttonMinusPushed():

	global firstNum
	global symbol

	firstNum=displayNumber['text']
	displayNumber['text']='0'
	symbol='-'

def buttonMultiplePushed():

	global firstNum
	global symbol

	firstNum=displayNumber['text']
	displayNumber['text']='0'
	symbol='*'

def buttonDevidePushed():

	global firstNum
	global symbol

	firstNum=displayNumber['text']
	displayNumber['text']='0'
	symbol='/'

def buttonClearPushed():
	displayNumber['text']='0'

def buttonEqualPushed():

	firstNum_Int1=int(firstNum)
	secondNum=displayNumber['text']
	firstNum_Int2=int(secondNum)

	if symbol =='+':
		result = firstNum_Int1+firstNum_Int2
		displayNumber['text']=result

	elif symbol =='-':
		result = firstNum_Int1-firstNum_Int2
		displayNumber['text']=result

	elif symbol =='*':
		result = firstNum_Int1*firstNum_Int2
		displayNumber['text']=result

	elif symbol =='/':
		result = firstNum_Int1/firstNum_Int2
		displayNumber['text']=result

	else:
		displayNumber['text']='error'

root=tk.Tk()
root.geometry('800x600')
root.title('Caliculator')

button1=tk.Button(root,text='1',command=button1Pushed).place(x=150,y=100)
button2=tk.Button(root,text='2',command=button2Pushed).place(x=300,y=100)
button3=tk.Button(root,text='3',command=button3Pushed).place(x=450,y=100)
buttonPlus=tk.Button(root,text='+',command=buttonPlusPushed).place(x=600,y=100)

button4=tk.Button(root,text='4',command=button4Pushed).place(x=150,y=200)
button5=tk.Button(root,text='5',command=button5Pushed).place(x=300,y=200)
button6=tk.Button(root,text='6',command=button6Pushed).place(x=450,y=200)
buttonMinus=tk.Button(root,text='-',command=buttonMinusPushed).place(x=600,y=200)

button7=tk.Button(root,text='7',command=button7Pushed).place(x=150,y=300)
button8=tk.Button(root,text='8',command=button8Pushed).place(x=300,y=300)
button9=tk.Button(root,text='9',command=button9Pushed).place(x=450,y=300)
buttonMultipe=tk.Button(root,text='*',command=buttonMultiplePushed).place(x=600,y=300)

buttonClear=tk.Button(root,text='C',command=buttonClearPushed).place(x=150,y=400)
button0=tk.Button(root,text='0',command=button0Pushed).place(x=300,y=400)
buttonEqual=tk.Button(root,text='=',command=buttonEqualPushed).place(x=450,y=400)
buttonDevide=tk.Button(root,text='/',command=buttonDevidePushed).place(x=600,y=400)

displayNumber=tk.Label(root,text='0',font=("MSゴシック", "40", "bold"),anchor=tk.W)
displayNumber.place(x=300,y=30)

root.mainloop()


