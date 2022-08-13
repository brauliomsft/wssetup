wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
sh cuda_11.6.0_510.39.01_linux.run
export PATH=/usr/local/cuda-11.6/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64                         ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
