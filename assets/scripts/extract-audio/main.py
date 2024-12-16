#! /usr/bin/env python3

import os
import subprocess
import sys

def extract_and_trim_audio(video_file, language, shift):
    if not os.path.exists(video_file):
        print(f"Error: File '{video_file}' does not exist.")
        return

    if not video_file.endswith(".mkv"):
        print(f"Error: File '{video_file}' is not an MKV file.")
        return

    output_file = os.path.splitext(video_file)[0] + f".{language}.mp3"

    # FFmpeg command to extract and trim audio
    command = [
        "ffmpeg",
        "-i", video_file,          # Input video file
        "-ss", shift,              # Skip the specified number of seconds
        "-vn",                     # Ignore video
        "-q:a", "2",              # Set audio quality for MP3 (2 = high quality)
        "-map", "a:0",            # Select the first audio track
        output_file
    ]

    try:
        subprocess.run(command, check=True)
        print(f"Audio extracted and saved as '{output_file}'.")
    except subprocess.CalledProcessError as e:
        print(f"Error: ffmpeg failed with error code {e.returncode}.")
    except FileNotFoundError:
        print("Error: ffmpeg not found. Please ensure it is installed and available in your PATH.")

def process_folder(folder_path, shift):
    if not os.path.exists(folder_path):
        print(f"Error: Folder '{folder_path}' does not exist.")
        return

    language = input("Enter language for all files in the folder (e.g., 'en', 'fr'): ").strip()
    if not language:
        print("Error: Language not specified.")
        return

    for file_name in os.listdir(folder_path):
        full_path = os.path.join(folder_path, file_name)
        if os.path.isfile(full_path) and file_name.endswith(".mkv"):
            print(f"Processing file: {full_path}")
            extract_and_trim_audio(full_path, language, shift)

if __name__ == "__main__":
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: python script.py <video_file.mkv|folder_path> [shift_in_seconds]")
    else:
        path = sys.argv[1]
        shift = sys.argv[2] if len(sys.argv) == 3 else "0"
        if os.path.isdir(path):
            process_folder(path, shift)
        else:
            language = input(f"Enter language for '{path}' (e.g., 'en', 'fr'): ").strip()
            if language:
                extract_and_trim_audio(path, language, shift)
            else:
                print("Error: Language not specified.")
