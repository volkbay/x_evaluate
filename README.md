# Exploring Event Camera-based Odometry for Planetary Robots
<p align="center">
    <img src="https://rpg.ifi.uzh.ch/img/papers/arxiv22_Mahlknecht.png" alt="EKLT-VIO" width="600"/>
</p>

This repository contains code that implements the event-based VIO algorithm described in Mahlknecht et al. RAL'22. The paper can be found [here](http://rpg.ifi.uzh.ch/docs/RAL22_Mahlknecht.pdf), and datasets can be found [here](https://uzh-rpg.github.io/eklt-vio/).
If you use this code in an academic context, please cite the following work:

[Florian Mahlknecht](https://florian.world), [Daniel Gehrig](https://danielgehrig18.github.io/), Jeremy Nash, 
Friedrich M. 
Rockenbauer, Benjamin Morrell, Jeff Delaune, [Davide Scaramuzza](http://rpg.ifi.uzh.ch/people_scaramuzza.html), "Exploring Event Camera-based Odometry for Planetary Robots", IEEE Robotics and Automation Letters (RA-L), 2022
```bibtex
@article{Mahlknecht22RAL,
  title={Exploring Event Camera-based Odometry for Planetary Robots},
  author={Mahlknecht, Florian and Gehrig, Daniel and Nash, Jeremy and Rockenbauer, Friedrich M. and Morrell, Benjamin and Delaune, Jeff and Scaramuzza, Davide},
  journal={IEEE Robotics and Automation Letters (RA-L)},
  year={2022}
}
```

## x_evaluate

Performance evaluation for (range-) visual-inertial odometry xVIO framework.

Provides an extensive toolset to evaluate frontend and backend accuracy (i.e. pose and feature tracking) as well as 
computational efficiency, such as realtime factor, CPU and memory usage.

### Dependencies

The library has been tested only on Ubuntu 20.04 with Ros Noetic. Although no roscore is needed, feature tracking 
evaluation requires Python3 rosbag reader, therefore lifting the requirements to Ros Noetic.

Beyond ROS, the major dependencies are the X library and gflags_catkin (see `dependencies.yaml`). Typical installation
commands might be:

```bash
cd YOUR_ROS_WORKSPACE/
source devel/setup.zsh  # or .bash if you use BASH
cd src
git clone ... x_evaluate
vcs-import < x_evaluate/dependencies.yaml
catkin build x_evaluate  # DO NOT BUILD all packages, as the rpg_ros_driver might fail, but it's not needed
```

For the python package it is recommended to create a virtual environment and install the requirements with pip:

```bash
conda create -n x python=3.8
conda activate x
pip install -r requirements.txt
pip install . # Optionally install the x_evaluate in the python dist-packages
```

### Basic architecture

The library consists of one C++ file which directly calls X library callbacks such as `processIMU()` from the data
read from a rosbag. In this way a runtime-independent evaluation can be performed. Results are then dumped to CSV files 
and analyzed in Python, with the main module `x_evaluate`.

The python evaluation runs additionally dump all the main results to a pickle file, such that different runs can be 
easily compared and reproduced.

### Usage

An evaluation run is performed by `evaluate.py`. A configuration file e.g. `evaluate.yaml` defines which datasets are
processed and based on which base parameter files, e.g. `params_rpg_davis.yaml`. Parameters can be overwritten for a  
single sequence or for all sequences on the respective entry in `evaluate.yaml`. Additionally,  by passing
`--overrides some_param=17 some_other_param=False` out-rules all other settings for the purpose of parameter tuning runs.

A simple example run:

```bash
python test/evaluate.py --configuration test/evaluate.yaml --output_folder /path/to/_out/ \
--dataset_dir /path/to_datasets --frontend XVIO --name "XVIO"
```

And a comparison run:

```bash
python scripts/compare.py --input_folder /path/to --sub_folders _out:_out_2 ----output_folder /path/to/results
```


