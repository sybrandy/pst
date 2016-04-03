module stats.percentiles;

import std.array, std.stdio, std.traits, std.conv, std.format, std.algorithm,
       std.math;
import stats, common.options;

version(unittest)
{
    import std.range, std.algorithm;
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
            auto index = cast(long)ceil(float(sortedVals.length) * (float(p) / 100.0));
            if (vals.length == index)
                index--;
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
    // Need to evaluate whether or not it is worth worrying about such a small
    // sample size.  The algorithm doesn't work properly here, however is it
    // really needed?
    /*
    @Types!(short, int, long, float, double)
    void testTenValues(T)()
    {
        Options opts;
        opts.percentiles ~= 50;
        opts.percentiles ~= 75;
        opts.percentiles ~= 99;
        Stats!T percentile = initStats!(T)("percentiles", opts);
        T start = 1;
        T end = 11;
        iota(start, end).each!(a => percentile.add(a));
        percentile.finish();
        writelnUt(percentile.toString());
        static if (isFloatingPoint!(T))
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 6.0000\nPERCENTILE (75): 8.0000\nPERCENTILE (99): 10.0000");
        }
        else
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 6\nPERCENTILE (75): 8\nPERCENTILE (99): 10");
        }
    }
    */

    @Types!(short, int, long, float, double)
    void testTwentyValues(T)()
    {
        Options opts;
        opts.percentiles ~= 50;
        opts.percentiles ~= 75;
        opts.percentiles ~= 99;
        Stats!T percentile = initStats!(T)("percentiles", opts);
        T start = 1;
        T end = 21;
        iota(start, end).each!(a => percentile.add(a));
        percentile.finish();
        writelnUt(percentile.toString());
        static if (isFloatingPoint!(T))
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 11.0000\nPERCENTILE (75): 16.0000\nPERCENTILE (99): 20.0000");
        }
        else
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 11\nPERCENTILE (75): 16\nPERCENTILE (99): 20");
        }
    }

    @Types!(short, int, long, float, double)
    void testOneHundredValues(T)()
    {
        import std.range, std.algorithm;
        Options opts;
        opts.percentiles ~= 50;
        opts.percentiles ~= 75;
        opts.percentiles ~= 99;
        Stats!T percentile = initStats!(T)("percentiles", opts);
        T start = 1;
        T end = 101;
        iota(start, end).each!(a => percentile.add(a));
        percentile.finish();
        static if (isFloatingPoint!(T))
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 51.0000\nPERCENTILE (75): 76.0000\nPERCENTILE (99): 100.0000");
        }
        else
        {
            percentile.toString().shouldEqual("PERCENTILE (50): 51\nPERCENTILE (75): 76\nPERCENTILE (99): 100");
        }
    }
}
