# twilio-message

This repo builds a Docker image that uses the `{twilio}` R package to send a daily text message to a target phone number. The image is loaded to an Azure function and runs on a daily timer. 

## Setup

Clone this repo.  

Change `s.csv` to any csv of your liking. I built this for my mom, and included all Bible verses that matched the regex "love|compassion", but you can theoretically send any messages you want. 

In the root directory, add a `.Renviron` file with the following environmental variables:

```
TWILIO_SID          = "<your twilio SID>"
TWILIO_AUTH_TOKEN   = "<your twilio auth token>"
TWILIO_PHONE_NUMBER = "<your twilio phone number>"
TARGET_PHONE_NUMBER = "<the target phone number to receive texts>"

```

I recommend using your phone number as the target phone number for testing purposes. 


## Docker

Build the Docker image:

```
docker build --build-arg WHEN=2021-07-30 -t twilio-message .
```

This results in a Docker image called `twilio-message`

The `WHEN` build argument is used to download R dependencies from CRAN at that particular date, thus ensuring that dependencies are frozen at this moment in time. 

Next, run the image in a container:

```
docker run --rm -v ~/Desktop/twilio_message/results:/home/results twilio-message
```

`--rm` removes the container after it's run, and `~/Desktop/twilio_message/results:/home/results` transfers results from the container path `/home/results` to the local path `~/Desktop/twilio_message/results` after the container is finished running. 

Verify that this works by inspecting the files transfered by the container to your local drive:

```
ls ~/Desktop/twilio_message/results
```

The target phone number should have also received a text message notification.


# Docker resources

https://www.statworx.com/de/blog/running-your-r-script-in-docker/

https://www.youtube.com/watch?v=HelrQnm3v4g

https://code.markedmondson.me/googleCloudRunner/index.html

docker run --rm 