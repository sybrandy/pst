module stats.mean;

import std.stdio, std.traits, std.math, std.conv, std.format;
import stats, common.options;

version(unittest)
{
    import unit_threaded;
}

class Mean(T) : Stats!(T)
{
    static if (isFloatingPoint!(T))
    {
        double total;
    }
    else
    {
        static if (isSigned!(T))
        {
            long total;
        }
        else
        {
            static if (isNumeric!(T))
            {
                ulong total;
            }
        }
    }
    ulong numVals;
    T result;

    this(Options opts)
    {
    }

    void add(T val)
    {
        static if (isFloatingPoint!(T))
        {
            if (isNaN(total))
            {
                total = 0.0;
            }
        }
        total += val;
        numVals++;
    }

    void finish()
    {
        result = to!(T)(total / numVals);
    }

    override string toString()
    {
        static if (isFloatingPoint!(T))
        {
            return format("MEAN: %.4f", result);
        }
        else
        {
            return format("MEAN: %d", result);
        }
    }
}

version(unittest)
{
    @Types!(short, int, long, float, double)
    void testVerySimpleCase(T)()
    {
        Options opts;
        Stats!T mean = initStats!(T)("mean", opts);
        mean.add(1);
        mean.add(1);
        mean.add(1);
        mean.finish();
        static if (isFloatingPoint!(T))
        {
            mean.toString().shouldEqual("MEAN: 1.0000");
        }
        else
        {
            mean.toString().shouldEqual("MEAN: 1");
        }
    }

    @Types!(short, int, long, float, double)
    void testSimpleCase(T)()
    {
        Options opts;
        Stats!T mean = initStats!(T)("MEAN", opts);
        mean.add(1);
        mean.add(2);
        mean.add(3);
        mean.finish();
        static if (isFloatingPoint!(T))
        {
            mean.toString().shouldEqual("MEAN: 2.0000");
        }
        else
        {
            mean.toString().shouldEqual("MEAN: 2");
        }
    }
}
