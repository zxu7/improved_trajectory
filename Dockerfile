FROM ubuntu:12.04
MAINTAINER Mahmudul Hasan <mhasa004@ucr.edu>

RUN apt-get update
RUN apt-get remove -y ffmpeg x264 libx264-dev

RUN apt-get install -y -q build-essential wget checkinstall git cmake libfaac-dev \
  libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev \
  libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx11-dev \
  libxfixes-dev libxvidcore-dev texi2html yasm zlib1g-dev

RUN apt-get install -y libgstreamer0.10-0 libgstreamer0.10-dev \
  gstreamer0.10-tools gstreamer0.10-plugins-base libgstreamer-plugins-base0.10-dev \
  gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad gstreamer0.10-ffmpeg
  
RUN apt-get install -y vlc vlc-dbg vlc-data libvlccore5 libvlc5 libvlccore-dev \
  libvlc-dev tbb-examples libtbb-doc libtbb2 libtbb-dev libxine1-bin libxine1-ffmpeg libxine-dev 

RUN apt-get install libmysqlcppconn-dev

RUN cd /opt && wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20121004-2245-stable.tar.bz2 \
  && tar xjvf x264-snapshot-20121004-2245-stable.tar.bz2

RUN cd /opt/x264-snapshot-20121004-2245-stable \
  && ./configure --enable-static --enable-pic --enable-shared \
  && make \
  && make install

RUN cd /opt && wget http://lear.inrialpes.fr/people/wang/download/ffmpeg-0.11.1.tar.bz2 \
  && tar xjvf ffmpeg-0.11.1.tar.bz2

RUN cd /opt && wget http://lear.inrialpes.fr/people/wang/download/OpenCV-2.4.2.tar.bz2 \
  && tar xjvf OpenCV-2.4.2.tar.bz2
  
RUN cd /opt/ffmpeg-0.11.1 \
  && ./configure --enable-gpl --enable-libfaac --enable-libmp3lame \
    --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora \
    --enable-libvorbis --enable-libx264 --enable-libxvid --enable-nonfree \
    --enable-postproc --enable-version3 --enable-x11grab --enable-pic \
    --enable-shared \
  && make && make install
  
RUN apt-get install -y libgtk2.0-0 libgtk2.0-dev libjpeg62 libjpeg62-dev

RUN cd /opt && wget http://www.linuxtv.org/downloads/v4l-utils/v4l-utils-0.9.1.tar.bz2 \
  && tar xjvf v4l-utils-0.9.1.tar.bz2 && cd v4l-utils-0.9.1 \
  && ./configure \
  && make && make install

RUN mkdir /opt/OpenCV-2.4.2/build
RUN cd /opt/OpenCV-2.4.2/build && cmake -D WITH_TBB=ON -D WITH_XINE=ON .. && make && make install

RUN ldconfig "/usr/local/lib"

RUN cd /opt && wget http://lear.inrialpes.fr/people/wang/download/improved_trajectory_release.tar.gz \
  && tar xzvf improved_trajectory_release.tar.gz

RUN cd /opt/improved_trajectory_release && make \
  && ./release/DenseTrackStab ./test_sequences/person01_boxing_d1_uncomp.avi | gzip > out.features.gz
  
