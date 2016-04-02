module stats.sum;

import std.stdio, std.conv, std.format, std.traits, std.math;
import stats, common.options;

version(unittest)
{
    import unit_threaded;
}

class Sum(T) : Stats!(T)
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
    }

    void finish()
    {
    }

    override string toString()
    {
        static if (isFloatingPoint!(T))
        {
            return format("SUM: %.4f", total);
        }
        else
        {
            return format("SUM: %d", total);
        }

    }
}

version(unittest)
{
    @Types!(short, int, long, float, double)
    void testSmallNum(T)()
    {
        Options opts;
        Stats!T sum = initStats!(T)("sum", opts);
        sum.add(1);
        sum.add(1);
        sum.add(1);
        sum.finish();
        static if (isFloatingPoint!(T))
        {
            sum.toString().shouldEqual("SUM: 3.0000");
        }
        else
        {
            sum.toString().shouldEqual("SUM: 3");
        }
    }

    @Types!(short, int, long, float, double)
    void testLargeNum(T)()
    {
        Options opts;
        Stats!T sum = initStats!(T)("sum", opts);
        sum.add(1);
        sum.add(2);
        sum.add(3);
        sum.add(4);
        sum.add(5);
        sum.add(6);
        sum.add(7);
        sum.add(8);
        sum.add(9);
        sum.add(10);
        sum.finish();
        static if (isFloatingPoint!(T))
        {
            sum.toString().shouldEqual("SUM: 55.0000");
        }
        else
        {
            sum.toString().shouldEqual("SUM: 55");
        }
    }
}
