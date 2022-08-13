wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
sudo apt-get --purge remove "*cuda*" "*cublas*" "*cufft*" "*cufile*" "*curand*"  "*cusolver*" "*cusparse*" "*gds-tools*" "*npp*" "*nvjpeg*" "nsight*" 
sudo apt-get --purge remove "*nvidia*"
sudo apt-get autoremove
sudo reboot
sudo sh cuda_11.6.0_510.39.01_linux.run
export PATH=/usr/local/cuda-11.6/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64                         ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
