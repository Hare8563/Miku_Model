#coding: UTF-8
import sys
import datetime
import os
import time

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

def getext(filename):
    return os.path.splitext(filename)[-1].lower()

class ChangeHandler(FileSystemEventHandler):
	def on_created(self, event):
		print '"'+ os.path.basename(event.src_path) + '"が作成されました。Addしてからコミットします'
		os.system('git add .')
		os.system('git commit -m "'+os.path.basename(event.src_path)+'を作成"')
	def on_modified(self, event):
		print '"'+ os.path.basename(event.src_path)  + '"が変更されました。'
		os.system('git add .')
		os.system('git commit -m "'+os.path.basename(event.src_path)+'を変更"')
	def on_deleted(self, event):
		print '"'+ os.path.basename(event.src_path)  + '"が削除されました。'
		os.system('git add .')
		os.system('git commit -m "'+os.path.basename(event.src_path)+'を削除"')

argvs = sys.argv
argc = len(argvs)
if(argc < 2):
	print "This Script use 1 Argument. Please input checker argc = "+str(argc)
	quit()

while 1:
	event_handler = ChangeHandler()
	observer = Observer()
	observer.schedule(event_handler, os.path.abspath(argvs[1]), recursive=False)
	observer.start()
	try:
		while True:
			time.sleep(1)
	except KeyboardInterrupt:
		observer.stop()
	observer.join()
