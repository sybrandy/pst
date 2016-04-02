module stats.stddev;

import std.stdio, std.conv, std.format, std.traits, std.math, std.algorithm;
import stats, common.options;

version(unittest)
{
    import unit_threaded;
}

class Stddev(T) : Stats!(T)
{
    T[] vals;
    double result;

    this(Options opts)
    {
    }

    void add(T val)
    {
        vals ~= val;
    }

    void finish()
    {
        static if (isFloatingPoint!(T))
        {
            double mean = vals.sum(0.0) / vals.length;
        }
        else
        {
            double mean = vals.sum(0L) / vals.length;
        }
        result = vals.map!((a) => (a - mean) ^^ 2).sum(0.0) / vals.length;
    }

    override string toString()
    {
        return format("STDDEV: %.4f", result);
    }
}

version(unittest)
{
    @Types!(short, int, long, float, double)
    void testSmallNum(T)()
    {
        Options opts;
        Stats!T stddev = initStats!(T)("stddev", opts);
        stddev.add(1);
        stddev.add(1);
        stddev.add(1);
        stddev.finish();
        stddev.toString().shouldEqual("STDDEV: 0.0000");
    }

    @Types!(short, int, long, float, double)
    void test8Vals(T)()
    {
        Options opts;
        Stats!T stddev = initStats!(T)("stddev", opts);
        stddev.add(2);
        stddev.add(4);
        stddev.add(4);
        stddev.add(4);
        stddev.add(5);
        stddev.add(5);
        stddev.add(7);
        stddev.add(9);
        stddev.finish();
        stddev.toString().shouldEqual("STDDEV: 4.0000");
    }
}
