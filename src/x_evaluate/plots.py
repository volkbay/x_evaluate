from enum import Enum
from typing import List
import numpy as np
from matplotlib import pyplot as plt
from x_evaluate.evaluation_data import DistributionSummary

import matplotlib.colors as mcolors


class PlotType(Enum):
    BOXPLOT = 1
    TIME_SERIES = 2


class PlotContext:
    figure: plt.Figure
    axis: List[plt.Axes]

    def __init__(self, filename=None, subplot_rows=1, subplot_cols=1, base_width_inch=8, base_height_inch=6):
        self.filename = filename
        self.subplot_rows = subplot_rows
        self.subplot_cols = subplot_cols
        self.width_inch = base_width_inch * subplot_cols
        self.height_inch = base_height_inch * subplot_rows
        self.axis = []

    def __enter__(self):
        self.figure = plt.figure()
        self.subplot_idx = 0
        self.figure.set_size_inches(self.width_inch, self.height_inch)
        return self

    def get_axis(self, **kwargs) -> plt.Axes:
        self.subplot_idx += 1
        ax = self.figure.add_subplot(self.subplot_rows, self.subplot_cols, self.subplot_idx, **kwargs)
        self.axis.append(ax)
        return ax

    def __exit__(self, exc_type, exc_value, exc_traceback):
        self.figure.tight_layout()
        if self.filename is None:
            self.figure.show()
        else:
            self.figure.savefig(self.filename)

        for a in self.axis:
            a.set_xscale('linear')  # workaround for https://github.com/matplotlib/matplotlib/issues/9970
            a.set_yscale('linear')  # workaround for https://github.com/matplotlib/matplotlib/issues/9970

        self.figure.clf()
        plt.close(self.figure)


def boxplot(pc: PlotContext, data, labels, title="", outlier_params=1.5):
    ax = pc.get_axis()
    ax.boxplot(data, vert=True, labels=labels, whis=outlier_params)
    ax.set_title(title)


def summary_to_dict(distribution_summary: DistributionSummary, label=None, use_95_quantiles_as_min_max=False,
                    scaling=1):
    result_dict = {
        'q1': distribution_summary.quantiles[0.25] * scaling,  # First quartile (25th percentile)
        'med': distribution_summary.quantiles[0.5] * scaling,  # Median         (50th percentile)
        'q3': distribution_summary.quantiles[0.75] * scaling,  # Third quartile (75th percentile)
        'fliers': []  # Outliers
    }

    if use_95_quantiles_as_min_max:
        result_dict['whislo'] = distribution_summary.quantiles[0.05] * scaling  # Bottom whisker position
        result_dict['whishi'] = distribution_summary.quantiles[0.95] * scaling  # Top whisker position
    else:
        result_dict['whislo'] = distribution_summary.min * scaling  # Bottom whisker position
        result_dict['whishi'] = distribution_summary.max * scaling  # Top whisker position

    if label is not None:
        result_dict['label'] = label,

    return result_dict


def boxplot_from_summary(pc: PlotContext, distribution_summaries: List[DistributionSummary], labels, title=""):
    ax = pc.get_axis()
    boxes = []

    for i in range(len(distribution_summaries)):
        boxes.append(summary_to_dict(distribution_summaries[i], labels[i]))
    ax.bxp(boxes, showfliers=False)
    ax.set_title(title)


def time_series_plot(pc: PlotContext, time, data, labels, title="", ylabel=None, use_scatter=False):
    ax = pc.get_axis()
    for i in range(len(data)):

        # this causes issues, quick fix:
        label = labels[i]
        if label.startswith('_'):
            label = label[1:]

        if isinstance(time, list):
            t = time[i]
        else:
            t = time

        if use_scatter:
            ax.scatter(t, data[i], label=label)
        else:
            ax.plot(t, data[i], label=label)

    ax.legend()
    ax.set_title(title)
    ax.set_xlabel("Time [s]")

    if ylabel is not None:
        ax.set_ylabel(ylabel)


def bubble_plot(pc: PlotContext, xy_data, labels, y_resolution=0.1, x_resolution=0.1, title=None, ylabel=None,
                xlabel=None):
    ax = pc.get_axis()

    data = []
    times = []
    sizes = []
    s_min = np.iinfo(np.int32).max
    s_max = 0

    for i, xy in enumerate(xy_data):
        x, y, size = create_bubbles_from_2d_point_cloud(xy, x_resolution, y_resolution)
        s_min = min(np.min(size), s_min)
        s_max = max(np.max(size), s_max)
        data.append(y)
        times.append(x)
        sizes.append(size)

    px_size_min = 5
    px_size_max = 15

    for i, d in enumerate(data):
        size = px_size_min + (sizes[i] - s_min) / (s_max - s_min) * (px_size_max - px_size_min)
        size = np.power(size, 2)
        ax.scatter(times[i], d, s=size, label=labels[i], alpha=0.5)

    ax.legend()
    if title:
        ax.set_title(title)
    if ylabel:
        ax.set_ylabel(ylabel)
    if xlabel:
        ax.set_xlabel(xlabel)


def create_bubbles_from_2d_point_cloud(xy, x_resolution=0.1, y_resolution=0.1):
    x = xy[:, 0]
    y = xy[:, 1]
    x_buckets = np.arange(np.min(x), np.max(x), x_resolution)
    y_buckets = np.arange(np.min(y), np.max(y), y_resolution)
    x_bucket_idx = np.digitize(x, x_buckets)
    x_bucket_idx_uniq = np.unique(x_bucket_idx)

    # filter empty buckets:  (-1 to convert upper bound --> lower bound, as we always take the first errors per bucket)
    # x_buckets = x_buckets[np.clip(x_bucket_idx_uniq - 1, 0, len(x_buckets))]

    xys = np.empty((len(x), 3))

    i = 0

    for idx in x_bucket_idx_uniq:
        # tracking_errors = euclidean_error[bucket_index == idx]
        current_bucket_y = xy[x_bucket_idx == idx, 1]
        y_bucket_idx = np.digitize(current_bucket_y, y_buckets)
        y_bucket_idx_uniq = np.unique(y_bucket_idx)
        used_y_buckets = y_buckets[np.clip(y_bucket_idx_uniq - 1, 0, len(y_buckets))]
        xxs = np.ones_like(used_y_buckets) * x_buckets[idx-1]
        sizes = np.bincount(y_bucket_idx)[1:]

        sizes = sizes[sizes != 0]

        n = len(used_y_buckets)
        xys[i:(i+n), 0] = xxs
        xys[i:(i+n), 1] = used_y_buckets
        xys[i:(i+n), 2] = sizes
        i += n

    xys = xys[:i, :]

    return xys[:, 0], xys[:, 1], xys[:, 2]


def color_box(bp, color):
    elements = ['medians', 'boxes', 'caps', 'whiskers']
    # Iterate over each of the elements changing the color
    for elem in elements:
        [plt.setp(bp[elem][idx], color=color, linestyle='-', lw=1.0)
         for idx in range(len(bp[elem]))]
    return


def barplot_compare(ax: plt.Axes, x_tick_labels, data, legend_labels, ylabel=None, colors=None, legend=True,
                    title=None):
    if colors is None:
        colors = list(mcolors.TABLEAU_COLORS.values())

    n_data = len(data)
    n_xlabel = len(x_tick_labels)

    for idx, d in enumerate(data):
        positions, widths = evenly_distribute_plot_positions(idx, n_xlabel, n_data)

        ax.bar(positions, d, widths, label=legend_labels[idx], color=colors[idx])

    ax.set_xticks(np.arange(n_xlabel))
    ax.set_xticklabels(x_tick_labels)
    if ylabel is not None:
        ax.set_ylabel(ylabel)

    if legend:
        ax.legend()

    if title:
        ax.set_title(title)


def hist_from_bin_values(ax: plt.Axes, bins, hist, xlabel=None, use_percentages=False, use_log=False):
    widths = bins[1:] - bins[:-1]

    if use_percentages:
        hist = 100 * hist / np.sum(hist)
        ax.set_ylabel("Occurrence [%]")
    else:
        ax.set_ylabel("Absolut occurrence")

    ax.bar(bins[:-1], hist, width=widths)

    if use_log:
        ax.set_xscale('log')

    if xlabel is not None:
        ax.set_xlabel(xlabel)


def boxplot_compare(ax: plt.Axes, x_tick_labels, data, legend_labels, colors=None, legend=True, ylabel=None,
                    title=None):
    if colors is None:
        colors = list(mcolors.TABLEAU_COLORS.values())

    n_data = len(data)
    n_xlabel = len(x_tick_labels)
    leg_handles = []
    leg_labels = []
    bps = []

    for idx, d in enumerate(data):
        positions, widths = evenly_distribute_plot_positions(idx, n_xlabel, n_data)
        props = {
            'facecolor': colors[idx]
        }

        if isinstance(d[0], dict):
            bp = ax.bxp(d, positions=positions, widths=widths, patch_artist=True, boxprops=props)
        else:
            bp = ax.boxplot(d, positions=positions, widths=widths, patch_artist=True, boxprops=props)
        # boxprops=dict(
        # facecolor=colors[idx]))
        color_box(bp, colors[idx])
        bps.append(bp)
        tmp, = plt.plot([1, 1], c=colors[idx], alpha=0)
        leg_handles.append(tmp)
        leg_labels.append(legend_labels[idx])

    ax.set_xticks(np.arange(n_xlabel))
    ax.set_xticklabels(x_tick_labels)
    # xlims = ax.get_xlim()
    # ax.set_xlim([xlims[0]-0.1, xlims[1]-0.1])
    if legend:
        # ax.legend(leg_handles, leg_labels, bbox_to_anchor=(
            # 1.05, 1), loc=2, borderaxespad=0.)
        # ax.legend(leg_handles, leg_labels)
        ax.legend([element["boxes"][0] for element in bps],
                  [legend_labels[idx] for idx, _ in enumerate(data)])

    if ylabel is not None:
        ax.set_ylabel(ylabel)

    if title:
        ax.set_title(title)

    # map(lambda x: x.set_visible(False), leg_handles)


def draw_lines_on_top_of_comparison_plots(ax: plt.Axes, data, num_comparisons):
    n_xlabel = len(data)
    n_data = num_comparisons
    positions_start, widths_start = evenly_distribute_plot_positions(0, n_xlabel, n_data)
    positions_end, widths_end = evenly_distribute_plot_positions(num_comparisons - 1, n_xlabel, n_data)
    for idx, d in enumerate(data):
        x_start = positions_start[idx] - widths_start[idx]/2
        x_end = positions_end[idx] + widths_end[idx]/2

        if len(d) == 1:
            val = d[0]
            d = [val, val]

        x = np.linspace(x_start, x_end, len(d))
        ax.plot(x, d, color="black", linestyle="--", linewidth=1)


def evenly_distribute_plot_positions(idx, num_slots, num_entries):
    width = 1 / (1.5 * num_entries + 1.5)
    widths = [width] * num_slots

    positions = [pos - 0.5 + 1.5 * width + idx * width
                 for pos in np.arange(num_slots)]

    return positions, widths
