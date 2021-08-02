# README

This directory helps troubleshoot local image builds. It moves data written by the R session when a container is created from the container to this directory:

```
docker run --rm -v ~/Desktop/twilio_message/results:/home/results twilio-message
```

Specificlly, it checks that `s.csv` was read (by writing to this directory), and it writes packages loaded into the R session by sinking attached packages in the `SessionInfo()`.

Delete `s.csv` and `session_info.txt`, and run the `twilio-message` image in a container to test. 