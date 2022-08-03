import argparse
import os
from typing import List, Optional

import pandas as pd

from x_evaluate.evaluation_data import EvaluationDataSummary
from x_evaluate.plots import plot_evo_trajectory_with_euler_angles, PlotContext
from x_evaluate.scriptlets import read_evaluation_pickle, find_evaluation_files_recursively
from x_evaluate.utils import name_to_identifier


def prepare_output_folder(output_folder: Optional[str], fall_back: Optional[str]):
    if output_folder is None:
        if fall_back is None:
            return None
        output_folder = fall_back
    output_folder = os.path.normpath(output_folder)
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    return output_folder


def main():
    parser = argparse.ArgumentParser(description="Prints odometry-specific comparison plots")
    parser.add_argument('--input_folder', type=str, required=True)

    args = parser.parse_args()

    pd.options.display.max_colwidth = None
    pd.options.display.width = 0

    evaluation_files = find_evaluation_files_recursively(args.input_folder)

    output_folder = os.path.join(args.input_folder, "results")

    prepare_output_folder(output_folder, None)

    print(F"Found {evaluation_files}")

    evaluations: List[EvaluationDataSummary] = []

    for f in evaluation_files:

        e = read_evaluation_pickle(os.path.dirname(f), os.path.basename(f))

        evaluations.append(e)

    # can be converted to for loop in common datasets when needed
    dataset = "Wells Test 5"

    for e in evaluations:
        gt_trajectory = e.data[dataset].trajectory_data.traj_gt
        estimate = e.data[dataset].trajectory_data.traj_est_aligned

        with PlotContext(os.path.join(output_folder, F"{name_to_identifier(dataset)}_"
                                                     F"{name_to_identifier(e.name)}_xyz_euler"),
                         subplot_cols=3, subplot_rows=3) as pc:
            print(F"Length GT {gt_trajectory.timestamps[-1]-gt_trajectory.timestamps[0]:.1f}s Estimate "
                  F"{estimate.timestamps[-1]-estimate.timestamps[0]:.1f}s")
            plot_evo_trajectory_with_euler_angles(pc, estimate, e.name, gt_trajectory)



if __name__ == '__main__':
    main()
