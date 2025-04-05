import json
import matplotlib.pyplot as plt
import numpy as np
import os
from scipy.signal import argrelextrema

input_files = [f for f in os.listdir('input_files') if f.endswith('.json')]

def main():
    fall_extrema = []
    non_fall_extrema = []


    for input_file in input_files:
        with open('input_files/' + input_file, 'r') as file:
            data = json.load(file)

        time = np.array([entry['timestamp'] for entry in data])
        x = np.array([entry['x'] for entry in data])
        y = np.array([entry['y'] for entry in data])
        z = np.array([entry['z'] for entry in data])

        norm = np.sqrt(x**2 + y**2 + z**2)
        max = 0
        max_i = 0
        for i in range(len(norm)):
            if norm[i] > max:
                max = norm[i]
                max_i = i
        
        normalized_time = time[max_i]
        # Normalize time to start from 0
        time = time - normalized_time

        # Filter duplicate timestamps
        valid_indices = np.where(np.diff(time, prepend=time[0] - 1) > 1e-6)[0]
        time = time[valid_indices]
        norm = norm[valid_indices]
        time, norm = time[5:], norm[5:]  # Skip first 5 samples

        da = np.gradient(norm, time)

        # Plot individual file
        fig, axs = plt.subplots(2, 1, figsize=(10, 10), sharex=True)
        axs[0].plot(time, norm, color='k')
        axs[0].set_ylim(0, 150)
        axs[0].set_xlim(-5000, 5000)
        axs[0].set_title('Overall Acceleration vs Time')
        axs[0].set_ylabel('Overall Acceleration')
        axs[0].set_xlabel('Time (ms)')
        axs[0].grid(True)

        axs[1].plot(time, da, color='m')
        axs[1].set_ylim(-7, 7)
        axs[1].set_xlim(-5000, 5000)
        axs[1].set_title('Derivative of Overall Acceleration vs Time')
        axs[1].set_ylabel('dA/dt (Jerk)')
        axs[1].set_xlabel('Time (ms)')
        axs[1].grid(True)

        plt.tight_layout()
        plt.savefig(f'output_files/{input_file[:-5]}.png')
        plt.close()

        # Detect extrema in da
        max_idx = argrelextrema(norm, np.greater, order=1)[0]
        min_idx = argrelextrema(norm, np.less, order=1)[0]
        extrema_idx = np.sort(np.concatenate((max_idx, min_idx)))
        extrema_points = list(zip(time[extrema_idx], norm[extrema_idx]))

        if '_fall' in input_file.lower():
            fall_extrema.extend(extrema_points)
        else:
            non_fall_extrema.extend(extrema_points)

    # Combined plot
    plt.figure(figsize=(10, 6))
    if fall_extrema:
        fall_times, fall_values = zip(*fall_extrema)
        plt.scatter(fall_times, fall_values, color='red', label='Falls', alpha=0.6)
    if non_fall_extrema:
        nonfall_times, nonfall_values = zip(*non_fall_extrema)
        plt.scatter(nonfall_times, nonfall_values, color='blue', label='Non-Falls', alpha=0.6)

    plt.title('Acceleration Extrema from All Files')
    plt.xlabel('Time (ms)')
    plt.ylabel('Acceleration')
    plt.xlim(-5000, 5000)
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig('output_files/all_extrema_summary.png')
    plt.show()

    
    

    

if __name__ == '__main__':
    main()
