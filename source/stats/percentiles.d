module stats.percentiles;

import std.array, std.stdio, std.traits, std.conv, std.format, std.algorithm,
       std.math;
import stats, common.options;

version(unittest)
{
    import unit_threaded;
}

class Percentiles(T) : Stats!(T)
{
    T[] vals;
    T[100] results;
    int[] percentiles;

    this(Options opts)
    {
        this.percentiles = opts.percentiles;
    }

    void add(T val)
    {
        this.vals ~= val;
    }

    void finish()
    {
        double[] sortedVals = vals.sort().map!(a => to!(double)(a)).array;
        foreach (p; this.percentiles)
        {
            auto index = cast(long)trunc(float(sortedVals.length) * (float(p) / 100.0));
            results[p] = vals[index];
        }
    }

    override string toString()
    {
        string[] output;
        foreach (p; this.percentiles.sort())
        {
            static if (isFloatingPoint!(T))
            {
                output ~= format("PERCENTILE (%d): %.4f", p, results[p]);
            }
            else
            {
                output ~= format("PERCENTILE (%d): %d", p, results[p]);
            }
        }
        return output.join("\n");
    }
}

version(unittest)
{
    import std.range, std.algorithm;

    @Types!(short, int, long, float, double)
    void testTenValues(T)()
    {
        Options opts;
        opts.percentiles ~= 50;
        opts.percentiles ~= 75;
        opts.percentiles ~= 99;
        Stats!T percentile = initStats!(T)("percentiles", opts);
        iota(0, 10).each!(a => percentile.add(a));
        percentile.finish();
        static if (isFloatingPoint!(T))
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 5.0000\nPERCENTILE (75): 7.0000\nPERCENTILE (99): 9.0000");
        }
        else
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 5\nPERCENTILE (75): 7\nPERCENTILE (99): 9");
        }
    }


    @Types!(short, int, long, float, double)
    void testOneHundredValues(T)()
    {
        Options opts;
        opts.percentiles ~= 50;
        opts.percentiles ~= 75;
        opts.percentiles ~= 99;
        Stats!T percentile = initStats!(T)("percentiles", opts);
        iota(0, 100).each!(a => percentile.add(a));
        percentile.finish();
        static if (isFloatingPoint!(T))
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 50.0000\nPERCENTILE (75): 75.0000\nPERCENTILE (99): 99.0000");
        }
        else
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 50\nPERCENTILE (75): 75\nPERCENTILE (99): 99");
        }
    }
}
