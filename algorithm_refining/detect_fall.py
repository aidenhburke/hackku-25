import json
import numpy as np
import os

def detect_fall(file_path):
    # change file path to however data is being accessed by frontend
    with open('input_files/' + file_path, 'r') as file:
         data = json.load(file)
    
    time = np.array([entry['timestamp'] for entry in data])
    x = np.array([entry['x'] for entry in data])
    y = np.array([entry['y'] for entry in data])
    z = np.array([entry['z'] for entry in data])

    norm = np.sqrt(x**2 + y**2 + z**2)
    max_accel = np.max(norm)
    return max_accel >= 37.5

'''
input_files = [f for f in os.listdir('input_files') if f.endswith('.json')]
correct, incorrect = 0, 0
for input_file in input_files:
    if detect_fall(input_file) and '_fall' in input_file or (not detect_fall(input_file) and '_fall' not in input_file):
        correct += 1
    else:
        incorrect += 1

print(f"Correct: {correct}, Incorrect: {incorrect}")
'''
