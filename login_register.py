#!/usr/bin/env python
# -*- coding: utf-8 -*-

import tkinter as tk

#login function
#login UI

root=tk.Tk()
root.geometry('600x600')
root.title('Login_register')

buttonLogin=tk.Button(root,text='login')
buttonLogin.place(x=250,y=350)

lblEntryUserID=tk.Label(root,text='userID')
lblEntryUserID.place(x=100,y=150)

txtboxEntryUserID=tk.Entry(root,width=25)
txtboxEntryUserID.place(x=200,y=150)

lblEntryPass=tk.Label(root,text='password')
lblEntryPass.place(x=100,y=250)

txtboxEntryPass=tk.Entry(root,width=25)
txtboxEntryPass.place(x=200,y=250)

#labelDisplayError

#labelDisplayInfo
#labelDisplayUserName
#labelDisplayUserAge
#labelDisplayUserHeight

#displayNumber=tk.Label(root,text='0',font=("MSゴシック", "40", "bold"),anchor=tk.W)
#displayNumber.place(x=300,y=30)

root.mainloop()

#CSV 

