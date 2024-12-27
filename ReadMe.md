
# Project Ball Juggler

You can find the main script as **Main.mxl**. The only parameters you need to change are the the following:
- line 13 : start_chunk = **x**;
- line 14 : end_chunk = **y**;

To keep the script effcient, you can choose the chunks to load. Simply set x to the chunk you want to start at and y to the chunk you want to stop.

For example if you want to see half of the video, you can set x to 0 and y to 4 to load from chunk 0 to 4.

- start_chunk = **0**;
- end_chunk = **4**;

Loading all chunks is not advisable, since this can take a while to run.
---
To be able to run this script you need the following files:
- list_positions(0-4).mat
- Position(5-9).mat
- bucket_template_left_final.png
- bucket_template_right_final.png
- Dataset encoder 1.csv *
- Ballenwerper_sync_380fps_006.npy_output_video.mp4 *
all the chunks
- Ballenwerper_sync_380fps_006.npychunk_(0-9).mat *

\**These files are available in the assignment*

---

You can find all other scripts in the **OtherScripts** foldet. This contains scripts that have been used for testing purposes, but weren't implemented in the final design.

In the **Results** folder, you can find some results that are mentioned in the project document.

