module stats.median;

import std.array, std.stdio, std.traits, std.conv, std.format, std.algorithm;
import stats, common.options;

version(unittest)
{
    import unit_threaded;
}

class Median(T) : Stats!(T)
{
    T[] vals;
    double result;

    this(Options opts)
    {
    }

    void add(T val)
    {
        this.vals ~= val;
    }

    void finish()
    {
        double[] sortedVals = vals.sort().map!(a => to!(double)(a)).array;
        if (vals.length % 2 == 0)
        {
            auto index = vals.length >> 1;
            result = (sortedVals[index-1] + sortedVals[index]) / 2.0;
        }
        else
        {
            result = sortedVals[vals.length >> 1];
        }
    }

    override string toString()
    {
        return format("MEDIAN: %.4f", result);
    }
}

version(unittest)
{
    @Types!(short, int, long, float, double)
    void testOddNumberOfValues(T)()
    {
        Options opts;
        Stats!T median = initStats!(T)("MEDIAN", opts);
        median.add(1);
        median.add(2);
        median.add(3);
        median.finish();
        median.toString().shouldEqual("MEDIAN: 2.0000");
    }

    @Types!(short, int, long, float, double)
    void testEvenNumberOfValues(T)()
    {
        Options opts;
        Stats!T median = initStats!(T)("MEDIAN", opts);
        median.add(1);
        median.add(2);
        median.add(3);
        median.add(4);
        median.finish();
        median.toString().shouldEqual("MEDIAN: 2.5000");
    }
}
