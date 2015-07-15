FROM ubuntu:12.04

RUN apt-get update && apt-get install -q -y \
  wget \
  build-essential

RUN cd /opt wget http://lear.inrialpes.fr/people/wang/download/ffmpeg-0.11.1.tar.bz2
RUN cd /opt wget http://lear.inrialpes.fr/people/wang/download/OpenCV-2.4.2.tar.bz2

RUN cd /opt && tar xf ffmpeg-0.11.1.tar.bz2
RUN cd /opt && tar xf OpenCV-2.4.2.tar.bz2
RUN cd /opt && ls -l

  
