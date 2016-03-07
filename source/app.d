import std.getopt;
import std.stdio;

struct Options
{
    string[] stats;
    int[] percentiles;
    int threads;
}

void main(string[] args)
{
    Options opts = getOptions(args);
}

Options getOptions(string[] args)
{
    immutable bool[string] supportedStats = [
        "count": true,
        "sum": true,
        "mean": true,
        "median": true,
        "mode": true,
        "stddev": true,
        "range": true,
        "percentiles": true
    ];
    string percentiles, stats;
    int threads;
    Options currOptions;

    auto help = getopt(args,
        "percentiles|p", "A comma separated list of percentiles", &percentiles,
        "stats|s", "A comma separated list of statistical measures", &stats,
        "threads|t", "The number of worker threads to use", &threads
    );

    if (help.helpWanted)
    {
        defaultGetoptPrinter("pst - Pipable Statistics", help.options);
        writeln("Supported statistical measures: ", supportedStats.keys);
    }

    return currOptions;
}
