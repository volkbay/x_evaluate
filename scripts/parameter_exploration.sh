#!/usr/bin/env bash

BASE_DIR=$(pwd -P)

# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPT_PATH="$( cd -- "$(dirname "$SCRIPT_PATH/../test/evaluate.py")" >/dev/null 2>&1 ; pwd -P )"

COMPARISONS_ONLY=0
EXPLORE_XVIO_PATCH_SIZE=0
EXPLORE_XVIO_IMU_OFFSET=0
EXPLORE_XVIO_MSCKF_BASELINE=0
EXPLORE_XVIO_RHO_0=0
EXPLORE_XVIO_FAST_DETECTION_DELTA=0
EXPLORE_XVIO_NON_MAX_SUPP=0
EXPLORE_XVIO_N_FEAT_MIN=0
EXPLORE_XVIO_OUTLIER_METHOD=0
EXPLORE_XVIO_TILING=0
EXPLORE_XVIO_N_POSES_MAX=0
EXPLORE_XVIO_N_SLAM_FEATURES_MAX=0
EXPLORE_XVIO_SIGMA_IMG=0
EXPLORE_XVIO_IMU_NOISE=0
EXPLORE_EKLT_PATCH_SIZE=0
EXPLORE_EKLT_PATCH_SIZE=0
EXPLORE_EKLT_IMU_OFFSET=0
EXPLORE_EKLT_OUTLIER_REMOVAL=0
EXPLORE_EKLT_TRACKING_QUALITY=0
EXPLORE_EKLT_PRE_MEETING_TRIALS_1=0
EXPLORE_EKLT_PRE_MEETING_TRIALS_2=0
EXPLORE_EKLT_PRE_MEETING_TRIALS_3=0
EXPLORE_EKLT_PRE_MEETING_TRIALS_4=0
EXPLORE_EKLT_UPDATE_STRATEGY_N_MSEC=1
EXPLORE_EKLT_UPDATE_STRATEGY_N_EVENTS=0
EXPLORE_EKLT_INTERPOLATION_TIMESTAMP=0
EXPLORE_EKLT_FEATURE_INTERPOLATION=0
EXPLORE_EKLT_FEATURE_INTERPOLATION_RELATIVE_LIMIT=0
EXPLORE_EKLT_FEATURE_INTERPOLATION_ABSOLUTE_LIMIT=0
EXPLORE_EKLT_LINLOG_SCALE=0




DATE=$2

if [ -z "$2" ]
then
  DATE=$(date '+%Y-%m-%d')
fi

echo "Using $DATE as date"


echo "We are in '$BASE_DIR'"
echo "Assuming location of evaluation script to be '$SCRIPT_PATH'"
echo "Today is $DATE"

echo "Taking first argument as results folder: '$1'"

cd "$SCRIPT_PATH" || exit

trap 'cd "$BASE_DIR"' EXIT

if [ $EXPLORE_XVIO_PATCH_SIZE -gt 0 ]
then
  echo
  echo "Performing frame based XVIO patch size exploration"
  echo

  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/001-patch-size-3 --frontend \
     XVIO --name "XVIO p=3" --overrides block_half_length=3 margin=3

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/002-patch-size-5 --frontend \
     XVIO --name "XVIO p=5" --overrides block_half_length=5 margin=5

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/003-patch-size-6 --frontend \
     XVIO --name "XVIO p=6" --overrides block_half_length=6 margin=6

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/004-patch-size-8 --frontend \
     XVIO --name "XVIO p=8" --overrides block_half_length=8 margin=8

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/005-patch-size-10 --frontend \
     XVIO --name "XVIO p=10" --overrides block_half_length=10 margin=10

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/006-patch-size-12 --frontend \
     XVIO --name "XVIO p=12" --overrides block_half_length=12 margin=12

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/007-patch-size-15 --frontend \
     XVIO --name "XVIO p=15" --overrides block_half_length=15 margin=15

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/008-patch-size-16 --frontend \
     XVIO --name "XVIO p=16" --overrides block_half_length=16 margin=16

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/009-patch-size-18 --frontend \
     XVIO --name "XVIO p=18" --overrides block_half_length=18 margin=18

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/010-patch-size-20 --frontend \
     XVIO --name "XVIO p=20" --overrides block_half_length=20 margin=20

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/011-patch-size-22 --frontend \
     XVIO --name "XVIO p=22" --overrides block_half_length=22 margin=22

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-patch-size/012-patch-size-25 --frontend \
     XVIO --name "XVIO p=25" --overrides block_half_length=25 margin=25

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-patch-size/ --output_folder $1/$DATE-xvio-patch-size/results

fi


if [ $EXPLORE_XVIO_IMU_OFFSET -gt 0 ]
then
  echo
  echo "Performing frame based XVIO IMU time offset calibration"
  echo

  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/001-offset0.0027626 --frontend \
     XVIO --name "XVIO IMU offset 0.0027626" --overrides cam1_time_offset=0.0027626

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/001-offset-0.0027626 --frontend \
     XVIO --name "XVIO IMU offset -0.0027626" --overrides cam1_time_offset=-0.0027626

#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/001-offset-0.01 --frontend \
#     XVIO --name "XVIO IMU offset -0.01" --overrides cam1_time_offset=-0.01
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/002-offset-0.009 --frontend \
#     XVIO --name "XVIO IMU offset -0.009" --overrides cam1_time_offset=-0.009
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/003-offset-0.008 --frontend \
#     XVIO --name "XVIO IMU offset -0.008" --overrides cam1_time_offset=-0.008
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/004-offset-0.007 --frontend \
#     XVIO --name "XVIO IMU offset -0.007" --overrides cam1_time_offset=-0.007
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/005-offset-0.006 --frontend \
#     XVIO --name "XVIO IMU offset -0.006" --overrides cam1_time_offset=-0.006
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/006-offset-0.005 --frontend \
#     XVIO --name "XVIO IMU offset -0.005" --overrides cam1_time_offset=-0.005
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/007-offset-0.004 --frontend \
#     XVIO --name "XVIO IMU offset -0.004" --overrides cam1_time_offset=-0.004
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/008-offset-0.003 --frontend \
#     XVIO --name "XVIO IMU offset -0.003" --overrides cam1_time_offset=-0.003
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/009-offset-0.002 --frontend \
#     XVIO --name "XVIO IMU offset -0.002" --overrides cam1_time_offset=-0.002
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/010-offset-0.001 --frontend \
#     XVIO --name "XVIO IMU offset -0.001" --overrides cam1_time_offset=-0.001
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/011-offset0.0 --frontend \
#     XVIO --name "XVIO IMU offset +0.0" --overrides cam1_time_offset=0.0
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/012-offset0.001 --frontend \
#     XVIO --name "XVIO IMU offset +0.001" --overrides cam1_time_offset=0.001
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/013-offset0.002 --frontend \
#     XVIO --name "XVIO IMU offset +0.002" --overrides cam1_time_offset=0.002
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/014-offset0.003 --frontend \
#     XVIO --name "XVIO IMU offset +0.003" --overrides cam1_time_offset=0.003
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/015-offset0.004 --frontend \
#     XVIO --name "XVIO IMU offset +0.004" --overrides cam1_time_offset=0.004
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/016-offset0.005 --frontend \
#     XVIO --name "XVIO IMU offset +0.005" --overrides cam1_time_offset=0.005
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/017-offset0.006 --frontend \
#     XVIO --name "XVIO IMU offset +0.006" --overrides cam1_time_offset=0.006
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/018-offset0.007 --frontend \
#     XVIO --name "XVIO IMU offset +0.007" --overrides cam1_time_offset=0.007
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/019-offset0.008 --frontend \
#     XVIO --name "XVIO IMU offset +0.008" --overrides cam1_time_offset=0.008
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/020-offset0.009 --frontend \
#     XVIO --name "XVIO IMU offset +0.009" --overrides cam1_time_offset=0.009
#
#    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-offset/021-offset0.01 --frontend \
#     XVIO --name "XVIO IMU offset +0.01" --overrides cam1_time_offset=0.01

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-imu-offset/ --output_folder $1/$DATE-xvio-imu-offset/results

fi


if [ $EXPLORE_XVIO_MSCKF_BASELINE -gt 0 ]
then
  echo
  echo "Performing frame based XVIO MSCKF baseline exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/001-msckf-baseline-5 --frontend \
     XVIO --name "XVIO MSCKF baseline 5" --overrides msckf_baseline=5

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/002-msckf-baseline-10 --frontend \
     XVIO --name "XVIO MSCKF baseline 10" --overrides msckf_baseline=10

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/003-msckf-baseline-15 --frontend \
     XVIO --name "XVIO MSCKF baseline 15" --overrides msckf_baseline=15

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/004-msckf-baseline-20 --frontend \
     XVIO --name "XVIO MSCKF baseline 20" --overrides msckf_baseline=20

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/005-msckf-baseline-25 --frontend \
     XVIO --name "XVIO MSCKF baseline 25" --overrides msckf_baseline=25

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/006-msckf-baseline-30 --frontend \
     XVIO --name "XVIO MSCKF baseline 30" --overrides msckf_baseline=30

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/007-msckf-baseline-35 --frontend \
     XVIO --name "XVIO MSCKF baseline 35" --overrides msckf_baseline=35

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/008-msckf-baseline-40 --frontend \
     XVIO --name "XVIO MSCKF baseline 40" --overrides msckf_baseline=40

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-msckf-baseline/009-msckf-baseline-45 --frontend \
     XVIO --name "XVIO MSCKF baseline 45" --overrides msckf_baseline=45

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-msckf-baseline/ --output_folder $1/$DATE-xvio-msckf-baseline/results

fi


if [ $EXPLORE_XVIO_RHO_0 -gt 0 ]
then
  echo
  echo "Performing frame based XVIO rho_0 exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/001-rho-0.3 --frontend \
     XVIO --name "XVIO rho_0=0.3" --overrides rho_0=0.3 sigma_rho_0=0.15

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/002-rho-0.5 --frontend \
     XVIO --name "XVIO rho_0=0.5" --overrides rho_0=0.5 sigma_rho_0=0.25

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/003-rho-0.7 --frontend \
     XVIO --name "XVIO rho_0=0.7" --overrides rho_0=0.7 sigma_rho_0=0.35

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/004-rho-0.9 --frontend \
     XVIO --name "XVIO rho_0=0.9" --overrides rho_0=0.9 sigma_rho_0=0.45

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/005-rho-1.1 --frontend \
     XVIO --name "XVIO rho_0=1.1" --overrides rho_0=1.1 sigma_rho_0=0.55

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/006-rho-1.3 --frontend \
     XVIO --name "XVIO rho_0=1.3" --overrides rho_0=1.3 sigma_rho_0=0.65

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/007-rho-1.5 --frontend \
     XVIO --name "XVIO rho_0=1.5" --overrides rho_0=1.5 sigma_rho_0=0.75

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/008-rho-1.7 --frontend \
     XVIO --name "XVIO rho_0=1.7" --overrides rho_0=1.7 sigma_rho_0=0.85

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/009-rho-1.9 --frontend \
     XVIO --name "XVIO rho_0=1.9" --overrides rho_0=1.9 sigma_rho_0=0.95

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/010-rho-2.1 --frontend \
     XVIO --name "XVIO rho_0=2.1" --overrides rho_0=2.1 sigma_rho_0=1.05

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/011-rho-2.3 --frontend \
     XVIO --name "XVIO rho_0=2.3" --overrides rho_0=2.3 sigma_rho_0=1.15

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-rho-0/012-rho-2.5 --frontend \
     XVIO --name "XVIO rho_0=2.5" --overrides rho_0=2.5 sigma_rho_0=1.25

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-rho-0/ --output_folder $1/$DATE-xvio-rho-0/results

fi


if [ $EXPLORE_XVIO_FAST_DETECTION_DELTA -gt 0 ]
then
  echo
  echo "Performing frame based XVIO fast_detection_delta exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-fast-detection-delta/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-fast-detection-delta/001-fast-dd-15 --frontend \
     XVIO --name "XVIO fast_dd=15" --overrides fast_detection_delta=15

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-fast-detection-delta/002-fast-dd-20 --frontend \
     XVIO --name "XVIO fast_dd=20" --overrides fast_detection_delta=20

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-fast-detection-delta/003-fast-dd-25 --frontend \
     XVIO --name "XVIO fast_dd=25" --overrides fast_detection_delta=25

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-fast-detection-delta/004-fast-dd-30 --frontend \
     XVIO --name "XVIO fast_dd=30" --overrides fast_detection_delta=30

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-fast-detection-delta/005-fast-dd-35 --frontend \
     XVIO --name "XVIO fast_dd=35" --overrides fast_detection_delta=35

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-fast-detection-delta/006-fast-dd-40 --frontend \
     XVIO --name "XVIO fast_dd=40" --overrides fast_detection_delta=40

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-fast-detection-delta/007-fast-dd-45 --frontend \
     XVIO --name "XVIO fast_dd=45" --overrides fast_detection_delta=45

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-fast-detection-delta/008-fast-dd-50 --frontend \
     XVIO --name "XVIO fast_dd=50" --overrides fast_detection_delta=50

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-fast-detection-delta/ --output_folder $1/$DATE-xvio-fast-detection-delta/results

fi



if [ $EXPLORE_XVIO_NON_MAX_SUPP -gt 0 ]
then
  echo
  echo "Performing frame based XVIO non_max_supp exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-non-max-supp/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-non-max-supp/001-non-max-supp-false --frontend \
     XVIO --name "XVIO non_max_supp=1" --overrides non_max_supp=False

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-non-max-supp/002-non-max-supp-true --frontend \
     XVIO --name "XVIO non_max_supp=1" --overrides non_max_supp=True

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-non-max-supp/ --output_folder $1/$DATE-xvio-non-max-supp/results

fi


if [ $EXPLORE_XVIO_N_FEAT_MIN -gt 0 ]
then
  echo
  echo "Performing frame based XVIO n_feat_min exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-feat-min/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-feat-min/001-n-feat-min-50 --frontend \
     XVIO --name "XVIO n_feat_min=50" --overrides n_feat_min=50

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-feat-min/002-n-feat-min-200 --frontend \
     XVIO --name "XVIO n_feat_min=200" --overrides n_feat_min=200

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-feat-min/003-n-feat-min-350 --frontend \
     XVIO --name "XVIO n_feat_min=350" --overrides n_feat_min=350

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-feat-min/004-n-feat-min-500 --frontend \
     XVIO --name "XVIO n_feat_min=500" --overrides n_feat_min=500

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-n-feat-min/ --output_folder $1/$DATE-xvio-n-feat-min/results

fi


if [ $EXPLORE_XVIO_OUTLIER_METHOD -gt 0 ]
then
  echo
  echo "Performing frame based XVIO outlier_method exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/001-ransac-px-0.2 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.2" --overrides outlier_method=8 outlier_param1=0.2 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/002-ransac-px-0.25 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.25" --overrides outlier_method=8 outlier_param1=0.25 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/003-ransac-px-0.35 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.35" --overrides outlier_method=8 outlier_param1=0.35 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/004-ransac-px-0.4 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.4" --overrides outlier_method=8 outlier_param1=0.4 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/005-ransac-px-0.45 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.45" --overrides outlier_method=8 outlier_param1=0.45 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/006-ransac-px-0.5 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.5" --overrides outlier_method=8 outlier_param1=0.5 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/007-ransac-px-0.55 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.55" --overrides outlier_method=8 outlier_param1=0.55 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/008-ransac-px-0.6 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.6" --overrides outlier_method=8 outlier_param1=0.6 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/009-ransac-px-0.65 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.65" --overrides outlier_method=8 outlier_param1=0.65 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/010-ransac-px-0.7 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.7" --overrides outlier_method=8 outlier_param1=0.7 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/011-ransac-px-0.75 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.75" --overrides outlier_method=8 outlier_param1=0.75 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/012-ransac-px-0.8 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.8" --overrides outlier_method=8 outlier_param1=0.8 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/013-ransac-px-0.85 --frontend \
    #  XVIO --name "XVIO RANSAC px=0.85" --overrides outlier_method=8 outlier_param1=0.85 outlier_param2=0.99
    

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/001-ransac-px-0.575-p-0.98 --frontend \
     XVIO --name "XVIO RANSAC px=0.575 p=0.98" --overrides outlier_method=8 outlier_param1=0.575 outlier_param2=0.98

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/002-ransac-px-0.585-p-0.98 --frontend \
     XVIO --name "XVIO RANSAC px=0.585 p=0.98" --overrides outlier_method=8 outlier_param1=0.585 outlier_param2=0.98

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/003-ransac-px-0.625-p-0.98 --frontend \
     XVIO --name "XVIO RANSAC px=0.625 p=0.98" --overrides outlier_method=8 outlier_param1=0.625 outlier_param2=0.98

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/004-ransac-px-0.635-p-0.98 --frontend \
     XVIO --name "XVIO RANSAC px=0.635 p=0.98" --overrides outlier_method=8 outlier_param1=0.635 outlier_param2=0.98

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/005-ransac-p-0.975 --frontend \
     XVIO --name "XVIO RANSAC px=0.6 p=0.975" --overrides outlier_method=8 outlier_param1=0.6 outlier_param2=0.975

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/006-ransac-p-0.978 --frontend \
     XVIO --name "XVIO RANSAC px=0.6 p=0.978" --overrides outlier_method=8 outlier_param1=0.6 outlier_param2=0.978

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/007-ransac-p-0.982 --frontend \
     XVIO --name "XVIO RANSAC px=0.6 p=0.982" --overrides outlier_method=8 outlier_param1=0.6 outlier_param2=0.982

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/008-ransac-p-0.985 --frontend \
     XVIO --name "XVIO RANSAC px=0.6 p=0.985" --overrides outlier_method=8 outlier_param1=0.6 outlier_param2=0.985

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/009-ransac-p-0.987 --frontend \
     XVIO --name "XVIO RANSAC px=0.6 p=0.987" --overrides outlier_method=8 outlier_param1=0.6 outlier_param2=0.987

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/016-lmeds-p-0.8 --frontend \
    #  XVIO --name "XVIO LMEDS p=0.8" --overrides outlier_method=4 outlier_param1=0.3 outlier_param2=0.8

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/017-lmeds-p-0.9 --frontend \
    #  XVIO --name "XVIO LMEDS p=0.9" --overrides outlier_method=4 outlier_param1=0.3 outlier_param2=0.9

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/018-lmeds-p-0.95 --frontend \
    #  XVIO --name "XVIO LMEDS p=0.95" --overrides outlier_method=4 outlier_param1=0.3 outlier_param2=0.95

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/019-lmeds-p-0.99 --frontend \
    #  XVIO --name "XVIO LMEDS p=0.99" --overrides outlier_method=4 outlier_param1=0.3 outlier_param2=0.99

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-outlier-method/020-lmeds-p-0.999 --frontend \
    #  XVIO --name "XVIO LMEDS p=0.999" --overrides outlier_method=4 outlier_param1=0.3 outlier_param2=0.999

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-outlier-method/ --output_folder $1/$DATE-xvio-outlier-method/results

fi


if [ $EXPLORE_XVIO_TILING -gt 0 ]
then
  echo
  echo "Performing frame based XVIO tiling exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/001-w-1-h-1 --frontend \
     XVIO --name "XVIO tiles w=1 h=1" --overrides n_tiles_h=1 n_tiles_w=1

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/002-w-2-h-1 --frontend \
     XVIO --name "XVIO tiles w=2 h=1" --overrides n_tiles_h=1 n_tiles_w=2

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/003-w-2-h-2 --frontend \
     XVIO --name "XVIO tiles w=2 h=2" --overrides n_tiles_h=2 n_tiles_w=2

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/004-w-3-h-1 --frontend \
     XVIO --name "XVIO tiles w=3 h=1" --overrides n_tiles_h=1 n_tiles_w=3

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/005-w-3-h-2 --frontend \
     XVIO --name "XVIO tiles w=3 h=2" --overrides n_tiles_h=2 n_tiles_w=3

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/006-w-3-h-3 --frontend \
     XVIO --name "XVIO tiles w=3 h=3" --overrides n_tiles_h=3 n_tiles_w=3

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/007-w-4-h-2 --frontend \
     XVIO --name "XVIO tiles w=4 h=2" --overrides n_tiles_h=2 n_tiles_w=4

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/008-w-4-h-3 --frontend \
     XVIO --name "XVIO tiles w=4 h=3" --overrides n_tiles_h=3 n_tiles_w=4

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/009-w-4-h-4 --frontend \
     XVIO --name "XVIO tiles w=4 h=4" --overrides n_tiles_h=4 n_tiles_w=4

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/010-w-5-h-3 --frontend \
     XVIO --name "XVIO tiles w=5 h=3" --overrides n_tiles_h=3 n_tiles_w=5

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/011-w-5-h-4 --frontend \
     XVIO --name "XVIO tiles w=5 h=4" --overrides n_tiles_h=4 n_tiles_w=5

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-tiling/012-w-5-h-5 --frontend \
     XVIO --name "XVIO tiles w=5 h=5" --overrides n_tiles_h=5 n_tiles_w=5

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-tiling/ --output_folder $1/$DATE-xvio-tiling/results

fi


if [ $EXPLORE_XVIO_N_POSES_MAX -gt 0 ]
then
  echo
  echo "Performing frame based XVIO n_poses_max exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-poses-max/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-poses-max/001-n-poses-5 --frontend \
     XVIO --name "XVIO n_poses=5" --overrides n_poses_max=5

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-poses-max/002-n-poses-10 --frontend \
     XVIO --name "XVIO n_poses=10" --overrides n_poses_max=10

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-poses-max/003-n-poses-15 --frontend \
     XVIO --name "XVIO n_poses=15" --overrides n_poses_max=15

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-poses-max/004-n-poses-20 --frontend \
     XVIO --name "XVIO n_poses=20" --overrides n_poses_max=20

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-poses-max/005-n-poses-25 --frontend \
     XVIO --name "XVIO n_poses=25" --overrides n_poses_max=25

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-n-poses-max/ --output_folder $1/$DATE-xvio-n-poses-max/results

fi


if [ $EXPLORE_XVIO_N_SLAM_FEATURES_MAX -gt 0 ]
then
  echo
  echo "Performing frame based XVIO n_slam_features_max exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-slam-features-max/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-slam-features-max/001-n-slam-10 --frontend \
     XVIO --name "XVIO n_slam=10" --overrides n_slam_features_max=10

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-slam-features-max/002-n-slam-15 --frontend \
     XVIO --name "XVIO n_slam=15" --overrides n_slam_features_max=15

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-slam-features-max/003-n-slam-20 --frontend \
     XVIO --name "XVIO n_slam=20" --overrides n_slam_features_max=20

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-slam-features-max/004-n-slam-25 --frontend \
     XVIO --name "XVIO n_slam=25" --overrides n_slam_features_max=25

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-slam-features-max/005-n-slam-30 --frontend \
     XVIO --name "XVIO n_slam=30" --overrides n_slam_features_max=30

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-slam-features-max/006-n-slam-35 --frontend \
     XVIO --name "XVIO n_slam=35" --overrides n_slam_features_max=35

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-slam-features-max/007-n-slam-40 --frontend \
     XVIO --name "XVIO n_slam=40" --overrides n_slam_features_max=40

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-n-slam-features-max/008-n-slam-45 --frontend \
     XVIO --name "XVIO n_slam=45" --overrides n_slam_features_max=45

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-n-slam-features-max/ --output_folder $1/$DATE-xvio-n-slam-features-max/results

fi


if [ $EXPLORE_XVIO_SIGMA_IMG -gt 0 ]
then
  echo
  echo "Performing frame based XVIO sigma_img exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-sigma-img/000-baseline --frontend \
     XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-sigma-img/001-sigma-img-4-f --frontend \
     XVIO --name "XVIO sigma_img=4/f" --overrides sigma_img=0.02009117712909311

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-sigma-img/002-sigma-img-4.25-f --frontend \
     XVIO --name "XVIO sigma_img=4.25/f" --overrides sigma_img=0.02134687569966143

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-sigma-img/003-sigma-img-8.4.5-f --frontend \
     XVIO --name "XVIO sigma_img=4.5/f/f" --overrides sigma_img=0.02260257427022975

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-sigma-img/004-sigma-img-4.75-f --frontend \
     XVIO --name "XVIO sigma_img=4.75/f" --overrides sigma_img=0.02385827284079807
     
    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-sigma-img/005-sigma-img-5.25-f --frontend \
     XVIO --name "XVIO sigma_img=5.25/f" --overrides sigma_img=0.02636966998193471
     
    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-sigma-img/006-sigma-img-5.5-f --frontend \
     XVIO --name "XVIO sigma_img=5.5/f" --overrides sigma_img=0.027625368552503027
     
    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-sigma-img/007-sigma-img-5.75-f --frontend \
     XVIO --name "XVIO sigma_img=5.75/f" --overrides sigma_img=0.028881067123071345
     
    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-sigma-img/008-sigma-img-6-f --frontend \
     XVIO --name "XVIO sigma_img=6/f" --overrides sigma_img=0.030136765693639666

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-sigma-img/ --output_folder $1/$DATE-xvio-sigma-img/results

fi
 

if [ $EXPLORE_XVIO_IMU_NOISE -gt 0 ]
then
  echo
  echo "Performing frame based XVIO IMU noise exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/000-baseline --frontend \
    #  XVIO --name "XVIO baseline"

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/001-imu-noise-a-opt-w-opt --frontend \
    #  XVIO --name "XVIO IMU noise a opt, w opt" --overrides n_a=0.004316 n_ba=0.0004316 n_w=0.00013 n_bw=0.000013

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/002-imu-noise-a-0.003-w-opt --frontend \
    #  XVIO --name "XVIO IMU noise a 0.003, w opt" --overrides n_a=0.003 n_ba=0.0003 n_w=0.00013 n_bw=0.000013

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/003-imu-noise-a-0.004-w-opt --frontend \
    #  XVIO --name "XVIO IMU noise a 0.004, w opt" --overrides n_a=0.004 n_ba=0.0004 n_w=0.00013 n_bw=0.000013

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/004-imu-noise-a-0.005-w-opt --frontend \
    #  XVIO --name "XVIO IMU noise a 0.005, w opt" --overrides n_a=0.005 n_ba=0.0005 n_w=0.00013 n_bw=0.000013

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/005-imu-noise-a-opt-w-0.0001 --frontend \
    #  XVIO --name "XVIO IMU noise a opt, w 0.0001" --overrides n_a=0.004316 n_ba=0.0004316 n_w=0.0001 n_bw=0.00001

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/006-imu-noise-a-opt-w-0.0002 --frontend \
    #  XVIO --name "XVIO IMU noise a opt, w 0.0002" --overrides n_a=0.004316 n_ba=0.0004316 n_w=0.0002 n_bw=0.00002

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/007-imu-noise-a-opt-w-0.0003 --frontend \
    #  XVIO --name "XVIO IMU noise a opt, w 0.0003" --overrides n_a=0.004316 n_ba=0.0004316 n_w=0.0003 n_bw=0.00003

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/008-imu-noise-a-0.004-w-0.0002 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.004, w 0.0002" --overrides n_a=0.004 n_ba=0.0004 n_w=0.0002 n_bw=0.00002

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/009-imu-noise-a-0.0035-w-0.0002 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.0035, w 0.0002" --overrides n_a=0.0035 n_ba=0.00035 n_w=0.0002 n_bw=0.00002

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/010-imu-noise-a-0.00375-w-0.0002 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.00375, w 0.0002" --overrides n_a=0.00375 n_ba=0.000375 n_w=0.0002 n_bw=0.00002

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/011-imu-noise-a-0.00425-w-0.0002 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.00425, w 0.0002" --overrides n_a=0.00425 n_ba=0.000425 n_w=0.0002 n_bw=0.00002

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/012-imu-noise-a-0.0045-w-0.0002 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.0045, w 0.0002" --overrides n_a=0.0045 n_ba=0.00045 n_w=0.0002 n_bw=0.00002

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/013-imu-noise-a-0.004-w-0.00015 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.004, w 0.00015" --overrides n_a=0.004 n_ba=0.0004 n_w=0.00015 n_bw=0.000015

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/014-imu-noise-a-0.004-w-0.000175 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.004, w 0.000175" --overrides n_a=0.004 n_ba=0.0004 n_w=0.000175 n_bw=0.0000175

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/015-imu-noise-a-0.004-w-0.000225 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.004, w 0.000225" --overrides n_a=0.004 n_ba=0.0004 n_w=0.000225 n_bw=0.0000225
     
    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/016-imu-noise-a-0.004-w-0.00025 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.004, w 0.00025" --overrides n_a=0.004 n_ba=0.0004 n_w=0.00025 n_bw=0.000025
     
    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/016-imu-noise-a-0.004-w-0.00025 --frontend \
     XVIO --name "XVIO IMU noise a 0.00425, w 0.00025" --overrides n_a=0.00425 n_ba=0.000425 n_w=0.00025 n_bw=0.000025

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/001-imu-noise-a-0.01 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.01" --overrides n_a=8.3e-05 n_ba=8.3e-06

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/002-imu-noise-a-0.02 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.02" --overrides n_a=0.000166 n_ba=1.66e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/003-imu-noise-a-0.03 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.03" --overrides n_a=0.000249 n_ba=2.49e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/004-imu-noise-a-0.05 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.05" --overrides n_a=0.000415 n_ba=4.1500000000000006e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/005-imu-noise-a-0.1 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.1" --overrides n_a=0.00083 n_ba=8.300000000000001e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/006-imu-noise-a-0.17 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.17" --overrides n_a=0.0014110000000000001 n_ba=0.00014110000000000001

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/007-imu-noise-a-0.3 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.3" --overrides n_a=0.00249 n_ba=0.000249

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/008-imu-noise-a-0.52 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.52" --overrides n_a=0.004316 n_ba=0.00043160000000000003

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/009-imu-noise-a-0.92 --frontend \
    #  XVIO --name "XVIO IMU noise a 0.92" --overrides n_a=0.007636 n_ba=0.0007636

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/010-imu-noise-a-1.62 --frontend \
    #  XVIO --name "XVIO IMU noise a 1.62" --overrides n_a=0.013446000000000001 n_ba=0.0013446

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/011-imu-noise-a-2.84 --frontend \
    #  XVIO --name "XVIO IMU noise a 2.84" --overrides n_a=0.023572 n_ba=0.0023572

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/012-imu-noise-a-5.0 --frontend \
    #  XVIO --name "XVIO IMU noise a 5.0" --overrides n_a=0.0415 n_ba=0.00415

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/013-imu-noise-w-0.01 --frontend \
    #  XVIO --name "XVIO IMU noise w 0.01" --overrides n_w=1.3e-05 n_bw=1.2999999999999998e-06

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/014-imu-noise-w-0.02 --frontend \
    #  XVIO --name "XVIO IMU noise w 0.02" --overrides n_w=2.6e-05 n_bw=2.5999999999999997e-06

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/015-imu-noise-w-0.03 --frontend \
    #  XVIO --name "XVIO IMU noise w 0.03" --overrides n_w=3.9e-05 n_bw=3.9e-06

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/016-imu-noise-w-0.05 --frontend \
    #  XVIO --name "XVIO IMU noise w 0.05" --overrides n_w=6.5e-05 n_bw=6.5e-06

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/017-imu-noise-w-0.1 --frontend \
    #  XVIO --name "XVIO IMU noise w 0.1" --overrides n_w=0.00013 n_bw=1.3e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/018-imu-noise-w-0.17 --frontend \
    #  XVIO --name "XVIO IMU noise w 0.17" --overrides n_w=0.000221 n_bw=2.21e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/019-imu-noise-w-0.3 --frontend \
    #  XVIO --name "XVIO IMU noise w 0.3" --overrides n_w=0.00039 n_bw=3.899999999999999e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/020-imu-noise-w-0.52 --frontend \
    #  XVIO --name "XVIO IMU noise w 0.52" --overrides n_w=0.000676 n_bw=6.759999999999999e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/021-imu-noise-w-0.92 --frontend \
    #  XVIO --name "XVIO IMU noise w 0.92" --overrides n_w=0.001196 n_bw=0.0001196

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/022-imu-noise-w-1.62 --frontend \
    #  XVIO --name "XVIO IMU noise w 1.62" --overrides n_w=0.0021060000000000002 n_bw=0.0002106

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/023-imu-noise-w-2.84 --frontend \
    #  XVIO --name "XVIO IMU noise w 2.84" --overrides n_w=0.0036919999999999995 n_bw=0.0003692

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/024-imu-noise-w-5.0 --frontend \
    #  XVIO --name "XVIO IMU noise w 5.0" --overrides n_w=0.0065 n_bw=0.00065

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/025-imu-noise-a-w-0.01 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 0.01" --overrides n_a=8.3e-05 n_ba=8.3e-06 n_w=1.3e-05 n_bw=1.2999999999999998e-06

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/026-imu-noise-a-w-0.02 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 0.02" --overrides n_a=0.000166 n_ba=1.66e-05 n_w=2.6e-05 n_bw=2.5999999999999997e-06

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/027-imu-noise-a-w-0.03 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 0.03" --overrides n_a=0.000249 n_ba=2.49e-05 n_w=3.9e-05 n_bw=3.9e-06

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/028-imu-noise-a-w-0.05 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 0.05" --overrides n_a=0.000415 n_ba=4.1500000000000006e-05 n_w=6.5e-05 n_bw=6.5e-06

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/029-imu-noise-a-w-0.1 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 0.1" --overrides n_a=0.00083 n_ba=8.300000000000001e-05 n_w=0.00013 n_bw=1.3e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/030-imu-noise-a-w-0.17 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 0.17" --overrides n_a=0.0014110000000000001 n_ba=0.00014110000000000001 n_w=0.000221 n_bw=2.21e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/031-imu-noise-a-w-0.3 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 0.3" --overrides n_a=0.00249 n_ba=0.000249 n_w=0.00039 n_bw=3.899999999999999e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/032-imu-noise-a-w-0.52 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 0.52" --overrides n_a=0.004316 n_ba=0.00043160000000000003 n_w=0.000676 n_bw=6.759999999999999e-05

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/033-imu-noise-a-w-0.92 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 0.92" --overrides n_a=0.007636 n_ba=0.0007636 n_w=0.001196 n_bw=0.0001196

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/034-imu-noise-a-w-1.62 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 1.62" --overrides n_a=0.013446000000000001 n_ba=0.0013446 n_w=0.0021060000000000002 n_bw=0.0002106

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/035-imu-noise-a-w-2.84 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 2.84" --overrides n_a=0.023572 n_ba=0.0023572 n_w=0.0036919999999999995 n_bw=0.0003692

    # python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-xvio-imu-noise/036-imu-noise-a-w-5.0 --frontend \
    #  XVIO --name "XVIO IMU noise a, w 5.0" --overrides n_a=0.0415 n_ba=0.00415 n_w=0.0065 n_bw=0.00065

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-xvio-imu-noise/ --output_folder $1/$DATE-xvio-imu-noise/results

fi


if [ $EXPLORE_EKLT_PATCH_SIZE -gt 0 ]
then
  echo
  echo "Performing EKLT patch size exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-patch-size/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-patch-size/002-p-9 \
      --frontend EKLT --name "EKLT p=9" --overrides eklt_patch_size=9

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-patch-size/003-p-11 \
      --frontend EKLT --name "EKLT p=11" --overrides eklt_patch_size=11

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-patch-size/004-p-15 \
      --frontend EKLT --name "EKLT p=15" --overrides eklt_patch_size=15

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-patch-size/005-p-19 \
      --frontend EKLT --name "EKLT p=19" --overrides eklt_patch_size=19

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-patch-size/006-p-27 \
      --frontend EKLT --name "EKLT p=27" --overrides eklt_patch_size=27

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-patch-size/007-p-31 \
      --frontend EKLT --name "EKLT p=31" --overrides eklt_patch_size=31

    
  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-patch-size/ --output_folder $1/$DATE-eklt-patch-size/results

fi


if [ $EXPLORE_EKLT_IMU_OFFSET -gt 0 ]
then
  echo
  echo "Performing EKLT IMU offset exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-imu-offset/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    # 0.0027626

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-imu-offset/002-t-0.0015 \
      --frontend EKLT --name "EKLT IMU offset 0.0015" --overrides cam1_time_offset=0.0015

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-imu-offset/003-t-0.0020 \
      --frontend EKLT --name "EKLT IMU offset 0.0020" --overrides cam1_time_offset=0.0020

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-imu-offset/004-t-0.0025 \
      --frontend EKLT --name "EKLT IMU offset 0.0025" --overrides cam1_time_offset=0.0025

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-imu-offset/005-t-0.003 \
      --frontend EKLT --name "EKLT IMU offset 0.003" --overrides cam1_time_offset=0.003

    
  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-imu-offset/ --output_folder $1/$DATE-eklt-imu-offset/results

fi



if [ $EXPLORE_EKLT_OUTLIER_REMOVAL -gt 0 ]
then
  echo
  echo "Performing EKLT outlier removal exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-outlier-removal/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    # 0.0027626

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-outlier-removal/001-eklt-remove-outliers-on \
      --frontend EKLT --name "EKLT outlier removal ON" --overrides eklt_enable_outlier_removal=true

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-outlier-removal/002-eklt-remove-outliers-off \
      --frontend EKLT --name "EKLT outlier removal OFF" --overrides eklt_enable_outlier_removal=false

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-outlier-removal/ --output_folder $1/$DATE-eklt-outlier-removal/results

fi


if [ $EXPLORE_EKLT_TRACKING_QUALITY -gt 0 ]
then
  echo
  echo "Performing EKLT tracking quality exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-tracking-quality/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-tracking-quality/001-eklt-tracking-q-0.01 \
      --frontend EKLT --name "EKLT tracking-q=0.01" --overrides eklt_quality_level=0.01

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-tracking-quality/002-eklt-tracking-q-0.1 \
      --frontend EKLT --name "EKLT tracking-q=0.1" --overrides eklt_quality_level=0.1

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-tracking-quality/003-eklt-tracking-q-0.2 \
      --frontend EKLT --name "EKLT tracking-q=0.2" --overrides eklt_quality_level=0.2

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-tracking-quality/004-eklt-tracking-q-0.4 \
      --frontend EKLT --name "EKLT tracking-q=0.4" --overrides eklt_quality_level=0.4

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-tracking-quality/005-eklt-tracking-q-0.5 \
      --frontend EKLT --name "EKLT tracking-q=0.5" --overrides eklt_quality_level=0.5

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-tracking-quality/ --output_folder $1/$DATE-eklt-tracking-quality/results

fi



if [ $EXPLORE_EKLT_UPDATE_STRATEGY_N_MSEC -gt 0 ]
then
  echo
  echo "Performing EKLT UPDATE_STRATEGY_N_MSEC exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-msec/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-msec/001-eklt-update-10-msec \
      --frontend EKLT --name "EKLT update every 10msec" --overrides eklt_ekf_update_strategy=every-n-msec-with-events eklt_ekf_update_every_n=10

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-msec/002-eklt-update-20-msec \
      --frontend EKLT --name "EKLT update every 20msec" --overrides eklt_ekf_update_strategy=every-n-msec-with-events eklt_ekf_update_every_n=20

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-msec/003-eklt-update-30-msec \
      --frontend EKLT --name "EKLT update every 30msec" --overrides eklt_ekf_update_strategy=every-n-msec-with-events eklt_ekf_update_every_n=30

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-msec/004-eklt-update-40-msec \
      --frontend EKLT --name "EKLT update every 40msec" --overrides eklt_ekf_update_strategy=every-n-msec-with-events eklt_ekf_update_every_n=40

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-update-strategy-msec/ --output_folder $1/$DATE-eklt-update-strategy-msec/results

fi





if [ $EXPLORE_EKLT_UPDATE_STRATEGY_N_EVENTS -gt 0 ]
then
  echo
  echo "Performing EKLT UPDATE_STRATEGY_N_EVENTS exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-n-events/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-n-events/001-eklt-update-12000-events \
      --frontend EKLT --name "EKLT update every 12000 events" --overrides eklt_ekf_update_strategy=every-n-events eklt_ekf_update_every_n=12000

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-n-events/002-eklt-update-25000-events \
      --frontend EKLT --name "EKLT update every 25000 events" --overrides eklt_ekf_update_strategy=every-n-events eklt_ekf_update_every_n=25000

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-n-events/003-eklt-update-50000-events \
      --frontend EKLT --name "EKLT update every 50000 events" --overrides eklt_ekf_update_strategy=every-n-events eklt_ekf_update_every_n=50000

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-n-events/004-eklt-update-75000-events \
      --frontend EKLT --name "EKLT update every 75000 events" --overrides eklt_ekf_update_strategy=every-n-events eklt_ekf_update_every_n=75000

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-update-strategy-n-events/005-eklt-update-120000-events \
      --frontend EKLT --name "EKLT update every 120000 events" --overrides eklt_ekf_update_strategy=every-n-events eklt_ekf_update_every_n=120000

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-update-strategy-n-events/ --output_folder $1/$DATE-eklt-update-strategy-n-events/results

fi







if [ $EXPLORE_EKLT_INTERPOLATION_TIMESTAMP -gt 0 ]
then
  echo
  echo "Performing EKLT INTERPOLATION_TIMESTAMP exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpolation-ts/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpolation-ts/001-eklt-baseline \
      --frontend EKLT --name "EKLT baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpolation-ts/002-eklt-interpolation-t-avg \
      --frontend EKLT --name "EKLT ekf update ts AVG" --overrides eklt_ekf_update_timestamp=patches-average

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpolation-ts/003-eklt-interpolation-t-max \
      --frontend EKLT --name "EKLT ekf update ts MAX" --overrides eklt_ekf_update_timestamp=patches-maximum

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-interpolation-ts/ --output_folder $1/$DATE-eklt-interpolation-ts/results

fi







if [ $EXPLORE_EKLT_FEATURE_INTERPOLATION -gt 0 ]
then
  echo
  echo "Performing EKLT FEATURE_INTERPOLATION exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-feature-interpolation/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-feature-interpolation/001-eklt-nearest-neighbor \
      --frontend EKLT --name "EKLT feat interpol NN" --overrides eklt_ekf_feature_interpolation=nearest-neighbor


    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-feature-interpolation/002-eklt-relative-limit \
      --frontend EKLT --name "EKLT linear-relative-limit 1.0" --overrides eklt_ekf_feature_interpolation=linear-relative-limit eklt_ekf_feature_extrapolation_limit=1.0

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-feature-interpolation/003-eklt-absolute-limit \
      --frontend EKLT --name "EKLT linear-absolute-limit 5ms" --overrides eklt_ekf_feature_interpolation=linear-absolute-limit eklt_ekf_feature_extrapolation_limit=5

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-feature-interpolation/ --output_folder $1/$DATE-eklt-feature-interpolation/results

fi




if [ $EXPLORE_EKLT_FEATURE_INTERPOLATION_RELATIVE_LIMIT -gt 0 ]
then
  echo
  echo "Performing EKLT FEATURE_INTERPOLATION_RELATIVE_LIMIT exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-rel-limit/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-rel-limit/001-eklt-rl-0.5 \
      --frontend EKLT --name "EKLT linear-relative-limit 0.5" --overrides eklt_ekf_feature_interpolation=linear-relative-limit eklt_ekf_feature_extrapolation_limit=0.5

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-rel-limit/002-eklt-rl-1.5 \
      --frontend EKLT --name "EKLT linear-relative-limit 1.5" --overrides eklt_ekf_feature_interpolation=linear-relative-limit eklt_ekf_feature_extrapolation_limit=1.5

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-rel-limit/003-eklt-rl-5.0 \
      --frontend EKLT --name "EKLT linear-relative-limit 5.0" --overrides eklt_ekf_feature_interpolation=linear-relative-limit eklt_ekf_feature_extrapolation_limit=5.0

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-rel-limit/004-eklt-rl-10.0 \
      --frontend EKLT --name "EKLT linear-relative-limit 10.0" --overrides eklt_ekf_feature_interpolation=linear-relative-limit eklt_ekf_feature_extrapolation_limit=10.0

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-interpol-rel-limit/ --output_folder $1/$DATE-eklt-interpol-rel-limit/results

fi



if [ $EXPLORE_EKLT_FEATURE_INTERPOLATION_ABSOLUTE_LIMIT -gt 0 ]
then
  echo
  echo "Performing EKLT FEATURE_INTERPOLATION_ABSOLUTE_LIMIT exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-abs-limit/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-abs-limit/001-eklt-al-1 \
      --frontend EKLT --name "EKLT linear-absolute-limit 1ms" --overrides eklt_ekf_feature_interpolation=linear-absolute-limit eklt_ekf_feature_extrapolation_limit=0.001

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-abs-limit/002-eklt-al-1.5 \
      --frontend EKLT --name "EKLT linear-absolute-limit 5ms" --overrides eklt_ekf_feature_interpolation=linear-absolute-limit eklt_ekf_feature_extrapolation_limit=0.005

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-abs-limit/003-eklt-al-5.0 \
      --frontend EKLT --name "EKLT linear-absolute-limit 1ms0" --overrides eklt_ekf_feature_interpolation=linear-absolute-limit eklt_ekf_feature_extrapolation_limit=0.010

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-interpol-abs-limit/004-eklt-al-10.0 \
      --frontend EKLT --name "EKLT linear-absolute-limit 3ms0" --overrides eklt_ekf_feature_interpolation=linear-absolute-limit eklt_ekf_feature_extrapolation_limit=0.030

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-interpol-abs-limit/ --output_folder $1/$DATE-eklt-interpol-abs-limit/results

fi







if [ $EXPLORE_EKLT_LINLOG_SCALE -gt 0 ]
then
  echo
  echo "Performing lin-log scale exploration"
  echo


  if [ $COMPARISONS_ONLY -lt 1 ]
  then

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-linlog-scale/000-xvio-baseline \
      --frontend XVIO --name "XVIO baseline"

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-linlog-scale/001-eklt-default-log-scale \
      --frontend EKLT --name "EKLT default log scale" --overrides eklt_use_linlog_scale=false

    python evaluate.py --configuration evaluate.yaml --output_folder $1/$DATE-eklt-linlog-scale/002-eklt-novel-linlog-scale \
      --frontend EKLT --name "EKLT linlog scale" --overrides eklt_use_linlog_scale=true

  fi

  python ../scripts/compare.py --input_folder $1/$DATE-eklt-linlog-scale/ --output_folder $1/$DATE-eklt-linlog-scale/results

fi