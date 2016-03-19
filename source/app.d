import std.array, std.algorithm, std.getopt, std.stdio, std.string, std.conv;
import runner.fiber;

struct Options
{
    string[] stats;
    int[] percentiles;
    int threads;
}

int main(string[] args)
{
    Options opts = getOptions(args);
    bool isFloat = false;

    if (opts.stats.length == 0)
    {
        writeln("You must specify at least one stat to calculate.");
        return 1;
    }
    foreach (string line; stdin.byLineCopy)
    {
        if (!isNumeric(line))
        {
            writeln("The value must be a number.");
            return 1;
        }
        else if (indexOf(line, '.') > -1)
        {
            isFloat = true;
        }
        writeln("Line: ", line);
        writeln("Is a float: ", isFloat);
    }
    return 0;
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
    int threads = 0;
    Options currOptions;

    auto help = getopt(args,
        "percentiles|p", "A comma separated list of percentiles", &percentiles,
        "stats|s", "A comma separated list of statistical measures", &stats,
        "threads|t", "The number of worker threads to use", &threads
    );

    currOptions.stats = stats.split(",");
    currOptions.percentiles = percentiles.split(",").map!(to!int).array();
    currOptions.threads = threads;

    if (help.helpWanted)
    {
        defaultGetoptPrinter("pst - Pipable Statistics", help.options);
        writeln("Supported statistical measures: ", supportedStats.keys);
    }

    return currOptions;
}
