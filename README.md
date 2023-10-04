# interactive_art

## How to use
- Clone the repository to your local machine. Alternatively, download the zip file of the project and extract the files to a folder.
- Change to the hand detection directory. Open a terminal and type:
  ```
  pip install -r requirements.txt
  ```
  This will install the libraries required to run the python hand detector

- Download the processing ide from [processing.org](https://processing.org/download).
- You should get a zip file. Unzip the file to a folder.

- Navigate to the project root folder. Here you will fine 3 ".pde" files. Right click on any of them and click on "open with".
  Search for the processing ide and use it to open the file.

- When opened, you should see 3 opened taps, whose names correspond to the file names in the project root directory.
- Navigate to the hand_detect.py file and run it using:
  ```
  py hand_detect.py
  ```
  This will turn on the server that sends the hand location to the processing app.
- Go back to the processing app and click the play button. Incase of any error on the processing app. Just close it and rerun.
- You should see a window with a video feed playing and a black canvas. Start moving your hand and you should see a corresponding fluid simulation with alot of colors.
