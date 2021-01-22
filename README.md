# Magic8BallApp_Zibasec
The repo contains source code for  Magic 8 Ball Application 

![Magic8Ball_ZibaSec](https://user-images.githubusercontent.com/25004712/105557540-1deeaa00-5cd2-11eb-9d69-8b226c9a762f.gif)

# INTRODUCTION

This App was created using R's web framework **Shiny**. The code for querying the backend Endpoint API and that of Data Wrangling and Cleanup was **Python**

#### The R Libraries used were:

- dplyr

- magrittr

- reticulate

- shinypop

- DT

- shinyWidgets

#### The Python modules used were:

- pandas

- numpy

- os

- requests

- glob

- json

- datetime

- time

The R library **reticulate** acted as a wrapper enabling R and Python to defined and used within the code base interchangeably. For deployment,Open Source Shiny-Server was used. Open Source Shiny Server is an free web server for rendering and deploying shiny applications. 

Its Docker equivalent, rather Docker image, **rocker/shiny-verse** was used in deploying this application. Docker was chosen for deployment due to its uniformity and ease of deployment.


#### WORKFLOW

![Screenshot from 2021-01-22 17-20-45](https://user-images.githubusercontent.com/25004712/105559272-53959200-5cd6-11eb-9c3b-21f5743b2553.png)


![Screenshot from 2021-01-22 17-05-39](https://user-images.githubusercontent.com/25004712/105558448-31027980-5cd4-11eb-8fad-cba29adfd1fd.png)

#### USAGE INSTRUCTIONS

##### PREREQUISITES

- Docker

For its installation, kindly refer to the [Official Docker Installation Instructions](https://docs.docker.com/get-docker/).

#### REPO CONTENTS

The Repo contains the following:

- **www** - This folder is the tradition folder for storing css content and pictures. It is used as the default location for adding aesthetics to the appearance of Applications. In the case of this App, it acts as a default location for the Magic 8 Ball picture as shown above.

- **app.R** This is R code, that contains the source code for our Application. It contains the shiny framework alongside the unique instructions for delivering this Application.

- **8BallPythonScript.py** - This is a Python Script that processes, wrangles and cleans data at the backend.

- **Dockerfile** - This contains build and logic information understood by Docker for building Docker Images.

#### DOCKER RUN INSTRUCTIONS

In order to run this application, (At this stage, it is assumed that you have Docker up and running). kindly follow these steps:

- Download this git repo & Save it on your PC

```
 git clone https://github.com/nugowe/Magic8BallApp_Zibasec.git


```
```
 docker run --rm -p 2222:3838 -v /Absolute_Path_to_Downloaded_Git_Folder/Magic8BallApp_Zibasec/:/srv/shiny-server nosaugowe/eightballzibasec

```

