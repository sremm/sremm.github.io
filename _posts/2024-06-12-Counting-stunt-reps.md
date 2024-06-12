---
title: "Counting stunt reps"
date: 2024-06-12
---

# A Little Problem

> I do not know how many stunts I usually do in a stunt session

So I thought, lets find out! Should be easy enough.

# The Goal

> Count how many stunt sequences I do in a given session

# TL;DR

On 2024-06-12 we did a 1,5h session. Just one base and one flyer.

Most of the session we did a variety of stunt sequences. Including a combination of tossing, walk ups, spinning, libs, QPs. Most of the sequences included multiple stunts, and a rare few, where only one skill was performed. To finish off we did Front Handspring Up Drills, focusing on the first part until the throw.

The stats:
- Grand total: 69
    - Stunt sequences: 31
    - FHSU drills: 38


# Towards the solution

## First steps

To achieve this, I could have just looked at all the videos and counted the repetitions this way. But if I can do it from video, then potentially, this can be automated. So I decided to take a different route. The first step ss to create some numeric signal.

To get a signal, I used a pose estimation model available in [pytorch vision models](https://pytorch.org/vision/stable/models.html#object-detection-instance-segmentation-and-person-keypoint-detection).


## Looking at the outputs

With the files processed I had a look. Analyzed a few signals to see if it is clear where there is a stunt in the file. The nose keypoint looked stable enough, so I plotted the Y and X coordinates for the nose keypoint.

The Y graph showed a clear signal for the stunt sequences, where there is clear movement up and down.

![stunt-sequence-y-graph](/docs/assets/img/2024-06-12-Counting-stunt-reps/y-graph-example.png)

For the FHSU drill the X coordinate was actually better. As here the flyer goes to one side and then to the other. First the two lines are separate and then they come together on X graph, as the flyer approaches the base again.

![fhsu-drill-x-and-y-graph](/docs/assets/img/2024-06-12-Counting-stunt-reps/fhsu-x-y-example.png)

## Counting the sequences

I created plots for all the video files and then I just counted the number of stunts manually from the plots.

For this I created a CSV file with the filename and count as columns. And after counting all reps it looks like this. 

| video_name | sequence_count | note           |
| ---------- | -------------- | -------------- |
| IMG_4776   | 5              | stunt sequence |
| IMG_4777   | 2              | stunt sequence |
| IMG_4778   | 3              | stunt sequence |
| IMG_4779   | 2              | stunt sequence |
| IMG_4780   | 1              | stunt sequence |
| IMG_4781   | 3              | stunt sequence |
| IMG_4782   | 3              | stunt sequence |
| IMG_4783   | 1              | stunt sequence |
| IMG_4784   | 4              | stunt sequence |
| IMG_4785   | 1              | stunt sequence |
| IMG_4786   | 4              | stunt sequence |
| IMG_4787   | 2              | stunt sequence |
| IMG_4788   | 1              | stunt sequence |
| IMG_4789   | 4              | stunt sequence |
| IMG_4790   | 2              | stunt sequence |
| IMG_4791   | 7              | FHSU drill     |
| IMG_4792   | 4              | FHSU drill     |
| IMG_4793   | 6              | FHSU drill     |
| IMG_4794   | 6              | FHSU drill     |
| IMG_4795   | 5              | FHSU drill     |
| IMG_4796   | 3              | FHSU drill     |

With the data available, we can just sum up the results.

And here we have it!

- Grand total: 69
    - Stunt sequences: 38
    - FHSU drills: 31

# Other Observations

Along the way I made some extra observations.

### Extra points on graphs

In some files there were these clear lines going across the graph.

![background-people-plot](/docs/assets/img/2024-06-12-Counting-stunt-reps/background-people.png)

So I looked at the image overlayed with keypoints.

![background-people-image](/docs/assets/img/2024-06-12-Counting-stunt-reps/background-people-2.png)

Turns out tracked the people in the background walking by. 

As the plotted keypoints were for all persons with score over 0.5, which is a fairly low value. We sometimes got traces of people in the background, clearly visible as the walked through the video frame. Even if the people were quite small.

### Failed tosses

As we usually did longer sequences, then a failed toss becomes clearly different on the Y plot. Marked with red in the below image.

![failed-toss](/docs/assets/img/2024-06-12-Counting-stunt-reps/failed_toss.png)

### Different start distance in FHSU drill

In the FHSU Drill X-graph we can see that there are some reps, where the flyer was standing closer than usual. 

On the image I marked two distances in green, and the red marking an approximate difference between the two.

![fhsu-start-distance](/docs/assets/img/2024-06-12-Counting-stunt-reps/fhsu-start-distance.png)


# Thats a wrap

Hope you found something useful. 

If you have any idea how many stunts you do in a session, let me know. As of now I have no reference.